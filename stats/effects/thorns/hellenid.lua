require "/scripts/status.lua"
require "/scripts/util.lua"
require "/scripts/messageutil.lua"

function init()
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
end

function update(dt)
  --checkone = status.resource("setBonusHead") == 1
  checktwo = status.resource("setBonusChest") == 2
  checkthree = status.resource("setBonusLegs") == 2
  check = checktwo and checkthree
  --sb.logInfo("Head is %s", status.resource("setBonusHead"))
  --check = 
  --promises:update()
  if check then
  
    self.myDamageListener:update()
  
  end
  predcur = status.resource("specialBar")
  predrel = 1 + predcur/400
  --sb.logInfo("current charge: %s",predcur)
  --sb.logInfo("should be: %s",status.resource("specialBar"))
  --sb.logInfo("IsViable = : %s",isViableTu)
 
  mcontroller.controlModifiers({speedModifier = 1.15 * (predrel+1)})
    while (predcur >= 400) and check do
        spikesTrigger()
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


function spikesTrigger()
	
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
    speed = 50,
    --damageSourceKind = "ice",
    physics = "default"
  }
  world.spawnProjectile("armoriceburst", mcontroller.position(), entity.id(), {0, 0}, true, damageConfig)
  world.spawnProjectile("armorice", position, entity.id(), needleVector, true, damageConfig)
  
    --self.spawnedThorns = self.spawnedThorns + 1
  end
end