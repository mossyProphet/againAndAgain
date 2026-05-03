require "/scripts/vec2.lua"
require "/scripts/util.lua"

function init()
  self.homingDistance = config.getParameter("homingDistance", 20)
  self.rotationRate = config.getParameter("rotationRate")
  self.trackingLimit = config.getParameter("trackingLimit")
  self.sourceEntity = projectile.sourceEntity()
  self.queryParameters = {
    withoutEntityId = self.sourceEntity,
    includedTypes = {"player"},
    order = "nearest"
  }

  local ttlVariance = config.getParameter("timeToLiveVariance")
  if ttlVariance then
    projectile.setTimeToLive(projectile.timeToLive() + sb.nrand(ttlVariance))
  end

  stubCount = 3 -- 3
  segments = 9 
  magnitude = 1.2 -- 1.2
  size = 6 -- 4.5
  burstCount = 1 -- 1
  hueTimer = 0 -- In reality only used for the drawable. Particles log the timer and work on a local variable of it
  fireDelay = 27 -- In frames
  speedOfLightnings = mcontroller.velocity()
end

function update(dt)
  if rateTimer == nil then
		rateTimer = fireDelay
  else
  	rateTimer = rateTimer + 1
  end
  if rateTimer >= fireDelay then
  	rateTimer = 0
    generateStreak(mcontroller.position(), stubCount, segments, magnitude, size)
  end

  local pos = mcontroller.position()
  local candidates = world.entityQuery(pos, self.homingDistance, self.queryParameters)

  if #candidates == 0 then return end

  local vel = mcontroller.velocity()
  local angle = vec2.angle(vel)

  for _, candidate in ipairs(candidates) do
    if world.entityCanDamage(self.sourceEntity, candidate) then
      local canPos = world.entityPosition(candidate)
      if not world.lineTileCollision(pos, canPos) then
        local toTarget = world.distance(canPos, pos)
        local toTargetAngle = util.angleDiff(angle, vec2.angle(toTarget))

        if math.abs(toTargetAngle) > self.trackingLimit then
          return
        end

        local rotateAngle = math.max(dt * -self.rotationRate, math.min(toTargetAngle, dt * self.rotationRate))

        vel = vec2.rotate(vel, rotateAngle)
        mcontroller.setVelocity(vel)

        break
      end
    end
  end

  mcontroller.setRotation(math.atan(vel[2], vel[1]))
end


function generateStreak(startPos, stubCount, segments, magnitude, size)
    stubCount = stubCount or 3
    segments = segments or 5
    magnitude = magnitude or 1.5
    local hue = hueTimer

    for i = 1, stubCount do
    	local currentPos = vec2.add(startPos, vec2.mul(speedOfLightnings, 0.175))
    	local nextPos = vec2.add(currentPos, {randomFloat(-magnitude, magnitude, 2), randomFloat(-magnitude, magnitude, 2)})
    	local stubPos = nextPos
    	local stubDir = world.distance(currentPos, stubPos)
    	local stubAngle = vec2.angle(stubDir)
    	local length = vec2.mag(stubDir)
    	local maxAngle = math.rad(100)

        local dist = world.distance(currentPos, nextPos)
        local mag = world.magnitude(currentPos, nextPos)
        for s = 1, segments do
        	hue = hue + 4
			local newAngle = stubAngle + randomFloat(-maxAngle, maxAngle, 2)
			local stepLength = randomFloat(0.5, magnitude, 2)
			local newVector = { math.cos(newAngle) * stepLength, math.sin(newAngle) * stepLength }
			nextPos = vec2.add(currentPos, newVector)
			dist = world.distance(currentPos, nextPos)
			mag = world.magnitude(currentPos, nextPos)
			world.spawnProjectile("boltguide", currentPos, entity.id(), {0,0}, false, {
				damageTeam = {type = "ghostly"},
				movementSettings = {collisionPoly = jarray(), collisionEnabled = false},
				timeToLive = 0.15,
				processing = "?crop=0;0;0;0",
				speed = 0,
				actionOnReap = {{
						action = "particle",
						["repeat"] = false,
						rotate = false,
						specification = {
							type = "streak",
							layer = "front",
							fullbright = true,
							destructionAction = "shrink",
							variance = {length = 0},
							color = colorFromHue(hue),
							collidesForeground = false,
							collidesLiquid = true,
							destructionTime = util.clamp(0.015 * s, 0.015, 0.35),
							timeToLive = util.clamp(0.01 + s/80, 0.05, 0.32),
							size = util.clamp(size - (s * size)/segments, 0.1, 10),
							position = {0, 0},
							--initialVelocity = vec2.mul(vec2.norm(dist), vec2.mul(speedOfLightnings, 1)), -- when you desire for streams of current
							initialVelocity = vec2.mul(vec2.norm(dist), 0.001), -- when you desire for usual bolts
							length = mag * 8
						}
					}}
				}
			)
			currentPos = nextPos
			
		end
    end
end

function resetPos()
	animator.resetTransformationGroup("broom")
	animator.translateTransformationGroup("broom", {-0.7, 3})
end

function findValidTarget(entities)
	for i = 1, #entities do
		if world.entityAggressive(entities[i]) then
			return true, i
		end
	end
	return false, nil
end

function randomFloat(min, max, decimals)
  	local rand = math.random()
  	local value = min + (max - min) * rand
  	local factor = 10 ^ (decimals or 0)
  	return math.floor(value * factor + 0.5) / factor
end

function hsvToRgb(h, s, v)
	local c = v * s
	local x = c * (1 - math.abs((h / 60) % 2 - 1))
	local m = v - c
	local r, g, b
	if h < 60 then
		r, g, b = c, x, 0
	elseif h < 120 then
		r, g, b = x, c, 0
	elseif h < 180 then
		r, g, b = 0, c, x
	elseif h < 240 then
		r, g, b = 0, x, c
	elseif h < 300 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end
	return {
		math.floor((r + m) * 255),
		math.floor((g + m) * 255),
		math.floor((b + m) * 255),
		255
	}
end

function colorFromHue(hue)
	return hsvToRgb(hue % 120 + 240, 0.5, 1)
end