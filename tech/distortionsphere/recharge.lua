function init()
  --status.setResourcePercentage("energyRegenBlock", 0.0)
  --effect.addStatModifierGroup({stat = "energyRegenPercentageRate", amount = 0})
  local enableParticles = config.getParameter("particles", true)
end


function update(args)
  status.setResourcePercentage("energyRegenBlock", 1.0)
  if not self.specialLast and args.moves["special1"] then
    attemptActivation()
  end
  self.specialLast = args.moves["special1"]

  if not args.moves["special1"] then
    self.forceTimer = nil
  end
  
  --status.addEphemeralEffect("recharging", 64)
  --sb.logInfo("%s", status.resource("rechargeCooldown"))
  if (status.resourcePercentage("rechargeCooldown") >= 0.5) and (status.resourcePercentage("rechargeCooldown") < 1.0) then
     animator.burstParticleEmitter("activateParticles", 2)
     if (status.resourcePercentage("rechargeCooldown") <= 0.8) then
        animator.burstParticleEmitter("deactivateParticles", 2)
     end
   end
end

function attemptActivation()
  if not tech.parentLounging() and not status.statPositive("activeMovementAbilities") and not recharge and (status.resourcePercentage("rechargeCooldown") >= 1.0) then
     status.setResource("rechargeCooldown", 0)
     --status.modifyResourcePercentage("energy", 1.0)
     animator.playSound("activate")
     animator.setParticleEmitterBurstCount("deactivateParticles", 2)
     recharge = true
  elseif (status.resourcePercentage("rechargeCooldown") >= 0.5) then
    animator.playSound("deactivate")
    animator.setParticleEmitterBurstCount("activateParticles", 2)
    if recharge then
        if (status.resourcePercentage("rechargeCooldown") <= 0.8) then
            animator.playSound("deactivate")
            animator.setParticleEmitterBurstCount("activateParticles", 2)
            status.addEphemeralEffect("activereload", 5)
            status.modifyResourcePercentage("energy", 1.0)
            recharge = false
            status.setResourcePercentage("rechargeCooldown", 1.0)
        end
        status.modifyResourcePercentage("energy", 1.0)
        recharge = false
        status.setResourcePercentage("rechargeCooldown", 1.0)
        
    end
  end
end