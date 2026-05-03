function init()
  animator.setParticleEmitterOffsetRegion("healing", mcontroller.boundBox())
  animator.setParticleEmitterActive("healing", config.getParameter("particles", true))

  script.setUpdateDelta(5)

  self.healingRate = 1.0 / config.getParameter("healTime", 30)
end

function update(dt)
  status.modifyResourcePercentage("health", self.healingRate * dt)
  if status.resource("health") < 40 then
    effect.addStatModifierGroup({{stat = "invulnerable", amount = 1}})
  end
end


function uninit()
  effect.addStatModifierGroup({{stat = "invulnerable", amount = 0}})
end