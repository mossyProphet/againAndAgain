
function init()
	
	applied = true
end

function update(dt)
	if applied then
		if entity.entityType() == "monster" then
			effect.addStatModifierGroup({{stat = "protection", amount = 20}})
			effect.addStatModifierGroup({{stat = "maxHealth", baseMultiplier = 1.05}})
			effect.addStatModifierGroup({{stat = "healthRegen", amount = 10}})
		end
		applied = false
	end
end

function uninit()
	
	--status.clearPersistentEffects("minions")
	applied = true
end

