function init()
   --effect.addStatModifierGroup({{stat = "invisible", amount = 1}})

   script.setUpdateDelta(1)
end

function update(dt)
	xspeed = mcontroller.xVelocity()
	yspeed = mcontroller.yVelocity()
	if xspeed + yspeed < 10 then
		effect.addStatModifierGroup({{stat = "invisible", amount = 1}})
	end
	--else
	--	status.clearPersistentEffect(invisible)
	--end

end

function uninit()
  
end
