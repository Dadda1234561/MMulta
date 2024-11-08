package l2s.gameserver.network.l2.s2c;

import l2s.gameserver.geometry.Location;
import l2s.gameserver.instancemanager.SoDManager;
import l2s.gameserver.instancemanager.SoIManager;

/**
 * Probably the destination coordinates where you should fly your clan's airship.<BR>
 * Exactly at the specified coordinates an airship controller is spawned.<BR>
 * Sent while being in Gracia, when world map is opened, in response to RequestSeedPhase.<BR>
 * FE A1 00		- opcodes<BR>
 * 02 00 00 00	- list size<BR>
 * <BR>
 * B7 3B FC FF	- x<BR>
 * 38 D8 03 00	- y<BR>
 * EB 10 00 00	- z<BR>
 * D3 0A 00 00	- sysmsg id<BR>
 * <BR>
 * F6 BC FC FF	- x<BR>
 * 48 37 03 00	- y<BR>
 * 30 11 00 00	- z<BR>
 * CE 0A 00 00	- sysmsg id
 * 
 * @done by n0nam3
 */
public class ExShowSeedMapInfo extends L2GameServerPacket
{
	@Override
	protected void writeImpl()
	{
		writeD(3);
		for(int i = 1; i <= 3; i++)
		{
			writeD(i); // [TODO]: Grand Crusade
			switch(i)
			{
				case 1: // Seed of Destruction
					if(SoDManager.isAttackStage())
						writeD(2771);
					else
						writeD(2772);
					break;
				case 2: // Seed of Immortality
					writeD(SoIManager.getCurrentStage() + 2765);
					break;
				case 3: // Seed of Annihillation
					writeD(/*SoAManager.getCurrentStage() + */3301);
					break;
			}
		}
	}
}
