package l2s.gameserver.model.base;

/**
 * Author: VISTALL
 * Date:  11:53/01.12.2010
 */
public enum AcquireType
{
	/*0*/NORMAL,
	/*1*/FISHING,
	/*2*/CLAN,
	/*3*/SUB_UNIT,
	/*4*/TRANSFORMATION,
	/*5*/CERTIFICATION,
	/*6*/DUAL_CERTIFICATION,
	/*7*/COLLECTION,
	/*8*/TRANSFER_CARDINAL,
	/*9*/TRANSFER_EVA_SAINTS,
	/*10*/TRANSFER_SHILLIEN_SAINTS,
	/*11*/GENERAL,
	/*12*/NOBLESSE,
	/*13*/HERO,
	/*14*/GM,
	/*15*/CHAOS,
	/*16*/DUAL_CHAOS,
	/*17*/ABILITY,
	/*18*/HONORABLE_NOBLESSE,
	/*19*/ALCHEMY(140),
	/*20*/MULTICLASS,
	/*21*/CUSTOM,
	/*22*/CUSTOM1;

	public static final AcquireType[] VALUES = AcquireType.values();

	private final int _id;

	private AcquireType(int id)
	{
		_id = id;
	}

	private AcquireType()
	{
		_id = ordinal();
	}

	public int getId()
	{
		return _id;
	}

	public static AcquireType getById(int id)
	{
		for(AcquireType at : VALUES)
		{
			if(at.getId() == id)
				return at;
		}
		return null;
	}

	public static AcquireType transferType(int classId)
	{
		switch(classId)
		{
			case 97:
				return TRANSFER_CARDINAL;
			case 105:
				return TRANSFER_EVA_SAINTS;
			case 112:
				return TRANSFER_SHILLIEN_SAINTS;
		}

		return null;
	}

	public int transferClassId()
	{
		switch(this)
		{
			case TRANSFER_CARDINAL:
				return 97;
			case TRANSFER_EVA_SAINTS:
				return 105;
			case TRANSFER_SHILLIEN_SAINTS:
				return 112;
		}

		return 0;
	}
}
