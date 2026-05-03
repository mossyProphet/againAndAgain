function init()
	status.setResource("onMinionCooldown", 1)
end

function update(dt)
  
end

function uninit()
   status.setResource("onMinionCooldown", 0)
end
