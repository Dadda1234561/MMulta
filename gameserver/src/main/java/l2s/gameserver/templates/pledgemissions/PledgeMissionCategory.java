package l2s.gameserver.templates.pledgemissions;

import java.util.NoSuchElementException;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 29.09.2019
 **/
public enum PledgeMissionCategory {
	/*0*/NONE,
	/*1*/GENERAL,
	/*2*/INTENSIVE,
	/*3*/ACHIEVEMENT,
	/*4*/EVENT;

	public static final PledgeMissionCategory[] VALUES = values();

	public static PledgeMissionCategory valueOfXml(String name) {
		for(PledgeMissionCategory category : VALUES) {
			if(category.toString().equalsIgnoreCase(name))
				return category;
		}
		throw new NoSuchElementException("Unknown name '" + name + "' for enum PledgeMissionCategory");
	}
}
