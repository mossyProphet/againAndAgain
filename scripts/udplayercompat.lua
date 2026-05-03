require "/scripts/crewcustomizationutil.lua"
require "/scripts/util.lua"
require "/scripts/achievements.lua"
require "/scripts/companions/cvc_player.lua"

--Because these are "local", i need to rewrite them
--Chaka's reply: couldn't you just not limit the mobs in that regard instead?
--local petPersistentEffectsCC = {
--    powerMultiplier = true,
--    protection = true,
--    maxHealth = true,
--	maxEnergy = true
--  }
--
--local function filterPersistentEffectsCC(effects)
--  return util.filter(effects, function (effect)
--      return type(effect) == "table" and petPersistentEffectsCC[effect.stat]
--    end)
--end


local newGetEffects = function()
  local effects = status.getPersistentEffects("armor")
  if onOwnShip() then
    util.appendLists(effects, recruitSpawner:getShipPersistentEffects())
  end
  return effects
end

crewcplayerinit = init
function init()
	crewcplayerinit()
	message.setHandler("player.getFollowers", simpleHandler(getFollowers))
	message.setHandler("player.getFollowerUniform", simpleHandler(getUniform))
	message.setHandler("player.getNewFollowerUniform", simpleHandler(getNewlyUniform))
	message.setHandler("player.getFollowerIdentity", simpleHandler(getFIdentity))
	message.setHandler("player.setFollowersUniform", simpleHandler(setUniformMessage))
	message.setHandler("player.updateExternalCCUniform", simpleHandler(updateExternalCCUniform))
	
	status.setStatusProperty("CCustomizationGUI",0) --Protect against premature closings
	getPetPersistentEffects = newGetEffects --Late hooking to see if FU behaves
end

--Stop the automatic uniform assignment so that the external uniform update isn't overwritten
function updateExternalCCUniform(uuid,uniform)
	recruitSpawner.uniform[uuid] = uniform
end

function getPlayerUniform()
  local items = {}
  local slots = {}
  local uniformSlots = config.getParameter("uniformSlots")
  for slotName,playerSlots in pairs(uniformSlots) do
    table.insert(slots, slotName)
    for _,playerSlot in pairs(playerSlots) do
		--The player doesn't have the same slots as npcs, so for items we take the currently held items
		if playerSlot == "primary"  then
			items[slotName] = player.primaryHandItem()
			break
		elseif playerSlot == "alt" then
			items[slotName] = player.altHandItem()
			break
		elseif playerSlot == "sheathedprimary" then
			items[slotName] = player.primaryHandItem()
			break
		elseif playerSlot == "sheathedalt" then
			items[slotName] = player.altHandItem()
			break
		elseif player.equippedItem(playerSlot) then
			items[slotName] = player.equippedItem(playerSlot)
			break
		end
    end
  end
  return {
      slots = slots,
      items = items
    }
end


function setUniform(uuid, items)
  recruitSpawner.uniform[uuid] = items
end

function updateUniform(uniform, filters)
    for uuid, recruit in pairs(recruitSpawner.followers) do
		setUniform(uuid, filterUniform(deepcopy(uniform),filters,uuid))
	end
end

function resetUniform()
    for uuid, recruit in pairs(recruitSpawner.followers) do
		setUniform(uuid, nil)
	end
end

--The idea is for this function to keep the desired outfit and only changing the ones in the filter
function filterUniform(newUniform, filters,uuid)
	if not filters then return newUniform end
	local slots = {"primary", "alt", "sheathedprimary", "sheathedalt", "legs", "chest", "head", "back", "headCosmetic", "legsCosmetic", "backCosmetic", "chestCosmetic"}
	local items = deepcopy((recruitSpawner.uniform[uuid] or {}).items) or {}
    for _,slotName in pairs(slots) do
		if filters[slotName] then
			items[slotName] = newUniform.items[slotName]
		end
	end
	return { slots = slots, items = items }
end

origccustom_offerUniformUpdate = offerUniformUpdate
function offerUniformUpdate(recruitUuid, entityId)
  local hasCCinterface = #player.itemsWithTag("ccustominterface") > 0
  if not hasCCinterface then
	player.giveItem({name = "ccustominterface",count = 1})
  end
  
  player.interact("ScriptPane",root.assetJson("/interface/CCustomization/CCustomization.config"))
  
  --This calls the default function, I would advise against it
  --origccustom_offerUniformUpdate(recruitUuid,entityId)
end


function getFollowers()
    local followers = playerCompanions.getCompanions("followers")
    local crew = playerCompanions.getCompanions("shipCrew")
    util.appendLists(crew,followers)
    return crew
end

function getUniform(uuid)
    return deepcopy(recruitSpawner.uniform[uuid])
end

function getNewlyUniform(uuid)
	local uniform = deepcopy(recruitSpawner:getJustRecruitedGear(uuid))
    return uniform
end

function getFIdentity(uuid)
    return deepcopy((recruitSpawner.uniform[uuid] or {})["identity"])
end

function setUniformMessage(uuid, uniform)
	setUniform(uuid, deepcopy(uniform))
	recruitSpawner:update(1)
end

--RECRUIT SPAWNER
require "/scripts/companions/recruitspawner_ccustomization.lua"

--PET
require "/scripts/companions/petspawner.lua"

--RECRUIT
require "/scripts/companions/recruitable_ccustomization.lua"
