require "/scripts/util.lua"

function init()
  quan = math.random(1, 7)
end

function update(dt)
      if quan >= 3 then
        world.spawnMonster("bonebird", mcontroller.position(), { level = quan, aggressive = true } )
      end
      projectile.die()
    
end