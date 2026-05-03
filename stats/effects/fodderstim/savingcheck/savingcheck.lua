
function init()
	
	applied = true
end

function update(dt)
	if applied then
		if entity.entityType() == "monster" then
			if status.resource("health") <= 0.2 * status.resourceMax("health") then
				status.modifyResource("health", 10)
				status.addEphemeralEffect("invulnerable", 3)
				status.addEphemeralEffect("slowLove", 10)
			end
		end
		applied = false
	end
end

function uninit()
	
	--status.clearPersistentEffects("minions")
	applied = true
end

