function init()
  message.setHandler("kill", projectile.die)
  mcontroller.applyParameters({collisionEnabled=false})
end
