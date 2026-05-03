-- spawns the stagehand that manages biome spreading
-- it does nothing else
local stagehandID = nil
function init()
    script.setUpdateDelta(1)
end
function update(dt)
    if not stagehandID then
        local stagehands = world.entityQuery(world.entityPosition(player.id()), 1, {includedTypes={"stagehand"}, boundMode="position"})
        for k,v in next, stagehands do
            if world.stagehandType(v) == "growableblocksmanager" then
                stagehandID = v
            end
        end
        if not stagehandID then
            world.spawnStagehand(world.entityPosition(player.id()), "growableblocksmanager", {spawner=player.id()})
        end
    elseif not world.entityExists(stagehandID) then
        stagehandID = nil
    elseif world.magnitude(world.entityPosition(stagehandID), world.entityPosition(player.id())) > 300 then
        stagehandID = nil
    end
end
