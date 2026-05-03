function init()
  local bounds = mcontroller.boundBox()
  script.setUpdateDelta(10)
  local enableParticles = config.getParameter("particles", true)
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", enableParticles)
  
end

function update(dt)
  
  local enableParticles = config.getParameter("particles", true)
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", enableParticles)
end

function uninit()
  
end
