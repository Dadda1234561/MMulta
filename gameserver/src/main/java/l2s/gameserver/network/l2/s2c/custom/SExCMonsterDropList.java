package l2s.gameserver.network.l2.s2c.custom;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 15.07.2022
 **/
public class SExCMonsterDropList extends ACustomServerPacket {
	private final int npcId;
	private final int level;
	private final long expReward;
	private final long spReward;
	private final int maxHp;
	private final int currHp;
	private final int maxMp;
	private final int currMp;
	private final int pAtk;
	private final int mAtk;
	private final int pDef;
	private final int mDef;
	private final List<DropItem> dropList = new ArrayList<>();

	public SExCMonsterDropList(int npcId, int level, long expReward, long spReward, int maxHp, int currHp, int maxMp, int currMp, int pAtk, int mAtk, int pDef, int mDef) {
		this.npcId = npcId;
		this.level = level;
		this.expReward = expReward;
		this.spReward = spReward;
		this.maxHp = maxHp;
		this.currHp = currHp;
		this.maxMp = maxMp;
		this.currMp = currMp;
		this.pAtk = pAtk;
		this.mAtk = mAtk;
		this.pDef = pDef;
		this.mDef = mDef;
	}

	public SExCMonsterDropList addDrop(int type, int itemId, int enchant, long minAmount, long maxAmount, String chance) {
		dropList.add(new DropItem(type, itemId, enchant, minAmount, maxAmount, chance));
		return this;
	}

	@Override
	protected void writeCustomImpl() {
		writeC(SExCustomOpcode.S_EX_C_MONSTER_DROP_LIST);
		writeD(npcId + 1000000);
		writeC(level);
		writeQ(0); //expReward
		writeQ(0); //spReward
		writeD(0); //maxHp
		writeD(0); //currHp
		writeD(0); //maxMp
		writeD(0); //currMp
		writeD(0); //pAtk
		writeD(0); //mAtk
		writeD(0); //pDef
		writeD(0); //mDef

		writeD(dropList.size());
		for (DropItem d : dropList) {
			writeC(d.type());
			writeD(d.itemId());
			writeC(d.enchant());
			writeQ(d.minAmount());
			writeQ(d.maxAmount());
			writeString(d.chance());
		}
	}

    public static final class DropItem {
        private final int type;
        private final int itemId;
        private final int enchant;
        private final long minAmount;
        private final long maxAmount;
        private final String chance;

        public DropItem(int type, int itemId, int enchant, long minAmount, long maxAmount, String chance) {
            this.type = type;
            this.itemId = itemId;
            this.enchant = enchant;
            this.minAmount = minAmount;
            this.maxAmount = maxAmount;
            this.chance = chance;
        }

        public int type() {
            return type;
        }

        public int itemId() {
            return itemId;
        }

        public int enchant() {
            return enchant;
        }

        public long minAmount() {
            return minAmount;
        }

        public long maxAmount() {
            return maxAmount;
        }

        public String chance() {
            return chance;
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == this) return true;
            if (obj == null || obj.getClass() != this.getClass()) return false;
			DropItem that = (DropItem) obj;
            return this.type == that.type &&
                    this.itemId == that.itemId &&
                    this.enchant == that.enchant &&
                    this.minAmount == that.minAmount &&
                    this.maxAmount == that.maxAmount &&
                    Objects.equals(this.chance, that.chance);
        }

        @Override
        public int hashCode() {
            return Objects.hash(type, itemId, enchant, minAmount, maxAmount, chance);
        }

        @Override
        public String toString() {
            return "DropItem[" +
                    "type=" + type + ", " +
                    "itemId=" + itemId + ", " +
                    "enchant=" + enchant + ", " +
                    "minAmount=" + minAmount + ", " +
                    "maxAmount=" + maxAmount + ", " +
                    "chance=" + chance + ']';
        }
    }
}
