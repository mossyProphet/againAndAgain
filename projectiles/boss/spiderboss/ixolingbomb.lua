require "/scripts/util.lua"

function init()
  self.timer = math.random(1, 5)
  self.quan = math.random(1, 3)
end

function update(dt)
  local bossHealth = world.entityHealth(projectile.sourceEntity())
  if bossHealth and bossHealth[1] > 0 and bossHealth[1] < bossHealth[2] then
    self.timer = math.max(0, self.timer - dt)
    projectile.setTimeToLive(1.0)
    if self.timer == 0 then
      i = 0
      while i < quan do
        world.spawnMonster("ixoling", mcontroller.position(), { level = config.getParameter("level", 1.0), aggressive = true } )
        i = i + 1
      projectile.die()
    end
  else
    projectile.die()
  end
end

