package l2s.gameserver.data.xml.parser;

import java.io.File;
import java.util.Iterator;

import org.dom4j.Element;

import l2s.commons.data.xml.AbstractParser;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.SymbolSealHolder;
import l2s.gameserver.templates.SymbolSealInfo;

/**
 * @author nexvill
**/
public final class SymbolSealParser extends AbstractParser<SymbolSealHolder>
{
	private static final SymbolSealParser _instance = new SymbolSealParser();

	public static SymbolSealParser getInstance()
	{
		return _instance;
	}

	private SymbolSealParser()
	{
		super(SymbolSealHolder.getInstance());
	}

	@Override
	public File getXMLPath()
	{
		return new File(Config.DATAPACK_ROOT, "data/symbol_seal.xml");
	}

	@Override
	public String getDTDFileName()
	{
		return "symbol_seal.dtd";
	}

	@Override
	protected void readData(Element rootElement) throws Exception 
	{
		for (Iterator<Element> iterator = rootElement.elementIterator("class"); iterator.hasNext(); ) 
		{
			Element element = iterator.next();

			int id = parseInt(element, "id");
			int skill1_id = parseInt(element, "skill1_id");
			int skill2_id = parseInt(element, "skill2_id");
			int skill3_id = parseInt(element, "skill3_id");
			
			getHolder().addSymbolSealInfo(new SymbolSealInfo(id, skill1_id, skill2_id, skill3_id));
		}
	}
}