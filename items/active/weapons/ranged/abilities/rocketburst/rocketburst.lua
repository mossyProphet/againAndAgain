require "/scripts/util.lua"
require "/items/active/weapons/weapon.lua"

RocketBurst = GunFire:new()

function RocketBurst:new(abilityConfig)
  local primary = config.getParameter("primaryAbility")
  
  return GunFire.new(self, sb.jsonMerge(primary, abilityConfig))
end

function RocketBurst:init()
  self.cooldownTimer = self.fireTime
  pushbackKnocking = self.pushbackKnocking
end

function RocketBurst:update(dt, fireMode, shiftHeld)
  direction = mcontroller.facingDirection() == 1 and self.weapon.aimAngle + math.pi or -self.weapon.aimAngle
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if self.fireMode == "alt"
    and not self.weapon.currentAbility
    and self.cooldownTimer == 0
    and not status.resourceLocked("energy")
    and not world.lineTileCollision(mcontroller.position(), self:firePosition()) then
    
    self:setState(self.burst)
  end
end

function RocketBurst:fireProjectile(...)
  multiplierOfSpeed = status.stat("powerModifier")
  local projectileId = GunFire.fireProjectile(self, ...)
  world.callScriptedEntity(projectileId, "setApproach", self:aimVector(0))
end

function RocketBurst:muzzleFlash()
  animator.burstParticleEmitter("altMuzzleFlash", true)
  mcontroller.controlApproachVelocity(vec2.withAngle(direction, 0.075*pushbackKnocking), pushbackKnocking)
 
  animator.playSound("altFire")
end
