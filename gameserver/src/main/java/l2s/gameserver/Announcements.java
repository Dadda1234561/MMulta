package l2s.gameserver;

import java.io.File;
import java.io.FileWriter;
import java.util.*;
import java.util.concurrent.Future;

import l2s.gameserver.Config;
import l2s.gameserver.data.string.StringsHolder;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.GameObjectsStorage;
import l2s.gameserver.model.Player;
import l2s.gameserver.network.l2.components.ChatType;
import l2s.gameserver.network.l2.components.CustomMessage;
import l2s.gameserver.network.l2.components.IBroadcastPacket;
import l2s.gameserver.network.l2.components.NpcString;
import l2s.gameserver.network.l2.s2c.SayPacket2;
import l2s.gameserver.utils.ArabicConv;
import l2s.gameserver.utils.ChatUtils;
import l2s.gameserver.utils.Files;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Announcements
{
	public class Announce implements Runnable
	{
		private Future<?> _task;
		private final int _time;
		private final String _announce;

		public Announce(int t, String announce)
		{
			_time = t;
			_announce = announce;
		}

		@Override
		public void run()
		{
			announceToAll(Config.HTM_SHAPE_ARABIC ? ArabicConv.shapeArabic(_announce) : _announce);
		}

		public void showAnnounce(Player player)
		{
			String text = Config.HTM_SHAPE_ARABIC ? ArabicConv.shapeArabic(_announce) : _announce;
			SayPacket2 cs = new SayPacket2(0, ChatType.ANNOUNCEMENT, player.getName(), text);
			player.sendPacket(cs);
		}

		public void start()
		{
			if(_time > 0)
				_task = ThreadPoolManager.getInstance().scheduleAtFixedRate(this, _time * 1000L, _time * 1000L);
		}

		public void stop()
		{
			if(_task != null)
			{
				_task.cancel(false);
				_task = null;
			}
		}

		public int getTime()
		{
			return _time;
		}

		public String getAnnounce()
		{
			return _announce;
		}
	}

	private static final Logger _log = LoggerFactory.getLogger(Announcements.class);

	private static final Announcements _instance = new Announcements();

	public static final Announcements getInstance()
	{
		return _instance;
	}

	private List<Announce> _announcements = new ArrayList<Announce>();

	private Announcements()
	{
		loadAnnouncements();
	}

	public List<Announce> getAnnouncements()
	{
		return _announcements;
	}

	public void loadAnnouncements()
	{
		_announcements.clear();

		try
		{
			List<String> lines = Arrays.asList(Files.readFile(new File("config/announcements.txt")).split("\n"));
			for(String line : lines)
			{
				if(line == null || line.isEmpty())
					continue;

				StringTokenizer token = new StringTokenizer(line, "\t");
				if(token.countTokens() > 1)
					addAnnouncement(Integer.parseInt(token.nextToken()), token.nextToken(), false);
				else
					addAnnouncement(0, line, false);
			}
		}
		catch(Exception e)
		{
			_log.error("Error while loading config/announcements.txt!");
		}
	}

	public void showAnnouncements(Player activeChar)
	{
		for(Announce announce : _announcements)
			announce.showAnnounce(activeChar);
	}

	public static void announceKill(Player killer, Player victim, boolean isPK) {
		String message;
		Random random = new Random();

		String[] pvpMessagesRus = {
				"Игрок [" + killer.getName() + "] победил в честном бою [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] отправил на отдых [" + victim.getName() + "] в PvP",
				"Игрок [" + killer.getName() + "] показал превосходство над [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] свергнул [" + victim.getName() + "] с пьедестала",
				"Игрок [" + killer.getName() + "] сокрушил [" + victim.getName() + "] в дуэли",
				"Игрок [" + killer.getName() + "] отправил душу [" + victim.getName() + "] на перерождение",
				"Игрок [" + killer.getName() + "] мастерски расправился с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] доказал свою силу против [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] отправил [" + victim.getName() + "] в небытие",
				"Игрок [" + killer.getName() + "] уничтожил сопротивление [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] выбил из [" + victim.getName() + "] весь дух",
				"Игрок [" + killer.getName() + "] совершил героический подвиг против [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] проявил истинное мастерство в сражении с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] оказался сильнее [" + victim.getName() + "] в бою",
				"Игрок [" + killer.getName() + "] завершил дуэль победой над [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] заставил [" + victim.getName() + "] признать своё поражение",
				"Игрок [" + killer.getName() + "] одержал блистательную победу над [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] переиграл [" + victim.getName() + "] и выиграл",
				"Игрок [" + killer.getName() + "] доблестно справился с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] свирепо одолел [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] доказал свою непревзойденную мощь против [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] показал свою силу, сокрушив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] разорвал в клочья сопротивление [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] уничтожил [" + victim.getName() + "] словно буря",
				"Игрок [" + killer.getName() + "] без труда расправился с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] одолел [" + victim.getName() + "] с одной попытки",
				"Игрок [" + killer.getName() + "] наглядно показал, что сила важнее всего, побив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] сразил [" + victim.getName() + "] без тени сомнения",
				"Игрок [" + killer.getName() + "] сокрушил [" + victim.getName() + "] на пути к победе",
				"Игрок [" + killer.getName() + "] одержал верх в этом бою, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] доказал, что он лучший, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] оставил [" + victim.getName() + "] далеко позади",
				"Игрок [" + killer.getName() + "] добился победы, оставив [" + victim.getName() + "] ни с чем",
				"Игрок [" + killer.getName() + "] был на шаг впереди, одержав победу над [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] легко одолел [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] преодолел все препятствия, стоявшие на пути к победе над [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] доказал свою мощь, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] уверенно победил [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] свирепо атаковал и победил [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] оказался вне конкуренции, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] продемонстрировал своё мастерство, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] отбросил [" + victim.getName() + "] на второй план",
				"Игрок [" + killer.getName() + "] проявил волю к победе и победил [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] не оставил шансов [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] показал, кто здесь настоящий чемпион, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] взял верх над [" + victim.getName() + "] в этом поединке",
				"Игрок [" + killer.getName() + "] завершил бой в свою пользу, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] стал победителем в схватке с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] доказал, что сила важнее всего, одолев [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] оказался сильнее и победил [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] показал своё мастерство, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] снова доказал своё превосходство, одолев [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] продемонстрировал свою мощь, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] одержал победу, оставив [" + victim.getName() + "] в прошлом",
				"Игрок [" + killer.getName() + "] уверенно расправился с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] оставил [" + victim.getName() + "] лежать на поле боя",
				"Игрок [" + killer.getName() + "] сверг [" + victim.getName() + "] с пьедестала",
				"Игрок [" + killer.getName() + "] победил в этом бою, одолев [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] продемонстрировал истинное мастерство, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] одержал верх над [" + victim.getName() + "] в ожесточенной битве",
				"Игрок [" + killer.getName() + "] доказал своё превосходство, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] был быстрее и сильнее, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] проявил мощь, одолев [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] выиграл дуэль с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] уверенно добился победы над [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] продемонстрировал свою силу, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] справился с [" + victim.getName() + "] в этом бою",
				"Игрок [" + killer.getName() + "] доказал, что он сильнее, победив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] одержал победу, оставив [" + victim.getName() + "] ни с чем",
				"Игрок [" + killer.getName() + "] оказался сильнее и победил [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] показал истинное мастерство в бою с [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] без труда одолел [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] оставил [" + victim.getName() + "] далеко позади, одержав победу",
				"Игрок [" + killer.getName() + "] был на шаг впереди, победив [" + victim.getName() + "]"
		};

		String[] pkMessagesRus = {
				"Игрок [" + killer.getName() + "] убил [" + victim.getName() + "] в PK с изощренной хитростью",
				"Игрок [" + killer.getName() + "] уничтожил [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] безжалостно расправился с [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал убийцей, уничтожив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] показал свою жестокость, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] вышел победителем, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] заколол [" + victim.getName() + "] в бесчеловечном PK",
				"Игрок [" + killer.getName() + "] расправился с [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] стал легендой, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] отомстил, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] оставил свою метку, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал охотником, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] продемонстрировал свои навыки, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] обманул судьбу, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал безжалостным убийцей, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] вышел на тропу войны, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] поразил [" + victim.getName() + "] в PK с хладнокровием",
				"Игрок [" + killer.getName() + "] покончил с [" + victim.getName() + "] в жестоком PK",
				"Игрок [" + killer.getName() + "] отрезал путь к побегу [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] доказал, что он охотник, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] заполнил землю кровью, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал беспощадным, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] проявил жестокость, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] напал на [" + victim.getName() + "] и убил его в PK",
				"Игрок [" + killer.getName() + "] завершил жизнь [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] стал убийцей, жестоко расправившись с [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] отправил [" + victim.getName() + "] на тот свет в PK",
				"Игрок [" + killer.getName() + "] покончил с надеждой [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] убил [" + victim.getName() + "] с хладнокровием в PK",
				"Игрок [" + killer.getName() + "] оставил свою жертву в PK, убив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] вошел в историю, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] добил [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] выбрал жертву и убил [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] охотился на [" + victim.getName() + "] и одержал победу в PK",
				"Игрок [" + killer.getName() + "] показал всем, как это делается, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] совершил убийство, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал убийцей, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] отправил [" + victim.getName() + "] в мир мертвых в PK",
				"Игрок [" + killer.getName() + "] стал героем, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] заколол [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] оказался сильнее, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] расправился с ["+ victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] показал, что сила важнее, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] поразил [" + victim.getName() + "] своей хитростью в PK",
				"Игрок [" + killer.getName() + "] использовал коварство, чтобы убить [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] принял последний удар, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] был неумолим, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] вышел победителем, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] утопил [" + victim.getName() + "] в океане крови в PK",
				"Игрок [" + killer.getName() + "] оставил [" + victim.getName() + "] без шанса в PK",
				"Игрок [" + killer.getName() + "] стал одним из самых опасных, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] уничтожил [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] был незаметен, когда убил [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] охотился на [" + victim.getName() + "] как на дичь в PK",
				"Игрок [" + killer.getName() + "] поразил [" + victim.getName() + "] одним ударом в PK",
				"Игрок [" + killer.getName() + "] убил [" + victim.getName() + "] с беспощадностью в PK",
				"Игрок [" + killer.getName() + "] был безжалостен, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] был на шаг впереди, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] выбрал момент и убил [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] был хитрецом, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] сломал дух [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал убийцей, показав свою жестокость, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] проявил свои силы, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] отправил [" + victim.getName() + "] к праотцам в PK",
				"Игрок [" + killer.getName() + "] завершил своё дело, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] провёл свою месть, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал одним из самых страшных, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] завершил свою охоту, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] запомнится как безжалостный убийца после убийства [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] был в ударе, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] взял свою жертву, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал мастером PK, убив [" + victim.getName() + "]",
				"Игрок [" + killer.getName() + "] отомстил, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] вышел на путь убийцы, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] захватил контроль, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] обманул ожидания, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] оставил след, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] взял жизнь [" + victim.getName() + "] в решающем PK",
				"Игрок [" + killer.getName() + "] стал кошмаром для всех, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] уничтожил надежды [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] продемонстрировал свои навыки, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал звёздным убийцей, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] показал силу, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] вышел на битву, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] совершил своё первое убийство, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] охотился на [" + victim.getName() + "] с гневом в PK",
				"Игрок [" + killer.getName() + "] продемонстрировал решимость, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] показал, что враги не прощаются, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал гордостью для своего клана, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] подтвердил свои навыки, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] ушёл в бой, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] поставил точку, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал врагом, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] завершил свою миссию, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] охотился на слабых, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] подтвердил свою репутацию, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] убил [" + victim.getName() + "] безжалостно в PK",
				"Игрок [" + killer.getName() + "] заполнил тьму, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал убийцей, убив [" + victim.getName() + "] в безжалостном PK",
				"Игрок [" + killer.getName() + "] взял жизнь у [" + victim.getName() + "] в мрачном PK",
				"Игрок [" + killer.getName() + "] закрыл глаза на жалость, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал ночным кошмаром для [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] убил [" + victim.getName() + "] в безжалостной схватке PK",
				"Игрок [" + killer.getName() + "] остался в истории, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] оставил за собой след крови, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] убил [" + victim.getName() + "] в драматическом PK",
				"Игрок [" + killer.getName() + "] не оставил шансов [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] стал законодателем ужаса, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] отомстил, убив [" + victim.getName() + "] в PK",
				"Игрок [" + killer.getName() + "] заставил [" + victim.getName() + "] заплатить ценой жизни в PK",
				"Игрок [" + killer.getName() + "] стал тенью для [" + victim.getName() + "] в PK"
		};

				String[] pvpMessagesEng = {
				"Player [" + killer.getName() + "] triumphed over [" + victim.getName() + "] in a fair fight",
				"Player [" + killer.getName() + "] sent [" + victim.getName() + "] to rest in PvP",
				"Player [" + killer.getName() + "] demonstrated superiority over [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] dethroned [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] crushed [" + victim.getName() + "] in a duel",
				"Player [" + killer.getName() + "] sent [" + victim.getName() + "]'s soul to be reborn",
				"Player [" + killer.getName() + "] masterfully defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] proved their strength against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] sent [" + victim.getName() + "] into oblivion",
				"Player [" + killer.getName() + "] destroyed [" + victim.getName() + "]'s resistance",
				"Player [" + killer.getName() + "] knocked the spirit out of [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] performed a heroic feat against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] showed true skill in a fight with [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] proved stronger than [" + victim.getName() + "] in battle",
				"Player [" + killer.getName() + "] concluded the duel with a victory over [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] forced [" + victim.getName() + "] to acknowledge defeat",
				"Player [" + killer.getName() + "] scored a brilliant victory over [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] outplayed [" + victim.getName() + "] and won",
				"Player [" + killer.getName() + "] valiantly took down [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] fiercely defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] showed unparalleled power against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] displayed their strength by crushing [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] tore apart [" + victim.getName() + "]'s resistance",
				"Player [" + killer.getName() + "] obliterated [" + victim.getName() + "] like a storm",
				"Player [" + killer.getName() + "] easily dispatched [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] overcame [" + victim.getName() + "] with a single effort",
				"Player [" + killer.getName() + "] showed that power is all that matters, by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] struck down [" + victim.getName() + "] without hesitation",
				"Player [" + killer.getName() + "] shattered [" + victim.getName() + "] on the path to victory",
				"Player [" + killer.getName() + "] emerged victorious in this battle, defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] proved to be the best by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] left [" + victim.getName() + "] far behind",
				"Player [" + killer.getName() + "] secured the win, leaving [" + victim.getName() + "] with nothing",
				"Player [" + killer.getName() + "] was one step ahead, defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] effortlessly defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] overcame all obstacles to secure victory over [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] proved their power by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] confidently defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] savagely attacked and defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] was unmatched in the fight against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] demonstrated skill by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] overshadowed [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] showed the will to win, defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] left no chance for [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] showed who is the real champion by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] took the upper hand against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] ended the battle in their favor, defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] became the victor in the fight with [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] proved that power is key, by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] was stronger and defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] showed their skill by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] once again proved their superiority by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] demonstrated their strength by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] secured victory, leaving [" + victim.getName() + "] in the past",
				"Player [" + killer.getName() + "] confidently dealt with [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] left [" + victim.getName() + "] lying on the battlefield",
				"Player [" + killer.getName() + "] dethroned [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] emerged victorious in this fight against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] demonstrated true skill by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] prevailed over [" + victim.getName() + "] in a fierce battle",
				"Player [" + killer.getName() + "] proved their superiority by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] was faster and stronger, defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] displayed their power by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] won the duel with [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] confidently secured victory over [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] demonstrated their strength by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] dealt with [" + victim.getName() + "] in this fight",
				"Player [" + killer.getName() + "] proved stronger by defeating [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] secured victory, leaving [" + victim.getName() + "] with nothing",
				"Player [" + killer.getName() + "] was stronger and defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] displayed true skill in the fight against [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] easily defeated [" + victim.getName() + "]",
				"Player [" + killer.getName() + "] left [" + victim.getName() + "] far behind, securing the win",
				"Player [" + killer.getName() + "] was one step ahead, defeating [" + victim.getName() + "]"
		};

		String[] pkMessagesEng = {
				"Player [" + killer.getName() + "] killed [" + victim.getName() + "] in PK with cunning strategy",
				"Player [" + killer.getName() + "] annihilated [" + victim.getName() + "] in a ruthless PK",
				"Player [" + killer.getName() + "] mercilessly eliminated [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became a killer by taking down [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] showed his cruelty by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] emerged victorious by slaying [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] stabbed [" + victim.getName() + "] in a merciless PK",
				"Player [" + killer.getName() + "] dispatched [" + victim.getName() + "] in a brutal PK",
				"Player [" + killer.getName() + "] became a legend by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] avenged himself by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] left his mark by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became a hunter by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] displayed his skills by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] cheated fate by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] turned into a merciless killer by taking down [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] embarked on a warpath by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] struck down [" + victim.getName() + "] in PK with cold blood",
				"Player [" + killer.getName() + "] finished off [" + victim.getName() + "] in a brutal PK",
				"Player [" + killer.getName() + "] cut off the escape of [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] proved to be a hunter by slaying [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] filled the ground with blood by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became the nightmare of [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] claimed the life of [" + victim.getName() + "] in a merciless PK",
				"Player [" + killer.getName() + "] ended the life of [" + victim.getName() + "] in an intense PK",
				"Player [" + killer.getName() + "] left no chance for [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] executed a flawless kill on [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became the ultimate predator by slaying [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] avenged his honor by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] emerged as a feared warrior by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] made history by eliminating [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] took a life in PK, leaving a trail of destruction",
				"Player [" + killer.getName() + "] turned into a killing machine by taking down [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] displayed cold efficiency in killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] struck fear into the hearts of many by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] marked the battlefield by slaying [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] took revenge and killed [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] fulfilled his dark fate by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] ended the struggle of [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became a symbol of fear by slaying [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became a shadow by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] left a blood trail by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] solidified his reputation as a killer by slaying [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] entered the legends by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] hunted down [" + victim.getName() + "] in a ruthless PK",
				"Player [" + killer.getName() + "] proved he is a force to reckon with by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] paid no mercy while killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] emerged from the shadows to kill [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] wreaked havoc by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] marked the end of [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] struck decisively by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] left a legacy of violence by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] unleashed chaos on the battlefield, killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] painted the town red by killing [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] established dominance by eliminating [" + victim.getName() + "] in PK",
				"Player [" + killer.getName() + "] became a name whispered in fear after killing [" + victim.getName() + "] in PK"
		};

		if (killer.isLangRus()) {
			if (isPK) {
				message = pkMessagesRus[random.nextInt(pkMessagesRus.length)];
			} else {
				message = pvpMessagesRus[random.nextInt(pvpMessagesRus.length)];
			}
		} else {
			if (isPK) {
				message = pkMessagesEng[random.nextInt(pkMessagesEng.length)];
			} else {
				message = pvpMessagesEng[random.nextInt(pvpMessagesEng.length)];
			}
		}

		announceToAll(message, ChatType.TRADE);
	}



	public void addAnnouncement(int val, String text, boolean save)
	{
		Announce announce = new Announce(val, text);
		announce.start();

		_announcements.add(announce);
		if(save)
			saveToDisk();
	}

	public void delAnnouncement(int line)
	{
		Announce announce = _announcements.remove(line);
		if(announce != null)
			announce.stop();

		saveToDisk();
	}

	private void saveToDisk()
	{
		try
		{
			File f = new File("config/announcements.txt");
			FileWriter writer = new FileWriter(f, false);
			for(Announce announce : _announcements)
				writer.write(announce.getTime() + "\t" + announce.getAnnounce() + "\n");
			writer.close();
		}
		catch(Exception e)
		{
			_log.error("Error while saving config/announcements.txt!", e);
		}
	}

	public static void announceToAll(String text)
	{
		announceToAll(text, ChatType.ANNOUNCEMENT);
	}

	public static void announceToAll(NpcString npcString, String... params)
	{
		announceToAll(ChatType.ANNOUNCEMENT, npcString, params);
	}

	public static void shout(Player activeChar, String text, ChatType type)
	{
		SayPacket2 cs = new SayPacket2(activeChar.getObjectId(), type, activeChar.getName(), text);
		ChatUtils.shout(activeChar, cs);
		activeChar.sendPacket(cs);
	}

	public static void announceToAll(String text, ChatType type)
	{
		SayPacket2 cs = new SayPacket2(0, type, "", text);
		for(Player player : GameObjectsStorage.getPlayers(false, false))
			player.sendPacket(cs);
	}

	public static void announceToAll(ChatType type, NpcString npcString, String... params)
	{
		SayPacket2 cs = new SayPacket2(0, type, "", npcString, params);
		for(Player player : GameObjectsStorage.getPlayers(false, false))
			player.sendPacket(cs);
	}

	public static void announceToAllFromStringHolder(String add, Object... arg)
	{
		for(Player player : GameObjectsStorage.getPlayers(false, false))
			announceToPlayerFromStringHolder(player, add, arg);
	}

	public static void announceToPlayerFromStringHolder(Player player, String add, Object... arg)
	{
		CustomMessage message = new CustomMessage(add);
		for(Object a : arg)
		{
			if(a instanceof CustomMessage)
				message.addCustomMessage((CustomMessage) a);
			else
				message.addString(String.valueOf(a));
		}
		player.sendPacket(new SayPacket2(0, ChatType.ANNOUNCEMENT, "", message.toString(player)));
	}

	public static void criticalAnnounceToAllFromStringHolder(String add, Object... arg)
	{
		for(Player player : GameObjectsStorage.getPlayers(false, false))
			criticalAnnounceToPlayerFromStringHolder(player, add, arg);
	}

	public static void criticalAnnounceToPlayerFromStringHolder(Player player, String add, Object... arg)
	{
		CustomMessage message = new CustomMessage(add);
		for(Object a : arg)
		{
			if(a instanceof CustomMessage)
				message.addCustomMessage((CustomMessage) a);
			else
				message.addString(String.valueOf(a));
		}
		player.sendPacket(new SayPacket2(0, ChatType.CRITICAL_ANNOUNCE, "", message.toString(player)));
	}

	public static void announceToAll(IBroadcastPacket sm)
	{
		for(Player player : GameObjectsStorage.getPlayers(false, false))
			player.sendPacket(sm);
	}

	public void announceByCustomMessage(String address, String[] replacements, ChatType type)
	{
		for (Player player : GameObjectsStorage.getPlayers(true, false))
		{
			announceToPlayerByCustomMessage(player, address, replacements, type);
		}
	}

	public void announceToPlayerByCustomMessage(Player player, String address, String[] replacements, ChatType type)
	{
		CustomMessage cm = new CustomMessage(address);
		if (replacements != null)
		{
			for (String s : replacements)
			{
				cm.addString(s);
			}
		}
		player.sendPacket(new SayPacket2(0, type, "", cm.toString(player)));
	}
}