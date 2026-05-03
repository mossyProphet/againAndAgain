require "/scripts/util.lua"
require "/scripts/vec2.lua"

function init()
  self.types = config.getParameter("npctypes")
end

function onInteraction()
    local spawn = util.randomFromList(self.types)
    local species = util.randomFromList(spawn.species)
    local npcId = world.spawnNpc(object.toAbsolutePosition{3,3}, species, spawn.type, world.threatLevel())
    world.callScriptedEntity(npcId, "status.addEphemeralEffect", "beamin")
    if spawn.displayNametag then
      world.callScriptedEntity(npcId, "npc.setDisplayNametag", true)
    end
end
