package l2s.gameserver.network.l2.c2s;

import l2s.gameserver.handler.items.impl.NameColorItemHandler;
import l2s.gameserver.model.ColorHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.network.l2.components.SystemMsg;
import l2s.gameserver.utils.GameStringUtils;

public class RequestChangeNicknameColorIcon extends L2GameClientPacket
{
    private static final ColorHolder[] COLORS =
    {
          new ColorHolder(162,249,236),
          new ColorHolder(240,214,54),
          new ColorHolder(255,147,147),
          new ColorHolder(255,74,125),
          new ColorHolder(255,251,153),
          new ColorHolder(240,155,253),
          new ColorHolder(147,93,255),
          new ColorHolder(162,255,0),
          new ColorHolder(0,170,164),
          new ColorHolder(175,152,120),
          new ColorHolder(158,103,75),
          new ColorHolder(155,155,155),
          new ColorHolder(255,204,0),
          new ColorHolder(255,160,32),
          new ColorHolder(255,104,255),
          new ColorHolder(255,0,0),
          new ColorHolder(0,220,255),
    };

    private int _itemId;
    private int _colorNum;

    private String _title;

    @Override
    protected boolean readImpl()
    {
        _itemId = readD();
        _colorNum = readD();
        _title = readString();
        return true;
    }

    @Override
    protected void runImpl()
    {
        Player activeChar = getClient().getActiveChar();
        if (activeChar == null)
            return;

        if (_colorNum < 0 || _colorNum >= COLORS.length)
            return;

        ItemInstance item = activeChar.getInventory().getItemByItemId(_itemId);
        if (item == null)
            return;

        if (!(item.getTemplate().getHandler() instanceof NameColorItemHandler))
            return;

        _title = GameStringUtils.checkTitle(_title, 16, 32, item.getItemId() != 95892);

        if (activeChar.consumeItem(item.getItemId(), 1, true))
        {
            final ColorHolder holder = COLORS[_colorNum];

            activeChar.setTitle(_title);
            activeChar.setTitleColor((holder.getRed() & 0xFF) + ((holder.getGreen() & 0xFF) << 8) + ((holder.getBlue() & 0xFF) << 16));
            activeChar.sendPacket(SystemMsg.YOUR_TITLE_HAS_BEEN_CHANGED);
            activeChar.broadcastUserInfo(true);
        }
    }
}