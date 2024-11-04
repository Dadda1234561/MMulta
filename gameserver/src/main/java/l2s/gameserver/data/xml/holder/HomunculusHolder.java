package l2s.gameserver.data.xml.holder;

import java.util.*;

import l2s.commons.data.xml.AbstractHolder;
import l2s.commons.util.Rnd;
import l2s.gameserver.model.HomunculusProbData;
import l2s.gameserver.templates.HomunculusTemplate;

/**
 * @author nexvill
**/
public class HomunculusHolder extends AbstractHolder
{
	private static final HomunculusHolder _instance = new HomunculusHolder();

	private final Map<Integer, HomunculusTemplate> _homunculusInfos = new HashMap<>();

	public static HomunculusHolder getInstance()
	{
		return _instance;
	}
	
	public void addHomunculusInfo(HomunculusTemplate info)
	{
		_homunculusInfos.put(info.getId(), info);
	}
	
	public HomunculusTemplate getHomunculusInfo(int id)
	{
		return _homunculusInfos.get(id);
	}

	//FIXME: Найти больше инфы
	public Collection<HomunculusProbData> getHomunculusProbData() {
		if (_homunculusInfos.isEmpty()) {
			return Collections.emptyList();
		}

		//TODO: Пока выдаем разные значения..
		Collection<HomunculusProbData> probData = new ArrayList<>();
		for (HomunculusTemplate template : _homunculusInfos.values()) {
			probData.add(new HomunculusProbData(template.getId(), Rnd.get(1000, 100000)));
		}

		return probData;
	}

	@Override
	public int size()
	{
		return _homunculusInfos.size();
	}

	@Override
	public void clear()
	{
		_homunculusInfos.clear();
	}
}
