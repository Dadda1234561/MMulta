package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.model.HomunculusProbData;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.List;

public class ExHomunculusCouponProbList extends L2GameServerPacket {

    private final int nSlotItemClassId;
    private final List<HomunculusProbData> probData;

    public ExHomunculusCouponProbList(int nSlotItemClassId, List<HomunculusProbData> probData) {
        this.nSlotItemClassId = nSlotItemClassId;
        this.probData = probData;
    }

    @Override
    protected void writeImpl() {
        writeD(nSlotItemClassId);
        writeD(probData.size());
        for (HomunculusProbData prob : probData) {
            writeD(prob.getIndex());
            writeD(prob.getProbPerMillion());
        }
    }
}
