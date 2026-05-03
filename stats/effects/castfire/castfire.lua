function init()
  effect.addStatModifierGroup({{stat = "gunHeatRegen", baseMultiplier = 0.5}})
	animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", true)
  effect.setParentDirectives("fade=BF3300=0.25")
end

function uninit()
  
end
