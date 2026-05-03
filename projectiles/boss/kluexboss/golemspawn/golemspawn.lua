require "/scripts/util.lua"

function init()
  
    world.spawnMonster("kluexsentry", mcontroller.position(), { level = config.getParameter("level", 1.0), aggressive = true } )
  
     projectile.die()
  
end

