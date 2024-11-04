package l2s.commons.threading;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class RunnableImpl implements Runnable
{
	protected static final Logger _log = LoggerFactory.getLogger(RunnableImpl.class);

	protected abstract void runImpl() throws Exception;

	@Override
	public final void run()
	{
		try
		{
			runImpl();
		}
		catch(Exception e)
		{
			_log.error("Exception: RunnableImpl.run(): " + e, e);
		}
	}
}
