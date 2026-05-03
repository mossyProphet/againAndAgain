function init()
  animator.setParticleEmitterOffsetRegion("energy", mcontroller.boundBox())
  animator.setParticleEmitterEmissionRate("energy", config.getParameter("emissionRate", 5))
  animator.setParticleEmitterActive("energy", true)

  effect.addStatModifierGroup({
      {stat = "energyRegenPercentageRate", amount = config.getParameter("regenBonusAmount", 10)},
      {stat = "maxHealth", effectiveMultiplier = 0.9}
    })
   script.setUpdateDelta(5)

  self.tickDamagePercentage = 0.1*math.abs(1/(mcontroller.xVelocity() + mcontroller.yVelocity()))
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
end

function update(dt)
  self.tickDamagePercentage = 0.1*math.abs(1/(mcontroller.xVelocity() + mcontroller.yVelocity() + 3))
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "poison",
        sourceEntityId = entity.id()
      })
  end

  effect.setParentDirectives(string.format("fade=00AA00=%.1f", self.tickTimer * 0.4))
end

function uninit()

end
