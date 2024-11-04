package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.templates.item.support.Ensoul;

import java.util.Collections;
import java.util.Map;

/**
 * @author Bonux
**/
public class ExEnSoulExtractionResult extends L2GameServerPacket
{
	public static final L2GameServerPacket FAIL = new ExEnSoulExtractionResult();

	private final boolean _success;
	private final Map<Integer, Ensoul> _normalEnsouls;
	private final Map<Integer, Ensoul> _specialEnsouls;

	private ExEnSoulExtractionResult()
	{
		_success = false;
		_normalEnsouls = Collections.emptyMap();
		_specialEnsouls = Collections.emptyMap();
	}

	public ExEnSoulExtractionResult(Map<Integer, Ensoul> normalEnsouls, Map<Integer, Ensoul> specialEnsouls)
	{
		_success = true;
		_normalEnsouls = normalEnsouls;
		_specialEnsouls = specialEnsouls;
	}

	@Override
	protected final void writeImpl()
	{
		writeC(_success);
		if(_success)
		{
			writeC(2);
			for (int i = 1; i <= 2; i++)
			{
				Ensoul ensoul = _normalEnsouls.getOrDefault(i, null);
				writeD(ensoul == null ? 0x00 : ensoul.getId());
			}

			writeC(1);
			for (int i = 1; i <= 1; i++)
			{
				Ensoul ensoul = _specialEnsouls.getOrDefault(i, null);
				writeD(ensoul == null ? 0x00 : ensoul.getId());
			}
		}
	}
}