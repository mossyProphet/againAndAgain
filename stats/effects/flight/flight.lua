function init()
  self.glideSpeed = config.getParameter("glideSpeed")
  effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
  if not mcontroller.onGround() then
     mcontroller.controlModifiers({speedModifier = 4*self.glideSpeed})
  end
  
end

function update(args)
    if not mcontroller.onGround() then
        mcontroller.controlModifiers({speedModifier = 4*self.glideSpeed})
    end
end

function uninit()
  effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 1}})
end

