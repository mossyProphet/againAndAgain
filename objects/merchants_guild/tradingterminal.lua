require "/scripts/util.lua"
require "/scripts/vec2.lua"

function init()
  self.types = config.getParameter("npctypes")
end

function onInteraction()
    object.say("Reroll of stock costs 500 pixels, advised to make a decision faster")
    local spawn = util.randomFromList(self.types)
    local species = util.randomFromList(spawn.species)
    local npcId = world.spawnNpc(object.position(), species, spawn.type, 1)
    world.callScriptedEntity(npcId, "status.addEphemeralEffect", "beamin")
    if spawn.displayNametag then
      world.callScriptedEntity(npcId, "npc.setDisplayNametag", true)
    end
end
