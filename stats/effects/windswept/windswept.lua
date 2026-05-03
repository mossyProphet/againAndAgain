function init()
	effect.addStatModifierGroup({{stat = "gunHeatRegen", baseMultiplier = 2}})
	self.movementParameters = config.getParameter("movementParameters")
end

function update(dt)
  mcontroller.controlParameters(self.movementParameters)
end

function uninit()

end
