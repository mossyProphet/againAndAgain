function init()
	--status.addPersistentEffect("predchest", {stat="maxHealth",amount=-10})
end

function update(dt)
  
end

function uninit()
   status.clearAllPersistentEffects()
end
