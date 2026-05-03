function init()
   effect.addStatModifierGroup({{stat = "invisible", amount = 1}})
   --effect.addStatModifierGroup({{stat = "invisible", amount = 1}})
   --script.setUpdateDelta(0)
end

function update(dt)
	xspeed = mcontroller.xVelocity()
	yspeed = mcontroller.yVelocity()
	speed = xspeed + yspeed
	if math.abs(speed) > 1 then
		local enableParticles = config.getParameter("particles", true)
		animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
		animator.setParticleEmitterActive("flames", enableParticles)
		effect.removeStatModifierGroup({{stat = "invisible"}})
	else do	
		
		effect.addStatModifierGroup({{stat = "invisible", amount = 1}})
	end
	--else
	--	status.clearPersistentEffect(invisible)
	--end

end

function uninit()
  
end
