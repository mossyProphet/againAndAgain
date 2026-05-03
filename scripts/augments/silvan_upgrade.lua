require "/scripts/augments/item.lua"

function apply(input)
  local output = Item.new(input)
  if output:instanceValue("sb_unupgradeable") then return output:descriptor(), 0 end
  local newLevel = config.getParameter("newLevel",0)
  local level = output:instanceValue("level", 1)
  --local newPrimaryProp = output:instanceValue("primaryAbility")
  --newPrimaryProp.energyUsage = 100
  --output:setInstanceValue("primaryAbility", newPrimaryProp)

  local upgradeable = false

  local tags = output:instanceValue("itemTags",{})
  local upgradeTags = config.getParameter("upgradeTags",{"weapon","shield"})
  for i = 1, #tags do
    for j = 1, #upgradeTags do
      if tags[i] == upgradeTags[j] then
        upgradeable = true
        break
      end
    end
  end

--upgradeable = output:instanceValue("primaryAbility",upgradeable)

  if upgradeable and level < newLevel then
    output:setInstanceValue("level", newLevel)
    return output:descriptor(), 1
  end

  output:setInstanceValue("primaryAbility", newLevel)
end