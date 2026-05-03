function init()
  
  --effect.setParentDirectives("fade=FFFFCC;0.03?border=2;FFFFCC20;00000000")
  --status.setResource("setBonusHead", 1)	
end

function update(dt)
   status.setResource("setBonusHead", 1)
end

function uninit()
  
   status.setResource("setBonusHead", 0)
end
