package l2s.gameserver.handler.interfacecommands;

import l2s.commons.data.xml.AbstractHolder;
import l2s.gameserver.handler.interfacecommands.impl.AutoPlayCmd;
import l2s.gameserver.handler.interfacecommands.impl.CostumePreviewCmd;

import java.util.HashMap;
import java.util.Map;

public class InterfaceCommandHandler extends AbstractHolder {
    private final Map<String, IInterfaceCommandHandler> _commands = new HashMap<>();

    public InterfaceCommandHandler() {
        registerInterfaceCommandHandler(new CostumePreviewCmd());
        registerInterfaceCommandHandler(new AutoPlayCmd());
    }

    public void registerInterfaceCommandHandler(IInterfaceCommandHandler handler) {
        String[] ids = handler.getInterfaceCommandList();
        for (String command : ids)
            _commands.put(command, handler);
    }

    public IInterfaceCommandHandler getInterfaceCommandHandler(String interfaceCommand) {
        String command = interfaceCommand;
        if (interfaceCommand.contains(" "))
            command = interfaceCommand.substring(0, interfaceCommand.indexOf(" "));

        return _commands.get(command);
    }

    @Override
    public int size() {
        return _commands.size();
    }

    @Override
    public void clear() {
        _commands.clear();
    }

    public static InterfaceCommandHandler getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        protected static InterfaceCommandHandler INSTANCE = new InterfaceCommandHandler();
    }
}
