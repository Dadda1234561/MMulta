package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.templates.item.support.variation.VariationResult;

import java.util.List;

/**
 * @author sharp on 08.01.2023
 * t.me/sharp1que
 */
public class ExApplyVariationOption extends L2GameServerPacket
{
    final boolean bResult;
    final int nVariationItemSID, nItemOption1, nItemOption2;


    public ExApplyVariationOption(VariationResult result)
    {
        bResult = result.isSuccess();
        this.nVariationItemSID = result.itemObjectId();
        this.nItemOption1 = result.option1ID();
        this.nItemOption2 = result.option2ID();
    }


    public ExApplyVariationOption(boolean isSuccess, int nVariationItemSID, int nItemOption1, int nItemOption2)
    {
        bResult = isSuccess;
        this.nVariationItemSID = nVariationItemSID;
        this.nItemOption1 = nItemOption1;
        this.nItemOption2 = nItemOption2;
    }

    @Override
    protected void writeImpl()
    {
        writeC(bResult);
        writeD(nVariationItemSID);
        writeD(nItemOption1);
        writeD(nItemOption2);
    }
}
