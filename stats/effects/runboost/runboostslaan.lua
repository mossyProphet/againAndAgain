require "/scripts/status.lua"
require "/scripts/util.lua"
require "/scripts/messageutil.lua"
--require "/scripts/player/armorSetCheck.lua"

--function isViableTri()
--	promises:add(world.sendEntityMessage(entity.id(), "isSetAdequate"),
--    function(result)
--	    isViableTu = result.isSetAdequate()
--        --isViableTri()
--    end
--    )
--    --isViableTri()
--    --isViableTu = world.sendEntityMessage(player.id(), "isSetAdequate")
--end


function init()
 
  
  --and status.resource("SetBonusChest") == 1 and status.resource("SetBonusLegs") == 1

  local bounds = mcontroller.boundBox()
  script.setUpdateDelta(10)
  animator.setParticleEmitterActive("sparks", true)
  self.statusEffects = config.getParameter("statusEffects")
  effect.setParentDirectives("fade=CC5555=0.25")
  predcur = 0
  script.setUpdateDelta(5)
  self.triggerDamageThreshold = 1

  self.timeUntilActive = 5
  self.counterGroupId = nil
  self.damageCounter = 0
  self.myDamageListener = damageListener("inflictedDamage", function(notifications)
    for x,notification in pairs(notifications) do
      if notification.healthLost > 0 and notification.sourceEntityId ~= notification.targetEntityId then
        -- Do something: notification.damageDealt haves the damage done by this specific damage instance
        -- The counter could be an stat, specialBar for this example
		self.damageCounter = math.min(100,self.damageCounter + 1)
        status.modifyResource("specialBar", notification.damageDealt)
        --sb.logInfo("self.damageCounter: %s",self.damageCounter)
        --sb.logInfo("notification.damageDealt: %s",notification.damageDealt)
		--if self.counterGroupId == nil then
		--	self.counterGroupId = effect.addStatModifierGroup({{stat = "specialBar", amount = self.damageCounter}})
		--else
		--	effect.setStatModifierGroup(self.counterGroupId,{{stat = "specialBar", amount = self.damageCounter}})
		--end
      end
    end
  end)
  --check = status.getPersistentEffects("predhead") and status.getPersistentEffects("predchest") and status.getPersistentEffects("predlegs")
  --animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  --animator.setParticleEmitterActive("flames", enableParticles)
  --isViableTri()
end

function update(dt)
  checkone = status.resource("setBonusHead") == 1
  checktwo = status.resource("setBonusChest") == 1
  checkthree = status.resource("setBonusLegs") == 1
  check = checkone and checktwo and checkthree
  --sb.logInfo("Head is %s", status.resource("setBonusHead"))
  --check = 
  --promises:update()
  if check then
  
    self.myDamageListener:update()
  
  end
  predcur = status.resource("specialBar")
  predrel = 1 + predcur/500
  --sb.logInfo("current charge: %s",predcur)
  --sb.logInfo("should be: %s",status.resource("specialBar"))
  --sb.logInfo("IsViable = : %s",isViableTu)
 
    mcontroller.controlModifiers({speedModifier = 1.5 * predrel})
    while (predcur >= 500) and check do
        status.addEphemeralEffects(self.statusEffects)
        status.setResource("specialBar", 0)
        predcur = 0
    end    
   

    
    

   --isViableTri()
 end

 

function uninit()
  status.setResource("specialBar", 0)
  predcur = 0
  check = false
end
