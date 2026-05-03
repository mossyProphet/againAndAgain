function init()
  local bounds = mcontroller.boundBox()
  script.setUpdateDelta(10)
  local enableParticles = config.getParameter("particles", true)
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", enableParticles)
  
end

function update(dt)
  mcontroller.controlModifiers({
      speedModifier = 2.5
      })
  if not mcontroller.onGround() then
      mcontroller.controlModifiers({
        speedModifier = 10.0
        })
      
  end
  local enableParticles = config.getParameter("particles", true)
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", enableParticles)
end

function uninit()
  
end
