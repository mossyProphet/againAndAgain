require "/scripts/companions/petspawner.lua"
require "/scripts/companions/recruitspawner.lua"
require "/scripts/achievements.lua"

function getPetPersistentEffects()
  local effects = status.getPersistentEffects("armor") or {}
  sb.logInfo("DEBUG: getPetPersistentEffects() returns: %s", sb.printJson(effects, true))
  if onOwnShip() and recruitSpawner and recruitSpawner.getShipPersistentEffects then
    util.appendLists(effects, recruitSpawner:getShipPersistentEffects())
  end
  return sb.printJson(effects, true)
end

function init()
  petSpawner:init()
  recruitSpawner:init()
  petCount = 0
  storage.pods = storage.pods or {}
  storage.activePods = storage.activePods or {}

  message.setHandler("pets.podPets", localHandler(podPets))
  message.setHandler("pets.setPodPets", localHandler(setPodPets))
  message.setHandler("pets.isPodActive", localHandler(isPodActive))
  message.setHandler("pets.activatePod", localHandler(activatePod))
  message.setHandler("pets.deactivatePod", localHandler(deactivatePod))
  message.setHandler("pets.togglePod", localHandler(togglePod))
  message.setHandler("pets.spawnFromPod", localHandler(spawnFromPod))
  message.setHandler("pets.podsLimit", localHandler(podsLimit))

  message.setHandler("recruits.offerRecruit", simpleHandler(offerRecruit))
  message.setHandler("recruits.offerMercenary", simpleHandler(offerMercenary))
  message.setHandler("recruits.requestFollow", simpleHandler(requestFollow))
  message.setHandler("recruits.requestUnfollow", simpleHandler(requestUnfollow))
  message.setHandler("recruits.offerUniformUpdate", simpleHandler(offerUniformUpdate))
  message.setHandler("recruits.triggerFieldBenefits", simpleHandler(triggerFieldBenefits))
  message.setHandler("recruits.triggerCombatBenefits", simpleHandler(triggerCombatBenefits))

  recruitSpawner.ownerUuid = entity.uniqueId()
  recruitSpawner.activeCrewLimit = config.getParameter("activeCrewLimit", 0)
  recruitSpawner.crewLimit = function() return (player.shipUpgrades().crewSize or 0) end

  for uuid, podStore in pairs(storage.pods) do
    petSpawner.pods[uuid] = Pod.load(podStore)
  end

  recruitSpawner:load({
      followers = playerCompanions.getCompanions("followers") or {},
      shipCrew = playerCompanions.getCompanions("shipCrew") or {}
    }, storage.recruits or {})

  self.spawnedCompanions = false
end

function update(dt)
  local minionBonus = status.stat("minionStatsBonus") or 0
  local minionSlots = status.resource("minionSlotsCount") or 0
  local limit = minionBonus + minionSlots

  petCount = math.max(0, petCount)

  -- Ensure minionSlotsCount exists before modifying it
  if not status.resource("minionSlotsCount") then
    status.setResource("minionSlotsCount", 1)
  end

  -- Ensure pet count does not exceed limit
  if petCount > limit then
    deactivatePod(petArray[1])
    for i = 1, petCount - 1 do
      petArray[i] = petArray[i + 1]
    end
    petArray[petCount] = nil
    petCount = petCount - 1
  end

  -- Spawn companions if they haven't been spawned yet
  if not self.spawnedCompanions then
    self.spawnedCompanions = spawnCompanions()
  end

  promises:update()

  for uuid in pairs(storage.activePods) do
    local pod = petSpawner.pods[uuid]
    if pod then
      pod:update(dt)
      local podItem = player.getItemWithParameter("podUuid", uuid)
      if pod:dead() or not podItem then
        deactivatePod(uuid)
      else
        petSpawner:setPodCollar(uuid, podItem.parameters.currentCollar)
      end
    end
  end

  recruitSpawner:update(dt)
  if onOwnShip() then
    recruitSpawner:shipUpdate(dt)
    for uuid, recruit in pairs(recruitSpawner.shipCrew) do
      if not recruitSpawner.beenOnShip[uuid] then
        runFirstShipExperience(uuid, recruit)
      end
    end
  end

  if petSpawner:isDirty() then
    local activePets = {}
    for uuid in pairs(storage.activePods) do
      for _, pet in pairs(petSpawner.pods[uuid].pets) do
        if pet:statusReady() and not pet:dead() then
          activePets[#activePets+1] = pet:toJson()
        end
      end
    end
	sb.logInfo("DEBUG: activePets before saving: %s", sb.printJson(activePets, true))
    playerCompanions.setCompanions("pets", sb.printJson(activePets, true))
    petSpawner:clearDirty()
  end

  if recruitSpawner:isDirty() then
    updateShipCrewEffects()
    updateShipUpgrades()
    logCrewSize()
    for category, companions in pairs(recruitSpawner:storeCrew()) do
      playerCompanions.setCompanions(category, companions)
    end
    recruitSpawner:clearDirty()
  end
end


function activatePod(podUuid)
  local limit = (status.stat("minionStatsBonus") or 0) + (status.resource("minionSlotsCount") or 0)
  local pod = petSpawner.pods[podUuid]
  if not pod then
    sb.logInfo("Cannot activate invalid pod %s", podUuid)
    return
  end
  if petCount < limit then
    petCount = petCount + 1
    petArray[petCount] = podUuid
  end
  storage.activePods[podUuid] = true
  petSpawner:markDirty()
end

function deactivatePod(podUuid)
  local pod = petSpawner.pods[podUuid]
  if pod then
    pod:recall()
    storage.activePods[podUuid] = nil
    petSpawner:markDirty()
    petCount = math.max(0, petCount - 1)
  else
    sb.logInfo("Cannot deactivate invalid pod %s", podUuid)
  end
end
