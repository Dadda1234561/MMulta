package l2s.gameserver.data.xml.parser;

import java.io.File;
import java.util.Iterator;

import org.dom4j.Element;
import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.JumpTracksHolder;
import l2s.gameserver.geometry.Location;
import l2s.gameserver.templates.jump.JumpPoint;
import l2s.gameserver.templates.jump.JumpTrack;
import l2s.gameserver.templates.jump.JumpWay;

/**
 * @author Bonux
 * @date  04/11/2011 18:10
 */
public final class JumpTracksParser extends AbstractParser<JumpTracksHolder>
{
	private static final JumpTracksParser _instance = new JumpTracksParser();

	public static JumpTracksParser getInstance()
	{
		return _instance;
	}

	protected JumpTracksParser()
	{
		super(JumpTracksHolder.getInstance());
	}

	@Override
	public File getXMLPath()
	{
		return new File(Config.DATAPACK_ROOT, "data/jumping_tracks.xml");
	}

	@Override
	public String getDTDFileName()
	{
		return "jumping_tracks.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception
	{
		for(Iterator<Element> iterator = rootElement.elementIterator(); iterator.hasNext();)
		{
			Element trackElement = iterator.next();

			int trackId = Integer.parseInt(trackElement.attributeValue("id"));
			int x = Integer.parseInt(trackElement.attributeValue("x"));
			int y = Integer.parseInt(trackElement.attributeValue("y"));
			int z = Integer.parseInt(trackElement.attributeValue("z"));

			JumpTrack jumpTrack = new JumpTrack(trackId, x, y, z);

			for(Iterator<Element> wayIterator = trackElement.elementIterator("way"); wayIterator.hasNext();)
			{
				Element wayElement = wayIterator.next();

				int wayId = Integer.parseInt(wayElement.attributeValue("id"));

				JumpWay jumpWay = new JumpWay(wayId);

				for(Iterator<Element> pointIterator = wayElement.elementIterator("point"); pointIterator.hasNext();)
				{
					Element pointElement = pointIterator.next();

					int x1 = Integer.parseInt(pointElement.attributeValue("x"));
					int y1 = Integer.parseInt(pointElement.attributeValue("y"));
					int z1 = Integer.parseInt(pointElement.attributeValue("z"));
					int nextWayId = Integer.parseInt(pointElement.attributeValue("next_way_id"));

					jumpWay.addPoint(new JumpPoint(x1, y1, z1, nextWayId));
				}
				jumpTrack.addWay(jumpWay);
			}
			getHolder().addTrack(jumpTrack);
		}
	}
}
