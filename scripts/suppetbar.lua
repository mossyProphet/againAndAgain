require "/scripts/vec2.lua"
require "/scripts/util.lua"

function update()
  localAnimator.clearDrawables()
  local drawable = {
            image = "/interface/party/healthbar.png?crop=0;0;"..math.ceil(animationConfig.animationParameter("suphealth") * 26)..";4",
            centered = false,
            position = vec2.add(world.entityPosition(entity.id()), {-1.6, 2.7}),
            fullbright = true
          }
  local drawable2 = {
            image = "/interface/suppetbar.png",
            centered = false,
            position = vec2.add(world.entityPosition(entity.id()), {-1.6, 2.7}),
            fullbright = true
          }
  if animationConfig.animationParameter("suphealth") ~= 1 then
    localAnimator.addDrawable(drawable, "player-1")
    localAnimator.addDrawable(drawable2, "player-2")
  end
end
