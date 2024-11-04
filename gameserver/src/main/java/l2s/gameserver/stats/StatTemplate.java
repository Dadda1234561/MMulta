package l2s.gameserver.stats;

import java.util.*;

import l2s.commons.annotations.NotNull;
import l2s.commons.lang.ArrayUtils;
import l2s.gameserver.model.items.GearScoreType;
import l2s.gameserver.stats.funcs.Func;
import l2s.gameserver.stats.funcs.FuncTemplate;
import l2s.gameserver.stats.triggers.TriggerInfo;
import org.slf4j.LoggerFactory;

/**
 * @author VISTALL
 * @date 23:05/22.01.2011
 */
public class StatTemplate
{
	protected FuncTemplate[] _funcTemplates = FuncTemplate.EMPTY_ARRAY;
	protected List<TriggerInfo> _triggerList = Collections.emptyList();

	public List<TriggerInfo> getTriggerList()
	{
		return _triggerList;
	}

	public void addTrigger(TriggerInfo f)
	{
		if(_triggerList.isEmpty())
			_triggerList = new ArrayList<TriggerInfo>(4);
		_triggerList.add(f);
	}

	public void attachFunc(FuncTemplate f)
	{
		_funcTemplates = ArrayUtils.add(_funcTemplates, f);
	}

	public void attachFuncs(FuncTemplate... funcs)
	{
		for(FuncTemplate f : funcs)
			attachFunc(f);
	}

	public FuncTemplate[] getAttachedFuncs()
	{
		return _funcTemplates;
	}

	public FuncTemplate[] removeAttachedFuncs()
	{
		FuncTemplate[] funcs = _funcTemplates;
		_funcTemplates = FuncTemplate.EMPTY_ARRAY;
		return funcs;
	}

	public Func[] getStatFuncs(Object owner)
	{
		if(_funcTemplates.length == 0)
			return Func.EMPTY_FUNC_ARRAY;

		Func[] funcs = new Func[_funcTemplates.length];
		for(int i = 0; i < funcs.length; i++)
		{
			funcs[i] = _funcTemplates[i].getFunc(owner);
		}
		return funcs;
	}

	// <exType, <enchantLvl, Value>> = Additional Gear Scores for extra states..
	private final Map<GearScoreType, Map<Integer, Integer>> _exGearScores = new HashMap<>();
	public boolean hasNoGearScore() {
		return _exGearScores.isEmpty();
	}


	public Map<Integer, Integer> getGearScores(GearScoreType type) {
		return _exGearScores.getOrDefault(type, Collections.emptyMap());
	}

	public int getGearScore(@NotNull GearScoreType type, int levelOrItemId) {
		switch (type) {
			case GS_BASE:
			case GS_BLESS:
			case GS_ANY_ENSOUL:
			case GS_ANY_VARIATION:
				return _exGearScores.getOrDefault(type, Collections.emptyMap()).getOrDefault(0, 0);
			case GS_VARIATION_BY_MINERAL_ID:
			case GS_VARIATION_BY_OPTION_ID:
			case GS_ANY_ENSOUL_BY_OPTION_ID:
			case GS_HAS_SKILL:
			case GS_HAS_ENCHANTED_SKILL:
			case GS_NORMAL:
				return _exGearScores.getOrDefault(type, Collections.emptyMap()).getOrDefault(levelOrItemId, 0);
			default:
				LoggerFactory.getLogger(StatTemplate.class).warn("Unknown GearScoreType: " + type);
				break;
		}
		return _exGearScores.getOrDefault(type, Collections.emptyMap()).getOrDefault(levelOrItemId, 0);
	}

	public int getGearScore(int enchantLevel) {
		return getGearScore(GearScoreType.GS_NORMAL, enchantLevel);
	}

	public void setGearScore(GearScoreType type, int atLevel, Number value) {
		_exGearScores.computeIfAbsent(type, integer -> new HashMap<>()).put(atLevel, value.intValue());
	}

	public void resetGearScore() {
		_exGearScores.clear();
	}
}
