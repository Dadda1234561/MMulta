package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.model.Player;
import l2s.gameserver.model.actor.instances.player.ShortCut;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.skills.TimeStamp;

/**
 * @author VISTALL
 * @date 7:48/29.03.2011
 */
public abstract class ShortCutPacket extends L2GameServerPacket
{
	public static ShortcutInfo convert(Player player, ShortCut shortCut)
	{
		ShortcutInfo shortcutInfo = null;
		int page = shortCut.getSlot() + shortCut.getPage() * 12;
		switch(shortCut.getType())
		{
			case ITEM:
				int reuseGroup = -1,
				currentReuse = 0,
				reuse = 0,
				variation1Id = 0,
				variation2Id = 0;
				ItemInstance item = player.getInventory().getItemByObjectId(shortCut.getId());
				if(item != null)
				{
					variation1Id = item.getVariation1Id();
					variation2Id = item.getVariation2Id();
					reuseGroup = item.getTemplate().getDisplayReuseGroup();
					if(item.getTemplate().getReuseDelay() > 0)
					{
						TimeStamp timeStamp = player.getSharedGroupReuse(item.getTemplate().getReuseGroup());
						if(timeStamp != null)
						{
							currentReuse = (int) (timeStamp.getReuseCurrent() / 1000L);
							reuse = (int) (timeStamp.getReuseBasic() / 1000L);
						}
					}
				}
				shortcutInfo = new ItemShortcutInfo(shortCut.getType(), page, shortCut.getId(), reuseGroup, currentReuse, reuse, variation1Id, variation2Id, shortCut.getCharacterType(), shortCut.isToggled());
				break;
			case SKILL:
				shortcutInfo = new SkillShortcutInfo(shortCut.getType(), page, shortCut.getId(), shortCut.getLevel(), shortCut.getCharacterType(), shortCut.isToggled());
				break;
			default:
				shortcutInfo = new ShortcutInfo(shortCut.getType(), page, shortCut.getId(), shortCut.getCharacterType(), shortCut.isToggled());
				break;
		}
		return shortcutInfo;
	}

	protected static class ItemShortcutInfo extends ShortcutInfo
	{
		private int _reuseGroup;
		private int _currentReuse;
		private int _basicReuse;
		private int _variation1Id;
		private int _variation2Id;

		public ItemShortcutInfo(ShortCut.ShortCutType type, int page, int id, int reuseGroup, int currentReuse, int basicReuse, int variation1Id, int variation2Id, int characterType, boolean isActive)
		{
			super(type, page, id, characterType, isActive);
			_reuseGroup = reuseGroup;
			_currentReuse = currentReuse;
			_basicReuse = basicReuse;
			_variation1Id = variation1Id;
			_variation2Id = variation2Id;
		}

		@Override
		protected void write0(ShortCutPacket p)
		{
			p.writeD(_id);
			p.writeD(_characterType);
			p.writeD(_reuseGroup);
			p.writeD(_currentReuse);
			p.writeD(_basicReuse);
			p.writeD(_variation1Id);
			p.writeD(_variation2Id);
			p.writeD(0x00); //TODO: [Bonux] ??HARMONY??
		}
	}

	protected static class SkillShortcutInfo extends ShortcutInfo
	{
		private final int _level;

		public SkillShortcutInfo(ShortCut.ShortCutType type, int page, int id, int level, int characterType, boolean isActive)
		{
			super(type, page, id, characterType, isActive);
			_level = level;
		}

		public int getLevel()
		{
			return _level;
		}

		@Override
		protected void write0(ShortCutPacket p)
		{
			p.writeD(_id);
			p.writeD(_level);
			p.writeD(_id); //TODO [VISTALL] skill reuse group
			p.writeC(0x00);
			p.writeD(_characterType);
		}
	}

	protected static class ShortcutInfo
	{
		protected final ShortCut.ShortCutType _type;
		protected final int _page;
		protected final int _id;
		protected final boolean _toggled;
		protected final int _characterType;

		public ShortcutInfo(ShortCut.ShortCutType type, int page, int id, int characterType, boolean isActive)
		{
			_type = type;
			_page = page;
			_id = id;
			_characterType = characterType;
			_toggled = isActive;
		}

		protected void write(ShortCutPacket p)
		{
			p.writeD(_type.ordinal());
			p.writeD(_page);
			p.writeC(_toggled);
			write0(p);
		}

		protected void write0(ShortCutPacket p)
		{
			p.writeD(_id);
			p.writeD(_characterType);
		}
	}
}
