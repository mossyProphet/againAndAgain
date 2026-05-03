
function init()
  	applied = true
end

function update(dt)
    if applied then
        podsCur = status.stat("minionStatsBonus")
	    effect.addStatModifierGroup({{stat = "minionStatsBonus", amount = podsCur}})
        applied = false
    end
end

function uninit()
    applied = true
end