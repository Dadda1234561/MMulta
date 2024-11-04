package l2s.gameserver.data.xml.holder;

import java.util.HashMap;
import java.util.Map;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.templates.SymbolSealInfo;

/**
 * @author nexvill
**/
public class SymbolSealHolder extends AbstractHolder
{
	private static final SymbolSealHolder _instance = new SymbolSealHolder();

	private final Map<Integer, SymbolSealInfo> _symbolSealInfos = new HashMap<>();

	public static SymbolSealHolder getInstance()
	{
		return _instance;
	}
	
	public void addSymbolSealInfo(SymbolSealInfo info)
	{
		_symbolSealInfos.put(info.getClassId(), info);
	}
	
	public SymbolSealInfo getSymbolSealInfo(int classId)
	{
		return _symbolSealInfos.get(classId);
	}

	@Override
	public int size()
	{
		return _symbolSealInfos.size();
	}

	@Override
	public void clear()
	{
		_symbolSealInfos.clear();
	}
}
