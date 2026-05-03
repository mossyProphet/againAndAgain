function init()
  effect.addStatModifierGroup({{stat = "gunHeatRegen", baseMultiplier = 2}})
	animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", true)
  effect.setParentDirectives("fade=4dd0fd=0.25")
end

function uninit()
  
end
