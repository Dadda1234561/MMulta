package l2s.gameserver.network.l2.s2c.homunculus;

import l2s.gameserver.data.xml.holder.HomunculusHolder;
import l2s.gameserver.model.HomunculusProbData;
import l2s.gameserver.network.l2.s2c.L2GameServerPacket;

import java.util.Collection;
import java.util.stream.Collectors;

public class ExHomunculusCreateProbList extends L2GameServerPacket {

    private final Collection<HomunculusProbData> _probList;

    public ExHomunculusCreateProbList() {
        this._probList = HomunculusHolder.getInstance().getHomunculusProbData();
    }

    @Override
    protected void writeImpl() {
        writeD(_probList.size()); // nSize
        for (HomunculusProbData probData : _probList) {
            writeD(probData.getIndex()); // nIndex
            writeD(probData.getProbPerMillion()); // nProbPerMillion
        }
    }
}
