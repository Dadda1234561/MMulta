package l2s.gameserver.templates;
/**
 * @author nexvill
**/
public class SymbolSealInfo
{
	private final int _classId;
	
	private final int _skill1_id;
	private final int _skill2_id;
	private final int _skill3_id;

	public SymbolSealInfo(int classId, int skill1_id, int skill2_id, int skill3_id)
	{
		_classId = classId;
		
		_skill1_id = skill1_id;
		_skill2_id = skill2_id;
		_skill3_id = skill3_id;
	}

	public int getClassId()
	{
		return _classId;
	}
	
	public int getSkill1Id()
	{
		return _skill1_id;
	}
	
	public int getSkill2Id()
	{
		return _skill2_id;
	}
	
	public int getSkill3Id()
	{
		return _skill3_id;
	}
}