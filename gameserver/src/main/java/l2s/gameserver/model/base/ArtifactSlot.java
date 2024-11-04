package l2s.gameserver.model.base;

import java.util.NoSuchElementException;

/**
 * @author Bonux (bonuxq@gmail.com)
 * @date 08.09.2019
 **/
public enum ArtifactSlot {
	BALANCE,
	ATTACK,
	PROTECTION,
	SUPPORT;

	public static final ArtifactSlot[] VALUES = values();

	public static ArtifactSlot valueOfXml(String name) {
		for (ArtifactSlot s : VALUES) {
			if (s.toString().equalsIgnoreCase(name))
				return s;
		}
		throw new NoSuchElementException("Unknown name '" + name + "' for enum ArtifactSlot");
	}
}
