require "/scripts/companions/petspawner.lua"
require "/scripts/companions/recruitspawner.lua"
require "/scripts/achievements.lua"

local cvc_baseCompanionEffects = getPetPersistentEffects
local cvc_init = init
local cvc_update = update
local cvc_deact = deactivatePod

function getPetPersistentEffects()
  cvc_baseCompanionEffects()
  local effectstu = status.getPersistentEffects("armor")
  return effectstu
end

function init()
  cvc_init()
  petCount = 0
end

function update(dt)
  cvc_update(dt)
  local cvclimit = status.stat("minionStatsBonus") + status.resource("minionSlotsCount")
  if petCount > cvclimit then
     i = 1
     deactivatePod(petArray[i])
     while i < petCount do
        petArray[i] = petArray[i + 1]
        i = i + 1
     end
     petArray[i] = nil
  end
  -- end
  if cvclimit < 1 then 
    status.setResource("minionSlotsCount", 1)
  end
end



-- Activate means 'regard this pod as active' but do not release yet.
-- When the player throws the filledcapturepod, activatePod is called.
-- When the filledcapturepod hits something, it calls spawnFromPod to release
-- the monster.
petArray = {}
function activatePod(podUuid)
  --local uplimit = config.getParameter("activePodLimit")
  local cvclimit = status.stat("minionStatsBonus") + status.resource("minionSlotsCount")

  
  
  local pod = petSpawner.pods[podUuid]
  if not pod then
    sb.logInfo("Cannot activate invalid pod %s", podUuid)
    return
  end
  if petCount < cvclimit then
    petCount = petCount + 1
    petArray[petCount] = podUuid
  end

     --deactivatePod(petArray[1])
     --i = 1
     --while i < petCount do
     --   petArray[i] = petArray[i + 1]
     --   i = i + 1
     --end
     --petArray[i] = nil
     --end
  -- If we have too many pets out, call some back
  --local overflow = math.max(util.tableSize(storage.activePods) + 1 - cvclimit, 0)
  --for uuid,_ in pairs(storage.activePods) do
  --  deactivatePod(uuid)
  --  overflow = overflow - 1
  --  if overflow <= 0 then
  --    break
  --  end
  --end

  --storage.activePods[podUuid] = true
  --petSpawner:markDirty()
  storage.activePods[podUuid] = true
  petSpawner:markDirty()
end

-- Deactivate calls the pet back.
function deactivatePod(podUuid)
  cvc_deact(podUuid)
  petCount = petCount - 1
end

