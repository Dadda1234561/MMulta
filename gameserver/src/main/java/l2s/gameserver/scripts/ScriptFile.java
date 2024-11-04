package l2s.gameserver.scripts;

public interface ScriptFile
{
	void onLoad();

	void onReload();

	void onShutdown();
}
