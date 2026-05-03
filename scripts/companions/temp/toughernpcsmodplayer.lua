
function getPetPersistentEffects()
  local effects = status.getPersistentEffects("armor")
  if onOwnShip() then
    util.appendLists(effects, recruitSpawner:getShipPersistentEffects())
  end
  return effects
end


-- Activate means 'regard this pod as active' but do not release yet.
-- When the player throws the filledcapturepod, activatePod is called.
-- When the filledcapturepod hits something, it calls spawnFromPod to release
-- the monster.
function activatePod(podUuid)
  --limit = config.getParameter("activePodLimit")
  limit = status.stat("minionStatsBonus")
  
  if limit < 1 then return end
  local pod = petSpawner.pods[podUuid]
  if not pod then
    sb.logInfo("Cannot activate invalid pod %s", podUuid)
    return
  end


  storage.activePods[podUuid] = true
  petSpawner:markDirty()
  --sb.logInfo("11111 %s", limit)
  --sb.logInfo("22222 %s", util.tableSize(storage.activePods))
  --sb.logInfo("33333 %s", overflow)
end

-- Deactivate calls the pet back.
function deactivatePod(podUuid)
  local pod = petSpawner.pods[podUuid]
  if not pod then
    sb.logInfo("Cannot deactivate invalid pod %s", podUuid)
    return
  end

  pod:recall()
  storage.activePods[podUuid] = nil
  petSpawner:markDirty()
end
