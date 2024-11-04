package l2s.gameserver.data.string;

import gnu.trove.map.TIntObjectMap;
import gnu.trove.map.hash.TIntObjectHashMap;
import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.Config;
import l2s.gameserver.data.xml.holder.SkillHolder;
import l2s.gameserver.model.Player;
import l2s.gameserver.model.Skill;
import l2s.gameserver.utils.Files;
import l2s.gameserver.utils.Language;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class SkillDescHolder  extends AbstractHolder {

    private static final Pattern LINE_PATTERN = Pattern.compile("^([0-9]+)\\t([0-9]+)\\t(.*?)$");

    private static final SkillDescHolder _instance = new SkillDescHolder();
    private final Map<Language, TIntObjectMap<String>> _skillDescs = new HashMap<>();

    public static SkillDescHolder getInstance() {
        return _instance;
    }

    private SkillDescHolder() { }

    public String getSkillDesc(Language lang, int hashCode) {
        TIntObjectMap<String> skillDescs = _skillDescs.get(lang);
        String desc = skillDescs.get(hashCode);
        if(desc == null) {
            Language secondLang = lang;
            do {
                if(secondLang == secondLang.getSecondLanguage())
                    break;

                secondLang = secondLang.getSecondLanguage();
                skillDescs = _skillDescs.get(secondLang);
                desc = skillDescs.get(hashCode);
            }
            while(desc == null);

            if(desc == null) {
                for(Language l : Language.VALUES) {
                    skillDescs = _skillDescs.get(secondLang);
                    if((desc = skillDescs.get(hashCode)) != null)
                        break;
                }
            }
        }
        return desc;
    }

    public String getSkillDesc(Player player, int hashCode) {
        Language lang = player == null ? Config.DEFAULT_LANG : player.getLanguage();
        return getSkillDesc(lang, hashCode);
    }

    public String getSkillDesc(Language lang, Skill skill) {
        return getSkillDesc(lang, skill.hashCode());
    }

    public String getSkillDesc(Player player, Skill skill) {
        return getSkillDesc(player, skill.hashCode());
    }

    public String getSkillDesc(Language lang, int id, int level) {
        return getSkillDesc(lang, SkillHolder.getInstance().getHashCode(id, level));
    }

    public String getSkillDesc(Player player, int id, int level) {
        return getSkillDesc(player, SkillHolder.getInstance().getHashCode(id, level));
    }

    /*
     * WARNING - Removed try catching itself - possible behaviour change.ВНИМАНИЕ - Удалена попытка поймать себя - возможное изменение поведения.
     */
    public void load()
    {
        for(Language lang : Language.VALUES)
        {
            _skillDescs.put(lang, new TIntObjectHashMap<String>());

            if(!Config.AVAILABLE_LANGUAGES.contains(lang))
                continue;

            File file = new File(Config.DATAPACK_ROOT, "data/string/skilldesc/" + lang.getShortName() + ".txt");
            if(!file.exists())
            {
                if(!lang.isCustom())
                    warn("Not find file: " + file.getAbsolutePath());
            }
            else
            {
                Scanner scanner = null;
                try
                {
                    String content = Files.readFile(file);
                    scanner = new Scanner(content);
                    int i = 0;
                    String line;
                    while(scanner.hasNextLine())
                    {
                        i++;
                        line = scanner.nextLine();
                        if(line.startsWith("#"))
                            continue;

                        Matcher m = LINE_PATTERN.matcher(line);
                        if(m.find())
                        {
                            int id = Integer.parseInt(m.group(1));
                            int level = Integer.parseInt(m.group(2));
                            int hashCode = SkillHolder.getInstance().getHashCode(id, level);
                            String value = m.group(3);

                            _skillDescs.get(lang).put(hashCode, value);
                        }
                        else
                            error("Error on line #: " + i + "; file: " + file.getName());
                    }
                }
                catch(Exception e)
                {
                    error("Exception: " + e, e);
                }
                finally
                {
                    try
                    {
                        scanner.close();
                    }
                    catch(Exception e)
                    {
                        //
                    }
                }
            }
        }

        log();
    }

    /*public void load() {
        for (Language lang : Language.VALUES) {
            _skillDescs.put(lang, new TIntObjectHashMap<String>());
            File file = new File(Config.DATAPACK_ROOT, "data/string/skilldesc/" + lang.getShortName() + ".txt");
            if (!file.exists()) {
                if (lang != Language.ENGLISH && lang != Language.RUSSIAN) continue;
                warn("Not find file: " + file.getAbsolutePath());
                continue;
            }
            BufferedReader reader = null;
            try {
                reader = new LineNumberReader(new FileReader(file));
                String line = null;
                while ((line = reader.readLine()) != null) {
                    StringTokenizer token = new StringTokenizer(line, "\t");
                    if (token.countTokens() < 2) {
                        error("Error on line: " + line + "; file: " + file.getName());
                        continue;
                    }
                    int id = Integer.parseInt(token.nextToken());
                    int level = Integer.parseInt(token.nextToken());
                    int hashCode = SkillUtils.getSkillPTSHash(id, level);
                    String value = token.hasMoreTokens() ? token.nextToken() : "";
                    _skillDescs.get(lang).put(hashCode, value);
                }
                continue;
            } catch (Exception e) {
                error("Exception: " + e, e);
            } finally {
                try {
                    reader.close();
                } catch (Exception e) {
                }
            }
        }
        log();
    }*/

    public void reload() {
        clear();
        load();
    }

    public void log() {
        for (Map.Entry<Language, TIntObjectMap<String>> entry : _skillDescs.entrySet()) {
            info("load skill descs: " + entry.getValue().size() + " for lang: " + entry.getKey());
        }
    }

    public int size() {
        return _skillDescs.size();
    }

    public void clear() {
        _skillDescs.clear();
    }
}

