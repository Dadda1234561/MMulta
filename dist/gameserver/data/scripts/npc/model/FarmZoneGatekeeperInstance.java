package npc.model;


import l2s.commons.collections.MultiValueSet;
import l2s.gameserver.data.xml.holder.AltDimensionHolder;
import l2s.gameserver.instancemanager.ReflectionManager;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.entity.AltDimension;
import l2s.gameserver.model.instances.NpcInstance;
import l2s.gameserver.templates.npc.NpcTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FarmZoneGatekeeperInstance extends NpcInstance
{
	private static final Logger _log = LoggerFactory.getLogger(FarmZoneGatekeeperInstance.class);

	public FarmZoneGatekeeperInstance(int objectId, NpcTemplate template, MultiValueSet<String> set)
	{
		super(objectId, template, set);
	}

	public void onBypassFeedback(Player player, String command)
	{
		if (command.startsWith("alt_dimension")) {
			String[] args = command.split(" ");
			if (args.length > 1) {
				int locationId = -1;
				try {
					locationId = Integer.parseInt(args[1]);
				} catch (NumberFormatException e) {
					_log.warn("Error happened while parsing location id for dimension. Error:", e);
				}

				if (locationId > 0) {
					AltDimension dimension = AltDimensionHolder.getInstance().getDimension(locationId);
					if (dimension == null) {
						_log.info("Not found dimension location with id = " + locationId);
						super.onBypassFeedback(player, command);
						return;
					}
					if (player.getRebirthCount() < dimension.getRebirths()) {
						if (player.isLangRus()) {
							player.sendScreenMessage("Недостаточно перерождений. Необходимо " + dimension.getRebirths() + " перерождений.");
						} else {
							player.sendScreenMessage("Not enough rebirths. " + dimension.getRebirths() + " is required to teleport.");
						}
						return;
					}
					player.teleToLocation(dimension.getRandomLocation(), ReflectionManager.ALT_DIMENSION);
				}
			}
		}

		if (command.startsWith("recipe_farm_1")) {
			player.teleToLocation(10280, -22872, -3680, ReflectionManager.MAIN); // Первобытный Остров
			return;
		} else if (command.startsWith("recipe_farm_2")) {
			player.teleToLocation(169018, -116302, -2432, ReflectionManager.MAIN); // Кузница Богов
			return;
		} else if (command.startsWith("recipe_farm_3")) {
			player.teleToLocation(187941, -74992, -2744, ReflectionManager.MAIN); // Гробница Императора
			return;
		} else if (command.startsWith("recipe_farm_4")) {
			player.teleToLocation(125768, -40840, -3744, ReflectionManager.MAIN); // Лагерь Фавнов Варка
			return;
		}

		if(command.startsWith("farm_low_1")) {
			player.teleToLocation(-12840, 21720, -3704, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_low_2")) {
			player.teleToLocation(216840, 83096, 896, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_low_3")) {
			player.teleToLocation(54840, 141400, -2784, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_low_4")) {
			player.teleToLocation(45704, 33416, -3712, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_low_5")) {
			player.teleToLocation(174104, 20328, -3248, ReflectionManager.MAIN);
		}

		else if (command.startsWith("farm_mid_1")) {
			player.teleToLocation(-47928, 60904, -3264, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_mid_2")) {
			player.teleToLocation(114040, 44104, -3504, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_mid_3")) {
			player.teleToLocation(159912, 21384, -3712, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_mid_4")) {
			player.teleToLocation(-54168, 77304, -4192, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_mid_5")) {
			player.teleToLocation(151704, -13800, -4448, ReflectionManager.MAIN);
		}

		else if (command.startsWith("farm_high_1")) {
			player.teleToLocation(169544, 234120, -2328, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_high_2")) {
			player.teleToLocation(186344, 20344, -3400, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_high_3")) {
			player.teleToLocation(-17576, 205880, -3664, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_high_4")) {
			player.teleToLocation(-23512, -112040, -344, ReflectionManager.MAIN);
		} else if (command.startsWith("farm_high_5")) {
			player.teleToLocation(64359, 26787, -3776, ReflectionManager.MAIN);
		}

		else if (command.startsWith("tuli_1")) {
			player.teleToLocation(-13385, 272818, -15304, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_2")) {
			player.teleToLocation(-12744, 273464, -13600, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_3")) {
			player.teleToLocation(-12425, 273909, -11624, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_4")) {
			player.teleToLocation(-12696, 273560, -10496, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_5")) {
			player.teleToLocation(-12504, 274003, -9008, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_6")) {
			player.teleToLocation(-12904, 279944, -13600, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_7")) {
			player.teleToLocation(-12528, 279627, -11624, ReflectionManager.MAIN);
		} else if (command.startsWith("tuli_8")) {
			player.teleToLocation(21928, 243928, 11088, ReflectionManager.MAIN);
		}

		else if (command.startsWith("infinity_1")) {
			player.teleToLocation(-22189, 277089, -15040, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_2")) {
			player.teleToLocation(-22247, 277106, -13376, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_3")) {
			player.teleToLocation(-22243, 277210, -11648, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_4")) {
			player.teleToLocation(-22252, 277080, -9920, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_5")) {
			player.teleToLocation(-22252, 277139, -9920, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_6")) {
			player.teleToLocation(-19014, 277161, -8256, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_7")) {
			player.teleToLocation(-19010, 277074, -9920, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_8")) {
			player.teleToLocation(-19005, 277087, -11648, ReflectionManager.MAIN);
		} else if (command.startsWith("infinity_9")) {
			player.teleToLocation(-18984, 277082, -13376, ReflectionManager.MAIN);
		}
		else if (command.startsWith("soa_1")) {
			player.teleToLocation(-180008, 186280, -10568, ReflectionManager.MAIN);
		}

		else if (command.startsWith("color_nagore")) {
			player.teleToLocation(148408, 160904, -3072, ReflectionManager.MAIN);
		} else if (command.startsWith("pagan_1")) {
			player.teleToLocation(-18520, -52472, -10992, ReflectionManager.MAIN);
		} else if (command.startsWith("beast_farm")) {
			player.teleToLocation(54472, -83544, -2736, ReflectionManager.MAIN);
		} else if (command.startsWith("hellbound_himmeras")) {
			player.teleToLocation(2616, 241128, -2656, ReflectionManager.MAIN);
		}

		else if (command.startsWith("unk_tp_1")) {
			player.teleToLocation(-10522, 77848, -3616, ReflectionManager.MAIN); //Нейтральная Зона
		}
		else if (command.startsWith("unk_tp_2")) {
			player.teleToLocation(625, 179194, -3728, ReflectionManager.MAIN); //Равнины Диона
		}
		else if (command.startsWith("unk_tp_3")) {
			player.teleToLocation(47737, -115730, -3744, ReflectionManager.MAIN); //Склепы Позора
		}
		else if (command.startsWith("unk_tp_4")) {
			player.teleToLocation(112168, -154168, -1536, ReflectionManager.MAIN); //Разграбленные Равнины
		}
		else if (command.startsWith("unk_tp_5")) {
			player.teleToLocation(106520, -2879, -3424, ReflectionManager.MAIN); //Древнее Поле Битвы
		}
		else if (command.startsWith("unk_tp_6")) {
			player.teleToLocation(-45128, 202648, -3600, ReflectionManager.MAIN); //Поселение Ящеров Лангх
		}
		else if (command.startsWith("unk_tp_7")) {
			player.teleToLocation(131193, 114305, -3728, ReflectionManager.MAIN); //Логово Антараса
		}
		else if (command.startsWith("unk_tp_8")) {
			player.teleToLocation(29208, 74968, -3776, ReflectionManager.MAIN); //Эльфийская Крепость
		}
		else if (command.startsWith("unk_tp_9")) {
			player.teleToLocation(169288, -208600, -3504, ReflectionManager.MAIN); //Западные Рудники (Северо-Восточное побережье)
		}

		else if (command.startsWith("Farm_Srong_1")) {
			player.teleToLocation(160040, 68696, -3264, ReflectionManager.MAIN); //Лес Зеркал
		}

		else if (command.startsWith("Farm_Srong_2")) {
			player.teleToLocation(11480, -122376, -1392, ReflectionManager.MAIN); //Кайнак
		}

		else if (command.startsWith("Farm_Srong_3")) {
			player.teleToLocation(172184, 56616, -5720, ReflectionManager.MAIN); //Долина Безмолвия
		}

		else if (command.startsWith("necropolis_1")) {
			player.teleToLocation(-41569, 210082, -5085, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_2")) {
			player.teleToLocation(45249, 123548, -5411, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_3")) {
			player.teleToLocation(111552, 174014, -5440, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_4")) {
			player.teleToLocation(-21423, 77375, -5171, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_5")) {
			player.teleToLocation(118576, 132800, -4832, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_6")) {
			player.teleToLocation(83357, 209207, -5437, ReflectionManager.MAIN);
		} else if (command.startsWith("necropolis_7")) {
			player.teleToLocation(172600, -17599, -4899, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_1")) {
			player.teleToLocation(-53174, -250275, -7911, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_2")) {
			player.teleToLocation(46542, 170305, -4979, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_3")) {
			player.teleToLocation(-20195, -250764, -8163, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_4")) {
			player.teleToLocation(140690, 79679, -5429, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_5")) {
			player.teleToLocation(-19176, 13504, -4899, ReflectionManager.MAIN);
		} else if (command.startsWith("catacomb_6")) {
			player.teleToLocation(12521, -248481, -9585, ReflectionManager.MAIN);
		}

		else
			super.onBypassFeedback(player, command);
	}
}
