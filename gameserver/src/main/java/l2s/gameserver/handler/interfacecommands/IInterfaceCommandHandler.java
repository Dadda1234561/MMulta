package l2s.gameserver.handler.interfacecommands;


import l2s.gameserver.model.Player;

public interface IInterfaceCommandHandler {
    public String[] getInterfaceCommandList();

    public void useInterfaceCommand(String command, Player activeChar);
}
