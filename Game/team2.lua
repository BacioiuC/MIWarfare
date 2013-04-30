teamTwo = {}
stateList = { "idle", "searching", "moving", "combat", "acting", "runnin", "bored" }
function teamTwo:init( )
	self.teamTwoTable = {}
	self.teamTwo = {}
	self.teamTwo = {}
	self.deadCounter = 0

	teamTwo.gfx = {}
	teamTwo.gfx[1], teamTwo.TexName = image:newTexture("Game/media/soldier_2.png",1,"Tank2TexGFX")
	teamTwo.gfx[2], teamTwo.TexName2 = image:newTexture("Game/media/tank2.png",1,"Tank2TexGFX2")
	self.escapedConvicts = {}
	teamTwo.ammo = {}
	teamTwo.ammo[1] = image:newTexture("Game/media/bullet1.png",1,"BulletTex1")

	--[[teamTwo:new(15, 1)
	teamTwo:new(14, 1)
	teamTwo:new(16, 1)
	teamTwo:new(13, 1)--]]
	self.maxEnemies = Game.maxEnemies -- 17 EASY
	for i = 1, self.maxEnemies do
		local randPass = math.random(1,6)
		if randPass == 5 then
			teamTwo:new(math.random(1,grid_x), math.random(1,2), 2)
		else
			teamTwo:new(math.random(1,grid_x), math.random(1,2), 1)
		end
	end

	

end

function teamTwo:dropAll( )
	for i,v in ipairs(self.teamTwoTable) do
		image:updateImage(v.gfx, 2000, 20000)
	end
end

function teamTwo:new(_x, _y, _type)
	-- set to spawn at spawn point
	local __x, __y = _x, _y
	local temp = {
		id = #self.teamTwoTable + 1,
		type = _type,
		civilian = 5, -- if 1 then civilian! All is good
		level = 1,
		name = "Civilian",
		health = 10 + Game.AiLevel * 1.3,
		speed = 0.04 ,
		identified = 1,
		x = __x,
		y = __y,
		act_x = _x,
		act_y = _y,
		goal_x = _x,
		goal_y = _y,
		path = {},
		isMoving = false,
		there = false,
		cur = 1,
		tweenPath = {},
		length = {},
		timer = Game.worldTimer,
		moveTimer = Game.worldTimer,
		stateChangeTimer = Game.worldTimer,
		fireTimer = Game.worldTimer,
		tI = 1,
		moveState = false,
		state = "moving",
		targetID = nil,
		boolTarget = false,
		canRun = false,
		points = math.random(100, 350) + Game.AiLevel*2,
		boreMeter = 0, 
		range = 5,
		fire_rate = math.random(0.7,1.3),
		hp = 100,
		removeTimer = Game.worldTimer,
		isDead = false,
		base_damage = nil,
		inCombat = false,
		speed_mod = 0.5,
		}

		
			if _type == 1 then
				temp.range = 4
				temp.fire_rate = 0.8
				--temp.speed = math.random(0.02, 0.08)
				temp.damage = 0.3
				temp.health = 0.5
				temp.base_damage = temp.damage
			else
				temp.range = 7
				temp.fire_rate = 1.6
				--temp.speed = math.random(0.07, 0.12)
				temp.damage = 0.5
				temp.health = 0.3
				temp.base_damage = temp.damage

			end
		temp.gfx = image:newImage(teamTwo.gfx[_type], temp.x*16, temp.y*16)
		table.insert(self.teamTwoTable, temp)

end

function teamTwo:clearAndDeploy(_id)
	local ent = self.teamTwoTable[_id]
	if ent.y > grid_y - 2 then
		Game.lifes = Game.lifes-1
		ent.hp = 0
		if ent.isDead == false then
			self.deadCounter = self.deadCounter + 1
			ent.isDead = true
		end
		
		
		image:removeProp(ent.gfx)
		ent.x = 2000
		ent.y = -200000
	end
end

function teamTwo:updateDamageBasedOnDistance(_id)
	local ent = self.teamTwoTable[_id]
	--if math.dist(ent.x, ent.y, ent.x, 18)
		ent.damage = ent.base_damage + math.dist(ent.x, ent.y, ent.x, 18)
	--end
end

function teamTwo:_debugSpawnRandom( _x, _y )
	for i = 1, math.random(2,17) do
		teamTwo:new(_x, _y)
	end
end

function teamTwo:draw( )
	for i,v in ipairs(self.teamTwoTable) do

	--	love.graphics.rectangle("line",v.act_x*32,v.act_y*32,32,32)

	end
end

function teamTwo:checkIfNearOpponent(_id)

	local ent = self.teamTwoTable[_id]
	for i,v in ipairs(teamOne:returnTable()) do

		if math.dist(ent.x, ent.y, v.x, v.y) <= ent.range and ent.inCombat == false then

			teamTwo:setGoal(_id, ent.x, ent.y)
			ent.targetID = i
			ent.inCombat = true
			ent.state = "combat"
		end
	end

end

function teamTwo:_debugDraw( )
	for i,v in ipairs(self.teamTwoTable) do
		if v.path ~= nil then
			--print("X: "..v.x.." Act_X: "..v.act_x.." Y: "..v.y.." Act_Y: "..v.act_y.." GOAL_X "..v.goal_x.." GOAL_Y: "..v.goal_y.."",20,20*i-20)
		end
	end
end

function teamTwo:update(_dt)
	for i,v in ipairs(self.teamTwoTable) do
		if v.hp > 1 then
			teamTwo:handleStates(i)
			teamTwo:move(i,_dt)
			--teamTwo:_debugIsNearCCTV(i)

			--teamTwo:_debugESCAPE(i, 0)

			--teamTwo:spawnNewIndividual( )
			--teamTwo:remove( i )
			image:updateImage(v.gfx, v.x*16, v.y*16)
			--print("PosX: "..v.x.." PosY: "..v.y.." v.state: "..v.state.."\n")
			teamTwo:checkIfNearOpponent(i)
			teamTwo:clearAndDeploy(i)
			teamTwo:updateDamageBasedOnDistance(i)
		else
			teamTwo:remove(i)
		end
		
	end
end

function teamTwo:giveDamage(_id, damage)
	local ent = self.teamTwoTable[_id]
	if ent ~= nil then
		ent.removeTimer = Game.worldTimer
		ent.hp = ent.hp - damage
	end
end
function teamTwo:getNum( )
	return #self.teamTwoTable
end

--[[function teamTwo:giveDamage( _id, _ammount )
	local ent = self.teamTwoTable[_id]
	ent.hp = ent.hp - _ammount
end--]]

function teamTwo:remove( _id )
	local ent = self.teamTwoTable[_id]
	image:removeProp(ent.gfx)
	ent.x = 2000
	ent.y = 2000
	if ent.isDead == false then
		self.deadCounter = self.deadCounter + 1
		ent.isDead = true
	end
	if Game.worldTimer > ent.removeTimer + 25 then
		table.remove(self.teamTwoTable,_id)
		for i,v in ipairs(self.teamTwoTable) do
			v.id = i
		end
	end
	--[[local ent = self.teamTwoTable[_id]
	
	if ent.health <= 0 then
		--Game.score = Game.score + ent.points
		table.remove(self.teamTwoTable,_id)
		for i,v in ipairs(self.teamTwoTable) do
			v.id = i
		end
	end--]]
end

function teamTwo:dropALL( )

	self.teamTwoTable = {}
end

function teamTwo:_debugESCAPE(_id, _escapePoint)

end


function teamTwo:howManyAlive( )
	return self.maxEnemies - self.deadCounter
end

----------------------------------------------------
-- teamTwo STATES AND SWITCHING BETWEEN STATES HERE
----------------------------------------------------
function teamTwo:handleStates(_id)
	local v = self.teamTwoTable[_id]

	if Game.worldTimer > v.stateChangeTimer + math.random(3,5) then


		if v.boreMeter > 100 then
			v.state = "bored"
		end
	end

	if Game.worldTimer > v.moveTimer + 1.9 then
		if v.state == "idle" then
			-- EMPTY
		elseif v.state == "moving" then
			--if Game.worldTimer > v.moveTimer + 0.5 then
			--teamTwo:orderMove(_id, _path)
			if v.y < grid_y-1 then
				teamTwo:setGoal( _id , math.random(1,grid_x), math.random(v.y, grid_y-1))
			else
				teamTwo:setGoal( _id , v.x, grid_y)
			end
				v.moveTimer = Game.worldTimer
				--if v.cilian == 1 then
				--	v.boreMeter = v.boreMeter + 1
				--end
				--print("MOVING STATE HERE")
			--end
		elseif v.state == "acting" then
			if v.boolTarget == false then
				--teamTwo:assignTarget(_id)
				v.state = "moving"
				--v.boolTarget = true
			else
				teamTwo:setGoal(_id, v.goal_x, v.goal_y)
				--teamTwo:_debugSteal(_id)
				v.moveTimer = Game.worldTimer
			end
			
		elseif v.state == "combat" then

			for i2, v2 in ipairs(teamOne:returnTable()) do
				if math.dist(v.x, v.y, v2.x, v2.y) <= v.range then
					if Game.worldTimer > v.fireTimer + v.fire_rate then
						bullet:newBullet(v.x, v.y, teamOne:returnPosX(v.targetID), teamOne:returnPosY(v.targetID), 1,2)
						--teamOne:giveDamage(v.targetID, math.random(5,20))
						--if v.type == 1 then
							teamOne:giveDamage(v.targetID, v.damage)
						--else
							--teamOne:giveDamage(v.targetID, math.random(5,30))
						--end
						v.fireTimer = Game.worldTimer
					end
				else
					v.inCombat = false
					v.state = "moving"
				end
			end


		elseif v.state == "running" then
			teamTwo:setGoal(_id, 20,0)
			v.moveTimer = Game.worldTimer

		elseif v.state == "bored" then
			teamTwo:setGoal(_id, 20, 0)
			v.moveTimer = Game.worldTimer			
		end
	end
end

function teamTwo:_debugSteal(_id)
	--[[local ent = self.teamTwoTable[_id]
	if math.dist(v.x,v.y,object:returnTable()[ent.targetID].x, object:returnTable()[ent.targetID].y) < 4 then
		object:giveDamage(ent.targetID, 1)
	end--]]
end

function teamTwo:assignTarget(_id)
	--[[local ent = self.teamTwoTable[_id]
	ent.targetID = math.random(1,#object:returnTable( ))
	ent.goal_x = object:returnTable()[ent.targetID].x - 1
	ent.goal_y = object:returnTable()[ent.targetID].y + 1
	ent.boolTarget = true--]]
end

function teamTwo:_debugAllTargets()
	for i,v in ipairs(self.teamTwoTable) do
		v.identified = 2
	end
end

function teamTwo:_debugIsNearCCTV(_id)
	--[[local ent = self.teamTwoTable[_id]
	if ent.civilian ~= 1 then
		for i,v in ipairs(cctv:returnTable()) do
			if math.dist(ent.x, ent.y, v.x, v.y) < v.range then
				ent.identified = 2
			end
		end
	end--]]
end

function teamTwo:dropAll( )
	self.teamTwoTable = {}
end

function teamTwo:orderMove( id, _path )
	self.teamTwoTable[id].path = _path
	self.teamTwoTable[id].isMoving = true
  	self.teamTwoTable[id].cur = 1 
  	self.teamTwoTable[id].there = true 
end

function teamTwo:move(_id, _dt)
	local baddy = self.teamTwoTable[_id]
  	if baddy.isMoving then
    	if not baddy.there then
    	
    		teamTwo:moveToTile(_id, baddy.path[baddy.cur].x,baddy.path[baddy.cur].y, _dt)
   		else
	    	
	   		if baddy.path[baddy.cur+1] then
	        	baddy.cur = baddy.cur + 1
	        	baddy.there = false
	     	else
	        	
	        	baddy.isMoving = false
	        	baddy.path = nil
	      	end        
    	end

  	end
end


function teamTwo:moveToTile(id, goal_tile_x,goal_tile_y, dt)
	local baddy = self.teamTwoTable[id]
  	local reached_x, reached_y = false, false 
  
 
  	local goal_x = goal_tile_x
  	local goal_y = goal_tile_y
  

  	local vx = (goal_x-baddy.x)/math.abs(goal_x-baddy.x)
  	local vy = (goal_y-baddy.y)/math.abs(goal_y-baddy.y)
  
 
  
  	local dy, dx
 
  	if (baddy.y~=goal_y) then
   		dy = dt*baddy.speed*vy*baddy.speed_mod
    	if vy > 0 then
      		baddy.y = baddy.y + math.min(dy,goal_y-baddy.y)
    	else 
      		baddy.y = baddy.y + math.max(dy,goal_y-baddy.y)
    	end
  	else
    	baddy.y = goal_y
    	reached_y = true
  	end  
  
  	if (baddy.x ~= goal_x) then
    	dx = dt*baddy.speed*vx*baddy.speed_mod
    	if vx > 0 then
      		baddy.x = baddy.x + math.min(dx,goal_x-baddy.x)
    	else
      		baddy.x = baddy.x + math.max(dx,goal_x-baddy.x)
    	end
  	else 
    	baddy.x = goal_x
    	reached_x = true
  	end  
  	if (reached_x and reached_y) then baddy.there = true end   
end

function teamTwo:getPath( _teamTwo )

end

function teamTwo:moveToGoal(id)

end

function teamTwo:setGoal(_id, _goal_x, _goal_y)


	--v = self.baddyTable[_id]
	v = self.teamTwoTable[_id]
	--if v.x == _goal_x and v.y == _goal_y 
	v.goal_x = _goal_x
	v.goal_y = _goal_y

	if pather.grid:isWalkableAt(v.goal_x, v.goal_y) and pather.grid:isWalkableAt(v.x, v.y) then

		local path, length = pather:getPath(v.x, v.y, v.goal_x, v.goal_y)
		if path then
			teamTwo:orderMove(_id,path)

		end
	end



end

function teamTwo:returnPosX(_id)
	local ent = self.teamTwoTable[_id]
	if ent ~= nil then
		return ent.x
	end
end

function teamTwo:returnPosY(_id)
	local ent = self.teamTwoTable[_id]
	if ent ~= nil then
		return ent.y
	end
end

function teamTwo:setTarget(_id)
	local ent = self.teamTwoTable[_id]
	ent.isMoving = true
	ent.isThere = false
	ent.cur = 1
	ent.state = "moving"
	
end
--------------------------------------------
-- teamTwo TABLE FUNCTIONS
--------------------------------------------

function teamTwo:returnTable( )
	return self.teamTwoTable
end

function teamTwo:returnEscapeNumber( )
	return #self.escapedConvicts
end

function teamTwo:spawnNewIndividual( )
	--[[if #self.teamTwoTable <= 1 then
		teamTwo:new(1, math.random(1,mapTilesY))
	end--]]
end