require "/scripts/vec2.lua"

function init()
    self.minPregenerateTime = config.getParameter("minPregenerateTime", 5)
    self.basePregenerateTime = config.getParameter("basePregenerateTime", 10)
    self.pregenerateTimePerTile = config.getParameter("pregenerateTimePerTile", 0.1)

    self.planetTypeChangeThreshold = config.getParameter("planetTypeChangeThreshold", 0.5)
    self.terraformInterferenceBuffer = config.getParameter("terraformInterferenceBuffer", 50)
    planetTypeChanged = false
    growthCounter = 0
	self.biome = config.getParameter("terraformBiome")
	self.planetType = config.getParameter("terraformPlanetType")
	self.size = self.size or 5
	self.targetSize = self.targetSize or self.size

	local terraformOffset = config.getParameter("terraformOffset", {0, 0})
	self.terraformPosition = vec2.add(entity.position(), terraformOffset)



    if not self.pregenerationFinished then
      self.pregenerationFinished = world.pregenerateAddBiome(self.terraformPosition, self.targetSize)
      -- if self.pregenerationFinished then sb.logInfo("pregeneration to add biome finished after %s seconds", addTimer) end
    end
    world.addBiomeRegion(self.terraformPosition, self.biome, "largeClumps", self.targetSize)

    self.size = self.targetSize

      -- sb.logInfo("added biome %s at %s with self.size %s after %s seconds of pregeneration", self.biome, self.terraformPosition, self.targetSize, addTimer)

    updatePlanetType()
end
 --"terraformBiome" : "undivided_tentacle",
  --"terraformPlanetType" : "tentacle"

function update(dt)
  growthCounter = growthCounter + sb.nrand(25, 25)
  --
  --if not self.pregenerationFinished then
  --    self.pregenerationFinished = world.pregenerateExpandBiome(self.terraformPosition, self.targetSize)
  --    -- if self.pregenerationFinished then sb.logInfo("pregeneration to add biome finished after %s seconds", addTimer) end
  --  end
  --    world.expandBiomeRegion(self.terraformPosition, self.targetSize)
  --
  --    self.size = self.targetSize
  --
  --    -- sb.logInfo("added biome %s at %s with self.size %s after %s seconds of pregeneration", self.biome, self.terraformPosition, self.targetSize, addTimer)
  --
  --    updatePlanetType()
  --  
  --
  if growthCounter >= 10000 then
    if not planetTypeChanged then
    if not self.pregenerationFinished then
      self.pregenerationFinished = world.pregenerateAddBiome(self.terraformPosition, self.targetSize)
      -- if self.pregenerationFinished then sb.logInfo("pregeneration to add biome finished after %s seconds", addTimer) end
    end
    world.addBiomeRegion(self.terraformPosition, self.biome, "largeClumps", self.targetSize)

    self.size = self.targetSize

      -- sb.logInfo("added biome %s at %s with self.size %s after %s seconds of pregeneration", self.biome, self.terraformPosition, self.targetSize, addTimer)

    updatePlanetType()
    
      self.targetSize = self.targetSize + 250*(world.size()[1]/16000)
      self.size = self.size + 250*(world.size()[1]/16000)
    end
    growthCounter = 0
  end
end

function triggerAdd(targetSize)
  self.targetSize = self.targetSize

  self.pregenerationFinished = false

end

function triggerExpand(targetSize)
  self.targetSize = self.targetSize

  self.pregenerationFinished = false
end


function updatePlanetType()
  if not planetTypeChanged then
    local sizeRatio = self.size / world.size()[1]
    if sizeRatio >= self.planetTypeChangeThreshold then
      planetTypeChanged = true
      world.setPlanetType(self.planetType, self.biome)
      world.setLayerEnvironmentBiome(self.terraformPosition)
      
    end

  end
  
end