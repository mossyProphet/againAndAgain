function init()
	
  count = 8
  local pi = 3.14

  local randAngle = math.random() * 2 * pi --Random radian
  local angleInterval = math.pi * 2 / count
  for x = 0, count - 1 do
    local angle = randAngle + angleInterval * x
    local needleVector = {math.cos(angle), math.sin(angle)}

    local position = mcontroller.position()
    local damageConfig = {
    power = 10,
    speed = 10,
    damageSourceKind = "ice",
    physics = "default"
  }
  world.spawnProjectile("armoriceburst", mcontroller.position(), entity.id(), {0, 0}, true, damageConfig)
  
    --self.spawnedThorns = self.spawnedThorns + 1
  end
end
