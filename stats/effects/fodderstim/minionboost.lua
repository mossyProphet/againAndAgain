function init()
  --podsCur = status.resource("minionSlotsCount")
  
  minionBoost = config.getParameter("minionBonus", 1)
  applied = true
  --minionBonus = (status.resource("minionSlotsCount") + 4)/4

  --effect.addStatModifierGroup({{stat = "minionStatsBonus", effectiveMultiplier = minionBonus}})
end

function update(dt)
	
	if applied then	
		if entity.entityType() == "monster" then
			--effect.addStatModifierGroup({{stat = "powerMultiplier", amount = 1}})
			effect.addStatModifierGroup({{stat = "maxHealth", baseMultiplier = 1.05*minionBoost}})
			effect.addStatModifierGroup({{stat = "healthRegen", amount = 10*minionBoost}})
		else
			effect.addStatModifierGroup({{stat = "minionStatsBonus", amount = minionBoost}})
		end
		applied = false
	end
		
end

function uninit()
	applied = true

end