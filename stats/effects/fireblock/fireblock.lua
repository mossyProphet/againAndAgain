function init()
   effect.addStatModifierGroup({{stat = "fireResistance", amount = 0.25}, {stat = "fireStatusImmunity", amount = 1}})
   effect.addStatModifierGroup({{stat = "gunHeatRegen", baseMultiplier = 2}})

   script.setUpdateDelta(0)
end

function update(dt)

end

function uninit()
  
end
