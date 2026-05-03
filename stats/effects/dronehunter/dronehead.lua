require "/scripts/status.lua"
require "/scripts/util.lua"
require "/scripts/messageutil.lua"

function init()
  --local bounds = mcontroller.boundBox()
  --script.setUpdateDelta(10)
  --animator.setParticleEmitterActive("sparks", true)
  --self.statusEffects = config.getParameter("statusEffects")
  --effect.setParentDirectives("fade=CC5555=0.25")
  --predcur = 0
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
		--self.damageCounter = math.min(100,self.damageCounter + 1)
        --status.modifyResource("specialBar", notification.damageDealt)
        --sb.logInfo("self.damageCounter: %s",self.damageCounter)
        --sb.logInfo("notification.damageDealt: %s",notification.damageDealt)
		--if self.counterGroupId == nil then
		--	self.counterGroupId = effect.addStatModifierGroup({{stat = "specialBar", amount = self.damageCounter}})
		--else
		--	effect.setStatModifierGroup(self.counterGroupId,{{stat = "specialBar", amount = self.damageCounter}})
		--end
        rand = sb.nrand(10000, 0) 
        if rand >= 9999.9 then
            spikesTrigger()
        end
      end
    end
  end)
end

function update(dt)
  --checkone = status.resource("setBonusHead") == 1
  checktwo = status.resource("setBonusChest") == 3
  checkthree = status.resource("setBonusLegs") == 3
  check = checktwo and checkthree
  --sb.logInfo("Head is %s", status.resource("setBonusHead"))
  --check = 
  --promises:update()
  if check then
  
    self.myDamageListener:update()
  
  end
  --predcur = status.resource("specialBar")
  --predrel = 1 + predcur/400
  --sb.logInfo("current charge: %s",predcur)
  --sb.logInfo("should be: %s",status.resource("specialBar"))
  --sb.logInfo("IsViable = : %s",isViableTu)
 
  mcontroller.controlModifiers({speedModifier = 1.15})
   -- while (predcur >= 400) and check do
   --     spikesTrigger()
   --     status.setResource("specialBar", 0)
   --     predcur = 0
   -- end    
   

    
    

   --isViableTri()
 end

 

function uninit()
  --status.setResource("specialBar", 0)
  --predcur = 0
  check = false
end


function spikesTrigger()
  
  
     world.spawnMonster("combatronally", mcontroller.position())
end