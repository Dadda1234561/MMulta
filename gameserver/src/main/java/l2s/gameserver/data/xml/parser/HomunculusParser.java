package l2s.gameserver.data.xml.parser;

import java.io.File;
import java.util.Iterator;

import org.dom4j.Element;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.HomunculusHolder;
import l2s.gameserver.templates.HomunculusTemplate;

/**
 * @author nexvill
**/
public final class HomunculusParser extends AbstractParser<HomunculusHolder>
{
	private static final HomunculusParser _instance = new HomunculusParser();

	public static HomunculusParser getInstance()
	{
		return _instance;
	}

	private HomunculusParser()
	{
		super(HomunculusHolder.getInstance());
	}

	@Override
	public File getXMLPath()
	{
		return new File(Config.DATAPACK_ROOT, "data/homunculus_data.xml");
	}

	@Override
	public String getDTDFileName()
	{
		return "homunculus_data.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception 
	{
		for (Iterator<Element> iterator = rootElement.elementIterator("homunculus"); iterator.hasNext(); ) 
		{
			Element element = iterator.next();

			int id = parseInt(element, "id");
			int type = parseInt(element, "type");
			int basic_skill = parseInt(element, "basic_skill");
			int basic_skill_level = parseInt(element, "basic_skill_level");
			int skill1_id = parseInt(element, "skill1_id");
			int skill2_id = parseInt(element, "skill2_id");
			int skill3_id = parseInt(element, "skill3_id");
			int skill4_id = parseInt(element, "skill4_id");
			int skill5_id = parseInt(element, "skill5_id");
			int hpLevel1 = parseInt(element, "hpLevel1");
			int atkLevel1 = parseInt(element, "atkLevel1");
			int defLevel1 = parseInt(element, "defLevel1");
			int expToLevel2 = parseInt(element, "expToLevel2");
			int hpLevel2 = parseInt(element, "hpLevel2");
			int atkLevel2 = parseInt(element, "atkLevel2");
			int defLevel2 = parseInt(element, "defLevel2");
			int expToLevel3 = parseInt(element, "expToLevel3");
			int hpLevel3 = parseInt(element, "hpLevel3");
			int atkLevel3 = parseInt(element, "atkLevel3");
			int defLevel3 = parseInt(element, "defLevel3");
			int expToLevel4 = parseInt(element, "expToLevel4");
			int hpLevel4 = parseInt(element, "hpLevel4");
			int atkLevel4 = parseInt(element, "atkLevel4");
			int defLevel4 = parseInt(element, "defLevel4");
			int expToLevel5 = parseInt(element, "expToLevel5");
			int hpLevel5 = parseInt(element, "hpLevel5");
			int atkLevel5 = parseInt(element, "atkLevel5");
			int defLevel5 = parseInt(element, "defLevel5");
			int expToLevel6 = parseInt(element, "expToLevel6");
			int critRate = parseInt(element, "critRate");
			
			getHolder().addHomunculusInfo(new HomunculusTemplate(id, type, basic_skill, basic_skill_level, skill1_id, skill2_id, skill3_id, skill4_id, skill5_id, hpLevel1, atkLevel1, defLevel1, expToLevel2, hpLevel2, atkLevel2, defLevel2, expToLevel3, hpLevel3, atkLevel3, defLevel3, expToLevel4, hpLevel4, atkLevel4, defLevel4, expToLevel5, hpLevel5, atkLevel5, defLevel5, expToLevel6, critRate));
		}
	}
}