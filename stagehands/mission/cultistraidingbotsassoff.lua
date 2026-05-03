require "/scripts/util.lua"
require "/scripts/rect.lua"

spawnWaveOldTu=spawnWave

function spawnWave(spawnPoint,wave)
	local players = world.players()

	local enemies=spawnWaveOldTu(spawnPoint,wave)
	if self.wavesSpawnedTougherMobs==nil then
	   self.wavesSpawnedTougherMobs=0
	end	   
	self.wavesSpawnedTougherMobs=self.wavesSpawnedTougherMobs+1
	if self.tougherMobsSpawnedBoss and self.wavesSpawnedTougherMobs%2==0 and #players<2 then
		return enemies
	end
	
	local spawnMounted=false
	local spawnStagehand = world.loadUniqueEntity(spawnPoint)
	if(spawnPoint=="campspawn") then
		altSpawnStagehand = world.loadUniqueEntity("midfieldspawn")
		if altSpawnStagehand~=nil then
			spawnStagehand=altSpawnStagehand
		end
	end
	
	local position
	local spawnExtraPos=nil
	--sb.logInfo("spawnStagehand "..tostring(spawnStagehand))
	if(spawnStagehand) then
	
		position = world.entityPosition(spawnStagehand)
		spawnExtraPos=position
		
	end
	for _,spawn in pairs(wave) do
		if spawn.entityType=="ballista" then
			spawnMounted=true
		end
		if spawn.entityType=="dragonboss" then
			sb.logInfo("Boss spawned,slowing knight spawn rate.")
			self.tougherMobsSpawnedBoss=true
		end
	end
	
	
	if spawnExtraPos then
       --local position = world.entityPosition(spawnStagehand)
	   spawnExtraParams= { moveLeft = true } 
	   if self.extraSpawns==nil then
	   self.extraSpawns=0
		end	   
		self.extraSpawns=self.extraSpawns+1
		sb.logInfo("Spawn point "..spawnPoint)
	  if(self.extraSpawns%15==11 and (not self.tougherMobsSpawnedBoss)) then
		self.isDueForAssassinSpawn=true
	  end
	  
	  if spawnMounted then 
	  		entityId = world.spawnMonster("tentacleghost", spawnExtraPos, { aggressive = true, level = world.threatLevel(),initialStatus = "blackmonsterrelease",{ scriptConfig = spawnExtraParams} })
	          world.callScriptedEntity(entityId, "status.addEphemeralEffect", "beamin")
	  elseif self.isDueForAssassinSpawn then
		spawnExtraParams["isTougherAssassin"]=true
		sb.logInfo("Summon assassin")
		entityId = world.spawnNpc(position, "human", "khornate", world.threatLevel(), nil, { scriptConfig = spawnExtraParams})
		

		world.callScriptedEntity(entityId, "status.addEphemeralEffect", "beamin")
		self.isDueForAssassinSpawn=false

	  elseif(self.extraSpawns%3==0 ) then
		local shadeInvaderType="buster"
		if(self.extraSpawns%9==3) then
			shadeInvaderType="cultistmage"
		end
		if(self.extraSpawns%9==6) then
			shadeInvaderType="foundrybuster"
		end
	    entityId = world.spawnNpc(spawnExtraPos, "human", shadeInvaderType, world.threatLevel(), nil, { scriptConfig = spawnExtraParams})
		

		world.callScriptedEntity(entityId, "status.addEphemeralEffect", "beamin")
	  else
		entityId = world.spawnMonster("tentaclespawner", spawnExtraPos, { aggressive = true, level = world.threatLevel(),initialStatus = "blackmonsterrelease",{ scriptConfig = spawnExtraParams} })
		entityId = world.spawnMonster("tentaclebomb", spawnExtraPos, { aggressive = true, level = world.threatLevel(),initialStatus = "blackmonsterrelease",{ scriptConfig = spawnExtraParams} })
		entityId = world.spawnMonster("tentaclebomb", spawnExtraPos, { aggressive = true, level = world.threatLevel(),initialStatus = "blackmonsterrelease",{ scriptConfig = spawnExtraParams} })
		
	  end
		
		
		
	  table.insert(enemies, entityId)
      table.insert(self.enemies, entityId)

	  if(#players>=3) then
		for i=3,math.min(#players,4) do
	  	   spawnArcherParams= { moveLeft = true } 
		    local spawnPositionRange = config.getParameter("spawnPositionRange", 5)
			positionArcher = vec2.add(position, {math.random(spawnPositionRange[1], spawnPositionRange[2]), 0})
			entityId = world.spawnNpc(positionArcher, "human", "cultistarcher", world.threatLevel(), nil, { scriptConfig =  spawnArcherParams})
		end
	  end
	  
	  
  end
  return enemies
end
