package l2s.gameserver.skills.effects;

import l2s.commons.string.StringArrayUtils;
import l2s.commons.util.Rnd;
import l2s.gameserver.data.xml.holder.TransformTemplateHolder;
import l2s.gameserver.handler.effects.EffectHandler;
import l2s.gameserver.model.Creature;
import l2s.gameserver.model.actor.instances.creature.Abnormal;
import l2s.gameserver.model.base.TransformType;
import l2s.gameserver.templates.player.transform.TransformTemplate;
import l2s.gameserver.templates.skill.EffectTemplate;

public final class EffectTransformation extends EffectHandler
{
	private class EffectTransformationImpl extends EffectHandler
	{
		private int _transformedId = 0;

		public EffectTransformationImpl(EffectTemplate template)
		{
			super(template);
		}

		@Override
		protected boolean checkCondition(Abnormal abnormal, Creature effector, Creature effected)
		{
			if(effected != effector)
				return false;

			if(!effected.isPlayer())
				return false;

			for(int transformId : _transformIds)
			{
				if(transformId > 0)
				{
					TransformTemplate template = TransformTemplateHolder.getInstance().getTemplate(effected.getSex(), transformId);
					if(template == null)
						return false;

					if(template.getType() == TransformType.FLYING && effected.getX() > -166168)
						return false;
				}
			}
			return true;
		}

		@Override
		public void onStart(Abnormal abnormal, Creature effector, Creature effected)
		{
			_transformedId = Rnd.get(_transformIds);
			effected.setTransform(_transformedId);
		}

		@Override
		public void onExit(Abnormal abnormal, Creature effector, Creature effected)
		{
			if(_transformedId > 0)
				effected.setTransform(null);
		}
	}

	private final int[] _transformIds;

	public EffectTransformation(EffectTemplate template)
	{
		super(template);
		_transformIds = StringArrayUtils.stringToIntArray(getParams().getString("id", String.valueOf((int) getValue())), "[\\s,;]+");
	}

	@Override
	public EffectHandler getImpl()
	{
		return new EffectTransformationImpl(getTemplate());
	}
}