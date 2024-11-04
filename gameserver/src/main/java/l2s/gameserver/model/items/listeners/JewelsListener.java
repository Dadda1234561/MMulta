package l2s.gameserver.model.items.listeners;

import java.util.ArrayList;
import java.util.List;
import l2s.gameserver.listener.inventory.OnEquipListener;
import l2s.gameserver.model.Playable;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.items.Inventory;
import l2s.gameserver.model.items.ItemInstance;
import l2s.gameserver.skills.SkillEntry;

import l2s.gameserver.skills.SkillEntryType;
import org.napile.primitive.maps.IntObjectMap;
import org.napile.primitive.sets.IntSet;
import org.napile.primitive.sets.impl.HashIntSet;

/**
 * @author Bonux
**/
public final class JewelsListener extends AbstractSkillListener
{
	private static final IntSet TOP_GRADE_JEWELS = new HashIntSet();
	static
	{
		TOP_GRADE_JEWELS.add(28377); // Большой Аметист Ур. 1
		TOP_GRADE_JEWELS.add(29078); // Большой Камень Энергии Ур. 1
		TOP_GRADE_JEWELS.add(29459); // Большой Аметист Ур. 2
		TOP_GRADE_JEWELS.add(29460); // Большой Аметист Ур. 3
		TOP_GRADE_JEWELS.add(29461); // Большой Аметист Ур. 4
		TOP_GRADE_JEWELS.add(29462); // Большой Аметист Ур. 5
		TOP_GRADE_JEWELS.add(29777); // Большой Топаз Ур. 1
		TOP_GRADE_JEWELS.add(29778); // Большой Обсидиан Ур. 1
		TOP_GRADE_JEWELS.add(29779); // Большой Опал Ур. 1
		TOP_GRADE_JEWELS.add(29780); // Большой Изумруд Ур. 1
		TOP_GRADE_JEWELS.add(29781); // Большой Аквамарин Ур. 1
		TOP_GRADE_JEWELS.add(29782); // Большой Бриллиант Ур. 1
		TOP_GRADE_JEWELS.add(29783); // Большой Жемчуг Ур. 1
		TOP_GRADE_JEWELS.add(29784); // Большой Камень Энергии Ур. 1
		TOP_GRADE_JEWELS.add(29785); // Большой Гранат Ур. 1
		TOP_GRADE_JEWELS.add(29786); // Большой Танзанит Ур. 1
		TOP_GRADE_JEWELS.add(29787); // Большой Красный Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(29788); // Большой Синий Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(29796); // Аметист Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(29797); // Аметист Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(29798); // Аметист Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(29799); // Аметист Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(29800); // Аметист Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(29801); // Аметист Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(29802); // Аметист Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(29803); // Аметист Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(29804); // Аметист Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(29805); // Аметист Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(29806); // Кошачий Глаз Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(29807); // Кошачий Глаз Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(29808); // Кошачий Глаз Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(29809); // Кошачий Глаз Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(29810); // Кошачий Глаз Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(29811); // Кошачий Глаз Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(29812); // Кошачий Глаз Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(29813); // Кошачий Глаз Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(29814); // Кошачий Глаз Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(29815); // Кошачий Глаз Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(47687); // Большой Топаз Ур. 1
		TOP_GRADE_JEWELS.add(47688); // Большой Рубин Ур. 1
		TOP_GRADE_JEWELS.add(47689); // Большой Сапфир Ур. 1
		TOP_GRADE_JEWELS.add(47690); // Большой Обсидиан Ур. 1
		TOP_GRADE_JEWELS.add(47691); // Большой Опал Ур. 1
		TOP_GRADE_JEWELS.add(47692); // Большой Изумруд Ур. 1
		TOP_GRADE_JEWELS.add(47693); // Большой Аквамарин Ур. 1
		TOP_GRADE_JEWELS.add(47694); // Большой Бриллиант Ур. 1
		TOP_GRADE_JEWELS.add(47695); // Большой Жемчуг Ур. 1
		TOP_GRADE_JEWELS.add(47696); // Большой Камень Энергии Ур. 1
		TOP_GRADE_JEWELS.add(47697); // Большой Гранат Ур. 1
		TOP_GRADE_JEWELS.add(47698); // Большой Танзанит Ур. 1
		TOP_GRADE_JEWELS.add(47699); // Большой Красный Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(47700); // Большой Синий Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(47920); // Большой Камень Энергии Ур. 1
		TOP_GRADE_JEWELS.add(47921); // Большой Красный Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(47922); // Большой Синий Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(47923); // Большой Танзанит Ур. 1
		TOP_GRADE_JEWELS.add(48644); // Большой Рубин Ур. 1
		TOP_GRADE_JEWELS.add(48645); // Большой Сапфир Ур. 1
		TOP_GRADE_JEWELS.add(48646); // Большой Опал Ур. 1
		TOP_GRADE_JEWELS.add(48647); // Большой Бриллиант Ур. 1
		TOP_GRADE_JEWELS.add(48648); // Большой Жемчуг Ур. 1
		TOP_GRADE_JEWELS.add(48767); // Большой Топаз Ур. 2
		TOP_GRADE_JEWELS.add(48768); // Большой Топаз Ур. 3
		TOP_GRADE_JEWELS.add(48769); // Большой Топаз Ур. 4
		TOP_GRADE_JEWELS.add(48770); // Большой Топаз Ур. 5
		TOP_GRADE_JEWELS.add(48771); // Большой Рубин Ур. 2
		TOP_GRADE_JEWELS.add(48772); // Большой Рубин Ур. 3
		TOP_GRADE_JEWELS.add(48773); // Большой Рубин Ур. 4
		TOP_GRADE_JEWELS.add(48774); // Большой Рубин Ур. 5
		TOP_GRADE_JEWELS.add(48775); // Большой Сапфир Ур. 2
		TOP_GRADE_JEWELS.add(48776); // Большой Сапфир Ур. 3
		TOP_GRADE_JEWELS.add(48777); // Большой Сапфир Ур. 4
		TOP_GRADE_JEWELS.add(48778); // Большой Сапфир Ур. 5
		TOP_GRADE_JEWELS.add(48779); // Большой Обсидиан Ур. 2
		TOP_GRADE_JEWELS.add(48780); // Большой Обсидиан Ур. 3
		TOP_GRADE_JEWELS.add(48781); // Большой Обсидиан Ур. 4
		TOP_GRADE_JEWELS.add(48782); // Большой Обсидиан Ур. 5
		TOP_GRADE_JEWELS.add(48783); // Большой Опал Ур. 2
		TOP_GRADE_JEWELS.add(48784); // Большой Опал Ур. 3
		TOP_GRADE_JEWELS.add(48785); // Большой Опал Ур. 4
		TOP_GRADE_JEWELS.add(48786); // Большой Опал Ур. 5
		TOP_GRADE_JEWELS.add(48787); // Большой Изумруд Ур. 2
		TOP_GRADE_JEWELS.add(48788); // Большой Изумруд Ур. 3
		TOP_GRADE_JEWELS.add(48789); // Большой Изумруд Ур. 4
		TOP_GRADE_JEWELS.add(48790); // Большой Изумруд Ур. 5
		TOP_GRADE_JEWELS.add(48791); // Большой Аквамарин Ур. 2
		TOP_GRADE_JEWELS.add(48792); // Большой Аквамарин Ур. 3
		TOP_GRADE_JEWELS.add(48793); // Большой Аквамарин Ур. 4
		TOP_GRADE_JEWELS.add(48794); // Большой Аквамарин Ур. 5
		TOP_GRADE_JEWELS.add(48795); // Большой Бриллиант Ур. 2
		TOP_GRADE_JEWELS.add(48796); // Большой Бриллиант Ур. 3
		TOP_GRADE_JEWELS.add(48797); // Большой Бриллиант Ур. 4
		TOP_GRADE_JEWELS.add(48798); // Большой Бриллиант Ур. 5
		TOP_GRADE_JEWELS.add(48799); // Большой Жемчуг Ур. 2
		TOP_GRADE_JEWELS.add(48800); // Большой Жемчуг Ур. 3
		TOP_GRADE_JEWELS.add(48801); // Большой Жемчуг Ур. 4
		TOP_GRADE_JEWELS.add(48802); // Большой Жемчуг Ур. 5
		TOP_GRADE_JEWELS.add(48803); // Большой Камень Энергии Ур. 2
		TOP_GRADE_JEWELS.add(48804); // Большой Камень Энергии Ур. 3
		TOP_GRADE_JEWELS.add(48805); // Большой Камень Энергии Ур. 4
		TOP_GRADE_JEWELS.add(48806); // Большой Камень Энергии Ур. 5
		TOP_GRADE_JEWELS.add(48807); // Большой Гранат Ур. 2
		TOP_GRADE_JEWELS.add(48808); // Большой Гранат Ур. 3
		TOP_GRADE_JEWELS.add(48809); // Большой Гранат Ур. 4
		TOP_GRADE_JEWELS.add(48810); // Большой Гранат Ур. 5
		TOP_GRADE_JEWELS.add(48811); // Большой Танзанит Ур. 2
		TOP_GRADE_JEWELS.add(48812); // Большой Танзанит Ур. 3
		TOP_GRADE_JEWELS.add(48813); // Большой Танзанит Ур. 4
		TOP_GRADE_JEWELS.add(48814); // Большой Танзанит Ур. 5
		TOP_GRADE_JEWELS.add(48815); // Большой Красный Кошачий Глаз Ур. 2
		TOP_GRADE_JEWELS.add(48816); // Большой Красный Кошачий Глаз Ур. 3
		TOP_GRADE_JEWELS.add(48817); // Большой Красный Кошачий Глаз Ур. 4
		TOP_GRADE_JEWELS.add(48818); // Большой Красный Кошачий Глаз Ур. 5
		TOP_GRADE_JEWELS.add(48819); // Большой Синий Кошачий Глаз Ур. 2
		TOP_GRADE_JEWELS.add(48820); // Большой Синий Кошачий Глаз Ур. 3
		TOP_GRADE_JEWELS.add(48821); // Большой Синий Кошачий Глаз Ур. 4
		TOP_GRADE_JEWELS.add(48822); // Большой Синий Кошачий Глаз Ур. 5
		TOP_GRADE_JEWELS.add(48927); // Большой Камень Энергии Ур. 5
		TOP_GRADE_JEWELS.add(80472); // Большой Топаз Ур. 1
		TOP_GRADE_JEWELS.add(80473); // Большой Рубин Ур. 1
		TOP_GRADE_JEWELS.add(80474); // Большой Сапфир Ур. 1
		TOP_GRADE_JEWELS.add(80475); // Большой Обсидиан Ур. 1
		TOP_GRADE_JEWELS.add(80476); // Большой Опал Ур. 1
		TOP_GRADE_JEWELS.add(80477); // Большой Изумруд Ур. 1
		TOP_GRADE_JEWELS.add(80478); // Большой Аквамарин Ур. 1
		TOP_GRADE_JEWELS.add(80479); // Большой Бриллиант Ур. 1
		TOP_GRADE_JEWELS.add(80480); // Большой Жемчуг Ур. 1
		TOP_GRADE_JEWELS.add(80481); // Большой Камень Энергии Ур. 1
		TOP_GRADE_JEWELS.add(80482); // Большой Гранат Ур. 1
		TOP_GRADE_JEWELS.add(80483); // Большой Танзанит Ур. 1
		TOP_GRADE_JEWELS.add(80484); // Большой Красный Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(80485); // Большой Синий Кошачий Глаз Ур. 1
		TOP_GRADE_JEWELS.add(81495); // Топаз Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81496); // Топаз Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81497); // Топаз Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81498); // Топаз Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81499); // Топаз Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81500); // Топаз Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81501); // Топаз Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81502); // Топаз Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81503); // Топаз Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81504); // Топаз Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81505); // Рубин Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81506); // Рубин Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81507); // Рубин Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81508); // Рубин Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81509); // Рубин Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81510); // Рубин Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81511); // Рубин Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81512); // Рубин Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81513); // Рубин Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81514); // Рубин Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81515); // Сапфир Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81516); // Сапфир Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81517); // Сапфир Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81518); // Сапфир Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81519); // Сапфир Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81520); // Сапфир Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81521); // Сапфир Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81522); // Сапфир Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81523); // Сапфир Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81524); // Сапфир Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81525); // Обсидиан Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81526); // Обсидиан Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81527); // Обсидиан Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81528); // Обсидиан Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81529); // Обсидиан Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81530); // Обсидиан Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81531); // Обсидиан Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81532); // Обсидиан Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81533); // Обсидиан Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81534); // Обсидиан Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81535); // Опал Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81536); // Опал Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81537); // Опал Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81538); // Опал Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81539); // Опал Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81540); // Опал Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81541); // Опал Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81542); // Опал Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81543); // Опал Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81544); // Опал Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81545); // Изумруд Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81546); // Изумруд Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81547); // Изумруд Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81548); // Изумруд Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81549); // Изумруд Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81550); // Изумруд Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81551); // Изумруд Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81552); // Изумруд Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81553); // Изумруд Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81554); // Изумруд Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81565); // Бриллиант Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81566); // Бриллиант Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81567); // Бриллиант Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81568); // Бриллиант Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81569); // Бриллиант Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81570); // Бриллиант Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81571); // Бриллиант Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81572); // Бриллиант Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81573); // Бриллиант Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81574); // Бриллиант Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81575); // Жемчуг Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81576); // Жемчуг Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81577); // Жемчуг Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81578); // Жемчуг Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81579); // Жемчуг Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81580); // Жемчуг Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81581); // Жемчуг Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81582); // Жемчуг Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81583); // Жемчуг Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81584); // Жемчуг Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81585); // Камень Энергии Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81586); // Камень Энергии Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81587); // Камень Энергии Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81588); // Камень Энергии Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81589); // Камень Энергии Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81590); // Камень Энергии Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81591); // Камень Энергии Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81592); // Камень Энергии Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81593); // Камень Энергии Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81594); // Камень Энергии Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81595); // Гранат Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81596); // Гранат Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81597); // Гранат Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81598); // Гранат Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81599); // Гранат Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81600); // Гранат Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81601); // Гранат Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81602); // Гранат Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81603); // Гранат Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81604); // Гранат Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81605); // Танзанит Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81606); // Танзанит Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81607); // Танзанит Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81608); // Танзанит Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81609); // Танзанит Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81610); // Танзанит Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81611); // Танзанит Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81612); // Танзанит Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81613); // Танзанит Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81614); // Танзанит Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81615); // Красный Кошачий Глаз Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81616); // Красный Кошачий Глаз Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81617); // Красный Кошачий Глаз Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81618); // Красный Кошачий Глаз Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81619); // Красный Кошачий Глаз Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81620); // Красный Кошачий Глаз Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81621); // Красный Кошачий Глаз Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81622); // Красный Кошачий Глаз Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81623); // Красный Кошачий Глаз Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81624); // Красный Кошачий Глаз Исключительного Качества Ур. 10
		TOP_GRADE_JEWELS.add(81625); // Синий Кошачий Глаз Исключительного Качества Ур. 1
		TOP_GRADE_JEWELS.add(81626); // Синий Кошачий Глаз Исключительного Качества Ур. 2
		TOP_GRADE_JEWELS.add(81627); // Синий Кошачий Глаз Исключительного Качества Ур. 3
		TOP_GRADE_JEWELS.add(81628); // Синий Кошачий Глаз Исключительного Качества Ур. 4
		TOP_GRADE_JEWELS.add(81629); // Синий Кошачий Глаз Исключительного Качества Ур. 5
		TOP_GRADE_JEWELS.add(81630); // Синий Кошачий Глаз Исключительного Качества Ур. 6
		TOP_GRADE_JEWELS.add(81631); // Синий Кошачий Глаз Исключительного Качества Ур. 7
		TOP_GRADE_JEWELS.add(81632); // Синий Кошачий Глаз Исключительного Качества Ур. 8
		TOP_GRADE_JEWELS.add(81633); // Синий Кошачий Глаз Исключительного Качества Ур. 9
		TOP_GRADE_JEWELS.add(81634); // Синий Кошачий Глаз Исключительного Качества Ур. 10
	}

	private static final JewelsListener _instance = new JewelsListener();

	public static JewelsListener getInstance()
	{
		return _instance;
	}

	@Override
	public int onEquip(int slot, ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		if(!TOP_GRADE_JEWELS.contains(item.getItemId()))
			return 0;

		return checkEquippedJewels(item, actor.getPlayer());
	}

	@Override
	public int onUnequip(int slot, ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		if(!TOP_GRADE_JEWELS.contains(item.getItemId()))
			return 0;

		int flags = super.onUnequip(slot, item, actor);
		flags |= checkEquippedJewels(item, actor.getPlayer());
		return flags;
	}

	@Override
	public int onRefreshEquip(ItemInstance item, Playable actor)
	{
		if(!item.isEquipable())
			return 0;

		if(!actor.isPlayer())
			return 0;

		if(!TOP_GRADE_JEWELS.contains(item.getItemId()))
			return 0;

		return checkEquippedJewels(item, actor.getPlayer());
	}

	private int checkEquippedJewels(ItemInstance item, Player player)
	{
		int flags = 0;
		if(player.removeSkill(27717, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;
		if(player.removeSkill(27721, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;
		if(player.removeSkill(27722, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;
		if(player.removeSkill(27723, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;
		if(player.removeSkill(27724, false) != null)
			flags |= Inventory.UPDATE_SKILLS_FLAG;

		Inventory inv = player.getInventory();

		IntSet equippedJewels = new HashIntSet();

		for (int slotId = Inventory.PAPERDOLL_JEWEL1; slotId <= Inventory.PAPERDOLL_JEWEL12; slotId++) {
			ItemInstance jewelItem = inv.getPaperdollItem(slotId);
			if (jewelItem != null && TOP_GRADE_JEWELS.contains(jewelItem.getItemId())) {
				equippedJewels.add(jewelItem.getItemId());
			}
		}


		int skillLevel = Math.min(12, equippedJewels.size());
		if(skillLevel > 0)
		{
			List<SkillEntry> addedSkills = new ArrayList<SkillEntry>();

			SkillEntry skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, 27717, skillLevel);
			if(skillEntry != null)
				addedSkills.add(skillEntry);

			int activeSkillId = 0;
			if(skillLevel == 6 || skillLevel >= 7)
				activeSkillId = 27724;
			else if(skillLevel == 5)
				activeSkillId = 27723;
			else if(skillLevel == 4)
				activeSkillId = 27722;
			else if(skillLevel == 3)
				activeSkillId = 27721;

			if(activeSkillId > 0)
			{
				skillEntry = SkillEntry.makeSkillEntry(SkillEntryType.NONE, activeSkillId, 1);
				if(skillEntry != null)
					addedSkills.add(skillEntry);
			}

			flags |= refreshSkills(player, item, addedSkills);
		}
		return flags;
	}
}