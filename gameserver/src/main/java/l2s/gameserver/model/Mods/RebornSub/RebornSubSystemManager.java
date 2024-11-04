package l2s.gameserver.model.Mods.RebornSub;

import gnu.trove.map.hash.TIntObjectHashMap;
import l2s.gameserver.Config;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;

public class RebornSubSystemManager {
    private static final Logger logger = LoggerFactory.getLogger(RebornSubSystemManager.class);
    private static TIntObjectHashMap<RebornSubSystemInfo> _resetlevel = new TIntObjectHashMap<>();
    private static boolean isEnable;
    private static boolean staticrate;
    private static int maxSTR;
    private static int maxDEX;
    private static int maxMEN;
    private static int maxWIT;

    private static int maxCON;
    private static int maxINT;
    private static int maxPvePhysDmg;
    private static int maxPveMagDmg;

    private static int maxCHA;
    private static int maxMaxCP;
    private static int maxMaxHP;
    private static int maxMaxMP;

    private static int maxPhysDmg;
    private static int maxMagDmg;
    private static int maxPhysDef;
    private static int maxMagDef;

    private static int maxPhysCritDmg;
    private static int maxMagCritDmg;
    private static int maxPhysCritRate;
    private static int maxMagCritRate;

    private static int maxPvpDmg;
    private static int maxPvpMagDmg;
    private static int maxPvpDef;
    private static int maxPvpMagDef;

    private static int maxMReuse;
    private static int maxAdenaRate;
    private static int maxExpRate;
    private static int maxDropRate;

    public static void load() {
        int id = 0;
        int needlevel = 0;
        int resetLevel = 0;
        int resetTime = 0;
        String needItem = "";
        String giveItem = "";
        double rateExp = 0;
        double rateSp = 0;
        int str = 0;
        int dex = 0;
        int con = 0;
        int wit = 0;

        int i_n_t = 0;
        int men = 0;
        int PvePhysDmg = 0;
        int PveMagDmg = 0;

        int CHA = 0;
        int MaxCP = 0;
        int MaxHP = 0;
        int MaxMP = 0;

        int PhysDmg = 0;
        int MagDmg = 0;
        int PhysDef = 0;
        int MagDef = 0;

        int PhysCritDmg = 0;
        int MagCritDmg = 0;
        int PhysCritRate = 0;
        int MagCritRate = 0;

        int PvpDmg = 0;
        int PvpMagDmg = 0;
        int PvpDef = 0;
        int PvpMagDef = 0;

        int MReuse = 0;
        int AdenaRate = 0;
        int ExpRate = 0;
        int DropRate = 0;

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(false);
        factory.setIgnoringComments(true);

        File file = new File(Config.DATAPACK_ROOT, "data/xml/reborn_system_sub/rebornSub.xml");
        Document doc = null;
        if (file.exists()) {
            try {
                doc = factory.newDocumentBuilder().parse(file);
            } catch (Exception e) {
                logger.warn("Could not parse reborn.xml file: " + e.getMessage(), e);
                return;
            }
            for (Node n = doc.getFirstChild(); n != null; n = n.getNextSibling()) {
                if ("list".equalsIgnoreCase(n.getNodeName())) {
                    for (Node d = n.getFirstChild(); d != null; d = d.getNextSibling()) {
                        if ("configs".equalsIgnoreCase(d.getNodeName())){
                            final NamedNodeMap attrs = d.getAttributes();
                            isEnable = Boolean.parseBoolean(attrs.getNamedItem("enable").getNodeValue());
                            staticrate = Boolean.parseBoolean(attrs.getNamedItem("staticrate").getNodeValue());
                            maxSTR = Integer.parseInt(attrs.getNamedItem("maxSTR").getNodeValue());
                            maxDEX = Integer.parseInt(attrs.getNamedItem("maxDEX").getNodeValue());
                            maxCON = Integer.parseInt(attrs.getNamedItem("maxCON").getNodeValue());
                            maxWIT = Integer.parseInt(attrs.getNamedItem("maxWIT").getNodeValue());

                            maxINT = Integer.parseInt(attrs.getNamedItem("maxINT").getNodeValue());
                            maxMEN = Integer.parseInt(attrs.getNamedItem("maxMEN").getNodeValue());
                            maxPvePhysDmg = Integer.parseInt(attrs.getNamedItem("maxPvePhysDmg").getNodeValue());
                            maxPveMagDmg = Integer.parseInt(attrs.getNamedItem("maxPveMagDmg").getNodeValue());

                            maxCHA = Integer.parseInt(attrs.getNamedItem("maxCHA").getNodeValue());
                            maxMaxCP = Integer.parseInt(attrs.getNamedItem("maxMaxCP").getNodeValue());
                            maxMaxHP = Integer.parseInt(attrs.getNamedItem("maxMaxHP").getNodeValue());
                            maxMaxMP = Integer.parseInt(attrs.getNamedItem("maxMaxMP").getNodeValue());

                            maxPhysDmg = Integer.parseInt(attrs.getNamedItem("maxPhysDmg").getNodeValue());
                            maxMagDmg = Integer.parseInt(attrs.getNamedItem("maxMagDmg").getNodeValue());
                            maxPhysDef = Integer.parseInt(attrs.getNamedItem("maxPhysDef").getNodeValue());
                            maxMagDef = Integer.parseInt(attrs.getNamedItem("maxMagDef").getNodeValue());

                            maxPhysCritDmg = Integer.parseInt(attrs.getNamedItem("maxPhysCritDmg").getNodeValue());
                            maxMagCritDmg = Integer.parseInt(attrs.getNamedItem("maxMagCritDmg").getNodeValue());
                            maxPhysCritRate = Integer.parseInt(attrs.getNamedItem("maxPhysCritRate").getNodeValue());
                            maxMagCritRate = Integer.parseInt(attrs.getNamedItem("maxMagCritRate").getNodeValue());

                            maxPvpDmg = Integer.parseInt(attrs.getNamedItem("maxPvpDmg").getNodeValue());
                            maxPvpMagDmg = Integer.parseInt(attrs.getNamedItem("maxPvpMagDmg").getNodeValue());
                            maxPvpDef = Integer.parseInt(attrs.getNamedItem("maxPvpDef").getNodeValue());
                            maxPvpMagDef = Integer.parseInt(attrs.getNamedItem("maxPvpMagDef").getNodeValue());

                            maxMReuse = Integer.parseInt(attrs.getNamedItem("maxMReuse").getNodeValue());
                            maxAdenaRate = Integer.parseInt(attrs.getNamedItem("maxAdenaRate").getNodeValue());
                            maxExpRate = Integer.parseInt(attrs.getNamedItem("maxExpRate").getNodeValue());
                            maxDropRate = Integer.parseInt(attrs.getNamedItem("maxDropRate").getNodeValue());
                        }
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

                            att = attrs.getNamedItem("rate_exp");
                            if (att != null)
                                rateExp = Double.parseDouble(att.getNodeValue());

                            att = attrs.getNamedItem("rate_sp");
                            if (att != null)
                                rateSp = Double.parseDouble(att.getNodeValue());

                            att = attrs.getNamedItem("str");
                            if (att != null)
                                str = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("dex");
                            if (att != null)
                                dex = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("con");
                            if (att != null) {
                                con = Integer.parseInt(att.getNodeValue());
                            }

                            att = attrs.getNamedItem("wit");
                            if (att != null)
                                wit = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("int");
                            if (att != null)
                                i_n_t = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("men");
                            if (att != null)
                                men = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PvePhysDmg");
                            if (att != null)
                                PvePhysDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PveMagDmg");
                            if (att != null)
                                PveMagDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("CHA");
                            if (att != null)
                                CHA = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MaxCP");
                            if (att != null)
                                MaxCP = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MaxHP");
                            if (att != null)
                                MaxHP = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MaxMP");
                            if (att != null)
                                MaxMP = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PhysDmg");
                            if (att != null)
                                PhysDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MagDmg");
                            if (att != null)
                                MagDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PhysDef");
                            if (att != null)
                                PhysDef = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MagDef");
                            if (att != null)
                                MagDef = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PhysCritDmg");
                            if (att != null)
                                PhysCritDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MagCritDmg");
                            if (att != null)
                                MagCritDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PhysCritRate");
                            if (att != null)
                                PhysCritRate = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PhysCritRate");
                            if (att != null)
                                MagCritRate = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PvpDmg");
                            if (att != null)
                                PvpDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PvpMagDmg");
                            if (att != null)
                                PvpMagDmg = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PvpDef");
                            if (att != null)
                                PvpDef = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("PvpMagDef");
                            if (att != null)
                                PvpMagDef = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("MReuse");
                            if (att != null)
                                MReuse = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("AdenaRate");
                            if (att != null)
                                AdenaRate = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("ExpRate");
                            if (att != null)
                                ExpRate = Integer.parseInt(att.getNodeValue());

                            att = attrs.getNamedItem("DropRate");
                            if (att != null)
                                DropRate = Integer.parseInt(att.getNodeValue());

                            RebornSubSystemInfo stat = new RebornSubSystemInfo();
                            stat.setRebornId(id);
                            stat.setLevelNeed(needlevel);
                            stat.setNeedItem(needItem);
                            stat.setreward(giveItem);
                            stat.setResetLevel(resetLevel);
                            stat.setResetTime(resetTime);
                            stat.setRateExp(rateExp);
                            stat.setRateSp(rateSp);

                            stat.setSTR(str);
                            stat.setDEX(dex);
                            stat.setCON(con);
                            stat.setWIT(wit);

                            stat.setINT(i_n_t);
                            stat.setMEN(men);
                            stat.setPvePhysDmg(PvePhysDmg);
                            stat.setPveMagDmg(PveMagDmg);

                            stat.setCHA(CHA);
                            stat.setMaxCP(MaxCP);
                            stat.setMaxHP(MaxHP);
                            stat.setMaxMP(MaxMP);

                            stat.setPhysDmg(PhysDmg);
                            stat.setMagDmg(MagDmg);
                            stat.setPhysDef(PhysDef);
                            stat.setMagDef(MagDef);

                            stat.setPhysCritDmg(PhysCritDmg);
                            stat.setMagCritDmg(MagCritDmg);
                            stat.setPhysCritRate(PhysCritRate);
                            stat.setMagCritRate(MagCritRate);

                            stat.setPvpDmg(PvpDmg);
                            stat.setPvpMagDmg(PvpMagDmg);
                            stat.setPvpDef(PvpDef);
                            stat.setPvpMagDef(PvpMagDef);

                            stat.setMReuse(MReuse);
                            stat.setAdenaRate(AdenaRate);
                            stat.setExpRate(ExpRate);
                            stat.setDropRate(DropRate);

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

    public static RebornSubSystemInfo getRebornId(int resetId) {
        //FIXME: Не понятно почему чар до этого стартовал с 1 перерождением..
        return _resetlevel.get((resetId + 1));
    }

    public static boolean enableReborn() {
        return isEnable;
    }

    public static boolean staticRate() {
        return staticrate;
    }

    public static int maxSTR(){
        return maxSTR;
    }

    public static int maxDEX(){
        return maxDEX;
    }

    public static int maxCON(){
        return maxCON;
    }

    public static int maxWIT(){
        return maxWIT;
    }


    public static int maxINT(){
        return maxINT;
    }

    public static int maxMEN(){
        return maxMEN;
    }

    public static int maxPvePhysDmg(){
        return maxPvePhysDmg;
    }

    public static int maxPveMagDmg(){
        return maxPveMagDmg;
    }

    public static int maxCHA(){
        return maxCHA;
    }
    public static int maxMaxCP(){
        return maxMaxCP;
    }

    public static int maxMaxHP(){
        return maxMaxHP;
    }

    public static int maxMaxMP(){
        return maxMaxMP;
    }

    public static int maxPhysDmg(){
        return maxPhysDmg;
    }

    public static int maxMagDmg(){
        return maxMagDmg;
    }

    public static int maxPhysDef(){
        return maxPhysDef;
    }

    public static int maxMagDef(){
        return maxMagDef;
    }

    public static int maxPhysCritDmg(){
        return maxPhysCritDmg;
    }

    public static int maxMagCritDmg(){
        return maxMagCritDmg;
    }

    public static int maxPhysCritRate(){
        return maxPhysCritRate;
    }

    public static int maxMagCritRate(){
        return maxMagCritRate;
    }

    public static int maxPvpDmg(){
        return maxPvpDmg;
    }

    public static int maxPvpMagDmg(){
        return maxPvpMagDmg;
    }

    public static int maxPvpDef(){
        return maxPvpDef;
    }

    public static int maxPvpMagDef(){
        return maxPvpMagDef;
    }

    public static int maxMReuse(){
        return maxMReuse;
    }

    public static int maxAdenaRate(){
        return maxAdenaRate;
    }

    public static int maxExpRate(){
        return maxExpRate;
    }

    public static int maxDropRate(){
        return maxDropRate;
    }
}
