package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.BookMark;

import java.util.List;

public class ExGetBookMarkInfoPacket extends L2GameServerPacket
{
	private final int bookmarksCapacity;
	private final List<BookMark> bookmarks;

	public ExGetBookMarkInfoPacket(Player player)
	{
		bookmarksCapacity = player.getBookMarkList().getCapacity();
		bookmarks = player.getBookMarkList().getBookMarks();
	}

	@Override
	protected void writeImpl()
	{
		writeD(0x00); // должно быть 0
		writeD(bookmarksCapacity);
		writeD(bookmarks.size());
		for (int i = 0; i < bookmarks.size(); i++)
		{
			BookMark bookmark = bookmarks.get(i);
			writeD((i + 1));
			writeD(bookmark.x);
			writeD(bookmark.y);
			writeD(bookmark.z);
			writeS(bookmark.getName());
			writeD(bookmark.getIcon());
			writeS(bookmark.getAcronym());
		}
	}
}