package l2s.gameserver.model.Mods.RebornDivine;

import gnu.trove.map.hash.TIntObjectHashMap;
import l2s.gameserver.Config;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;

public class RebornDivineSystemManager {
    private static final Logger logger = LoggerFactory.getLogger(RebornDivineSystemManager.class);
    private static TIntObjectHashMap<RebornDivineSystemInfo> _resetlevel = new TIntObjectHashMap<>();

    public static void load() {
        int id = 0;
        int needlevel = 0;
        int resetLevel = 0;
        int resetTime = 0;
        String needItem = "";
        String giveItem = "";

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(false);
        factory.setIgnoringComments(true);

        File file = new File(Config.DATAPACK_ROOT, "data/xml/reborn_divine_system/rebornDivine.xml");
        Document doc = null;
        if (file.exists()) {
            try {
                doc = factory.newDocumentBuilder().parse(file);
            } catch (Exception e) {
                logger.warn("Could not parse rebornDivine.xml file: " + e.getMessage(), e);
                return;
            }
            for (Node n = doc.getFirstChild(); n != null; n = n.getNextSibling()) {
                if ("list".equalsIgnoreCase(n.getNodeName())) {
                    for (Node d = n.getFirstChild(); d != null; d = d.getNextSibling()) {
                        if ("reborn".equalsIgnoreCase(d.getNodeName())) {
                            NamedNodeMap attrs = d.getAttributes();
                            Node att;

                            att = attrs.getNamedItem("id");
                            if (att != null)
                                id = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("level_need");
                            if (att != null)
                                needlevel = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("needItem");
                            if (att != null)
                                needItem = att.getNodeValue();

                            att = attrs.getNamedItem("giveReward");
                            if (att != null)
                                giveItem = att.getNodeValue();

                            att = attrs.getNamedItem("reset_level");
                            if (att != null)
                                resetLevel = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("reset_time");
                            if (att != null)
                                resetTime = Integer.parseInt(att.getNodeValue());

                            RebornDivineSystemInfo stat = new RebornDivineSystemInfo();
                            stat.setRebornId(id);
                            stat.setLevelNeed(needlevel);
                            stat.setNeedItem(needItem);
                            stat.setreward(giveItem);
                            stat.setResetLevel(resetLevel);
                            stat.setResetTime(resetTime);

                            _resetlevel.put(id, stat);
                        }
                    }
                }
            }
        }
        logger.info("Reborn Sub Stats: Loaded ... " + _resetlevel.size());
    }

    public static int getSize(){
        return _resetlevel.size();
    }

    public static RebornDivineSystemInfo getRebornId(int resetId) {
        return _resetlevel.get((resetId + 1));
    }

}
