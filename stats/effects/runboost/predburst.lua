function init()
  --Power
  animator.playSound("discharge")
  self.powerModifier = config.getParameter("powerModifier", 0)
  self.speedModifier = config.getParameter("speedModifier", 0)
  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = self.powerModifier}})
  mcontroller.controlModifiers({speedModifier = self.speedModifier})
  local enableParticles = config.getParameter("particles", true)
  animator.setParticleEmitterOffsetRegion("embers", mcontroller.boundBox())
  animator.setParticleEmitterActive("embers", enableParticles)
end


function update(dt)
	 mcontroller.controlModifiers({speedModifier = 1.5})
  
end

function uninit()

end
