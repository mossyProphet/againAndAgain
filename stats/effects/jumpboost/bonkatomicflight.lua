function init()
  local bounds = mcontroller.boundBox()
  animator.setParticleEmitterOffsetRegion("jumpparticles", {bounds[1], bounds[2], bounds[3], bounds[2] + 0.3})
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = 0.5}
  })
  --script.setUpdateDelta(15)
 
end

function update(dt)
  animator.setParticleEmitterActive("jumpparticles", config.getParameter("particles", true) and mcontroller.jumping())
  mcontroller.controlModifiers({
      airJumpModifier = 1.5
    })
    if mcontroller.jumping() and not mcontroller.onGround() then
        mcontroller.controlParameters({
            gravityMultiplier = 0.4
        })
        --mcontroller.setYVelocity(math.max(0, mcontroller.yVelocity()*1.5))
        --sb.logInfo("multiplied")
        --mcontroller.controlForce()
        --sb.logInfo("%s", mcontroller.velocity()[1])
    end
    effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
end

function uninit()
  effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 1}})
end
