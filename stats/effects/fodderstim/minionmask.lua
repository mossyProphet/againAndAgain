
function init()
	applied = true
	
end

function update(dt)
	if applied then
		effect.addStatModifierGroup({{stat = "minionStatsBonus", amount = 1}})
		if entity.entityType() == "monster" then
			effect.addStatModifierGroup({{stat = "powerMultiplier", amount = 1.35}})
			effect.addStatModifierGroup({{stat = "maxHealth", baseMultiplier = 1.05}})
			effect.addStatModifierGroup({{stat = "healthRegen", amount = 10}})
		end
		applied = false
	end
		
end

function uninit()
	 applied = true
	--status.clearPersistentEffects("minions")

end

