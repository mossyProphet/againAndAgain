require "/scripts/companions/petspawner.lua"
require "/scripts/companions/recruitspawner.lua"
require "/scripts/achievements.lua"
require "/scripts/companions/player.lua"

-- Store the original functions safely before overriding
local cvc_baseCompanionEffects = getPetPersistentEffects or function() return {} end
local cvc_init = init or function() end
local cvc_update = update or function() end
local cvc_deact = deactivatePod or function() end

-- Function to get pet persistent effects safely
function getPetPersistentEffects()
  local baseEffects = cvc_baseCompanionEffects() -- Ensure no infinite recursion
  local effectstu = status.getPersistentEffects("armor") or {} -- Ensure it returns a table
  return effectstu
end

-- Initialization function
function init()
  if cvc_init then cvc_init() end -- Prevent nil function call
  petCount = 0
  storage.activePods = storage.activePods or {} -- Ensure storage is initialized
end

-- Update function to manage pet limits
function update(dt)
  if cvc_update then cvc_update(dt) end -- Ensure original update function runs
  
  local cvclimit = (status.stat("minionStatsBonus") or 0) + (status.resource("minionSlotsCount") or 0) -- Prevent nil math errors

  -- Ensure pet count does not exceed limit
  if petCount > cvclimit then
    deactivatePod(petArray[1]) -- Deactivate the first pet
    for i = 1, petCount - 1 do
      petArray[i] = petArray[i + 1]
    end
    petArray[petCount] = nil
    petCount = math.max(0, petCount - 1) -- Prevent negative pet count
  end

  -- Ensure minion slots count is at least 1
  if cvclimit < 1 then 
    status.setResource("minionSlotsCount", 1)
  end
end

-- Pet management array
petArray = {}

-- Function to activate a pet pod
function activatePod(podUuid)
  local cvclimit = (status.stat("minionStatsBonus") or 0) + (status.resource("minionSlotsCount") or 0)
  
  local pod = petSpawner.pods and petSpawner.pods[podUuid]
  if not pod then
    sb.logInfo("Cannot activate invalid pod %s", podUuid)
    return
  end
  
  if petCount < cvclimit then
    petCount = petCount + 1
    petArray[petCount] = podUuid
  end
  
  -- Ensure activePods storage is initialized
  storage.activePods = storage.activePods or {}
  storage.activePods[podUuid] = true
  petSpawner:markDirty()
end

-- Function to deactivate a pet pod
function deactivatePod(podUuid)
  if cvc_deact then cvc_deact(podUuid) end -- Prevent nil function call
  petCount = math.max(0, petCount - 1) -- Ensure pet count does not go negative
end