function init()
  effect.addStatModifierGroup({{stat = "gunHeatRegen", baseMultiplier = 2}})
	animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
end

function update(dt)

end

function uninit()
  
end
