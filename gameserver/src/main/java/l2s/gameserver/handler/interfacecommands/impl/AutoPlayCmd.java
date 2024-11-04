package l2s.gameserver.handler.interfacecommands.impl;

import l2s.gameserver.handler.interfacecommands.IInterfaceCommandHandler;
import l2s.gameserver.model.Player;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author sharp
 * https://t.me/sharp1que
 */
public class AutoPlayCmd implements IInterfaceCommandHandler
{
    private static final Logger _log = LoggerFactory.getLogger(AutoPlayCmd.class);
    private static final String[] COMMANDS = {"autoplaySettings"};


    @Override
    public String[] getInterfaceCommandList()
    {
        return COMMANDS;
    }

    @Override
    public void useInterfaceCommand(String command, Player activeChar)
    {
        if (activeChar == null)
        {
            return;
        }

        if (command.startsWith("autoplaySettings"))
        {
            String[] args = command.split(" ");
            if (args.length > 2) {
                String param = args[2];
                switch (args[1]) {
                    case "range1": {
                        int shortRange = 600;
                        try {
                            int parsedValue = Integer.parseInt(param);
                            shortRange = Math.max(1, Math.min(parsedValue, 1399));
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                        activeChar.getAutoFarm().setShortAttackRange(shortRange);
                    }
                    break;
                    case "range2": {
                        int longRange = 1400;
                        try {
                            int parsedValue = Integer.parseInt(param);
                            longRange = Math.max(1400, Math.min(parsedValue, 3000));
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                        activeChar.getAutoFarm().setLongAttackRange(longRange);
                    }
                    break;
                    case "targetRaid": {
                        boolean enabled = false;
                        try {
                            enabled = Boolean.parseBoolean(param);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        activeChar.getAutoFarm().setTargetRaid(enabled);
                    }
                    break;
                    case "fixedZone": {
                        boolean enabled = false;
                        try {
                            enabled = Boolean.parseBoolean(param);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        activeChar.getAutoFarm().setFixedZone(enabled, null);
                    }
                    break;
                    case "meleeMode": {
                        boolean isMeeleMode = false;
                        try {
                            isMeeleMode = Boolean.parseBoolean(param);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        activeChar.getAutoFarm().setMeleeAttackMode(isMeeleMode);
                    }
                    break;
                    case "showRange": {
                        boolean enabled = false;
                        try {
                            enabled = Boolean.parseBoolean(param);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        activeChar.getAutoFarm().setShowRadius(enabled);
                    }
                    break;
                    default: {
                        _log.info("{} executed non-handled command \"{}\" in {} class.", activeChar.getName(), args[1], getClass().getSimpleName());
                    }
                    break;
                }
            }
        }
    }
}
