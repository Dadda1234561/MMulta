package l2s.gameserver.model.actor.instances.player;

import l2s.gameserver.geometry.Location;

public class BookMark
{
	public final int _id, x, y, z;
	private int icon;
	private String name, acronym;

	public BookMark(int id, Location loc, int aicon, String aname, String aacronym)
	{
		this(id, loc.x, loc.y, loc.z, aicon, aname, aacronym);
	}

	public BookMark(int id, int _x, int _y, int _z, int aicon, String aname, String aacronym)
	{
		_id = id;
		x = _x;
		y = _y;
		z = _z;
		setIcon(aicon);
		setName(aname);
		setAcronym(aacronym);
	}

	public BookMark setIcon(int val)
	{
		icon = val;
		return this;
	}

	public int getIcon()
	{
		return icon;
	}

	public BookMark setName(String val)
	{
		name = val.length() > 32 ? val.substring(0, 32) : val;
		return this;
	}

	public String getName()
	{
		return name;
	}

	public BookMark setAcronym(String val)
	{
		acronym = val.length() > 4 ? val.substring(0, 4) : val;
		return this;
	}

	public String getAcronym()
	{
		return acronym;
	}

	public int getId() {
		return _id;
	}
}