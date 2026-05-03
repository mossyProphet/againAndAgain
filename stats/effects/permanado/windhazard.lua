function init()
  
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  effect.setParentDirectives("fade=D1CC87=0.1")
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = -0.35}
  })
end

randomvec = 0

function update(dt)
    math.randomseed(os.clock()*100000000000)
  mcontroller.controlModifiers({
      speedModifier = 0.6,
      airJumpModifier = 0.75
    })
  randomvecx = math.random(0, 10000)
  randomvecy = math.random(0, 10000)
  if randomvecx >= 9500 then
    mcontroller.setXVelocity(mcontroller.xVelocity()*randomvecx/3000)
    mcontroller.setYVelocity(mcontroller.yVelocity()*randomvecy/3000)
  end
  if randomvecx >= 7500 then
    mcontroller.setXVelocity(mcontroller.xVelocity()*randomvecx/7000)
    mcontroller.setYVelocity(mcontroller.yVelocity()*randomvecy/7000)
  end
end

function uninit()

end
