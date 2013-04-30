teamOne = {}
stateList = { "idle", "searching", "moving", "combat", "acting", "runnin", "bored" }
function teamOne:init( )
	self.teamOneTable = {}
	self.teamOne = {}
	self.teamTwo = {}

	teamOne.gfx = {}
	teamOne.gfx[1], teamOne.TexName = image:newTexture("Game/media/soldier_1.png",1,"BaddyTexGFX")
	teamOne.gfx[2], teamOne.TexName2 = image:newTexture("Game/media/tank1.png",1,"BaddyTexGFX2")
	teamOne.ammo = {}
	teamOne.ammo[1] = image:newTexture("Game/media/bullet1.png",1,"BulletTex1")
	self.escapedConvicts = {}

	--[[teamOne:new(16,32)
	teamOne:new(15,32)
	teamOne:new(14,32)
	teamOne:new(17,32)--]]
	for i = 1, 32 do
		teamOne:new(i, 21, 1)
	end

	

	self.orderTable = {}

end

----- move bellow -----
function teamOne:returnUnderMouse(_x, _y)
	for i,v in ipairs(self.teamOneTable) do
	--local ent = self.teamOneTable[_id]
	--if ent.x == Game.mouseX and ent.y == Game.mouseY 
		if v.selected == false then
			if v.x == _x and v.y == _y then
				table.insert(self.orderTable,v.id)
				v.selected = true
				v.r = 0
				v.b = 0
				print("I added: "..v.id.." To selection table")
				pointerPath:newSection(_x, _y)
				return true

			end
		else
			pointerPath:newSection(_x, _y)
		end
	end
	return false
end

function teamOne:returnUnderMouseBasedOnDist(_x, _y)
	for i,v in ipairs(self.teamOneTable) do
	--local ent = self.teamOneTable[_id]
	--if ent.x == Game.mouseX and ent.y == Game.mouseY 
		if v.selected == false then
			if math.dist(v.x, v.y, _x, _y) <= 1 then --v.x == _x and v.y == _y then
				table.insert(self.orderTable,v.id)
				v.selected = true
				v.r = 0
				v.b = 0
				print("I added: "..v.id.." To selection table")
				pointerPath:newSection(_x, _y)
				return true

			end
		else
			pointerPath:newSection(_x, _y)
		end
	end
	return false
end

function teamOne:dropAll( )
	for i,v in ipairs(self.teamOneTable) do
		image:updateImage(v.gfx, 2000, 20000)
	end
end

function teamOne:setTableGoal(_x, _y, _path)
	for i = 1, #self.orderTable do
		for j,v in ipairs(self.teamOneTable) do
			if v.id == self.orderTable[i] then
				print("YESSS, YESSSSSSSSS")


				v.selected = false
				v.r = 0.3
				v.g = 0.3
				v.b = 1
				v.goal_x = _x
				v.goal_y = _y
				v.secondaryPath = _path
				v.firstMove = true

				--[[if v.type == 1 then
					v.damage = 53
					v.hp = 63
				else
					v.damage = 39
					v.hp = 83
				end--]]
				if gui:returnSelection( ) == 1 then
					v.stance = "Defend"
					speed_mod = 3
					if v.type == 1 then
						v.damage_modifier = -0.4
						v.hp_modifier = 2.9
						v.fr_modifier = -0.01
					elseif v.type == 2 then
						v.damage_modifier = -0.1
						v.hp_modifier = 3.1
						v.fr_modifier = -0.02
					end
					--v.damage_modifier = 
				elseif gui:returnSelection( ) == 2 then
					v.stance = "Attack"
					if v.type == 1 then
						v.damage_modifier = 1.3
						v.hp_modifier = -0.3
						v.fr_modifier = -0.02
					elseif v.type == 2 then
						v.damage_modifier = 2.0
						v.hp_modifier = -2
						v.fr_modifier = -0.03
					end
					speed_mod = 140
				end

				v.damage = v.damage+v.damage_modifier
				v.hp = v.hp + v.hp_modifier
				v.fire_rate = v.fire_rate + v.fr_modifier

				--pointerPath:endSection(_x, _y)
			end
		end
	end

	self.orderTable = {}
end
-----------------------


function teamOne:new(_x, _y, _type)
	if _type == 1 then
		cost = 40
	else
		cost = 100
	end
	-- set to spawn at spawn point

	if Game.points >= cost then
		local __x, __y = _x, _y
		local temp = {
			id = #self.teamOneTable + 1,
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
			secondaryPath = {},
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
			target_id = nil,
			hp = 100,
			inCombat = false,
			removeTimer = Game.worldTimer,
			vangle = 1,
			selected = false,
			r = 1,
			g = 1,
			b = 1,
			firstMove = false,
			willDefend = false,
			stance = "Attack",
			speed_mod = 0,
			isDead = false,
			damage_modifier = 0,
			hp_modifier = 0,
			fr_modifier = 0,
			speed_mod = 0.6,
			}

			temp.gfx = image:newImage(teamOne.gfx[_type], temp.x*16, temp.y*16)
			if _type == 1 then
				temp.range = 4
				temp.fire_rate = 0.5
				--temp.speed = math.random(0.02, 0.08)
				temp.damage = 1.2
				temp.health = 5
			else
				temp.range = 7
				temp.fire_rate = 0.8
				--temp.speed = math.random(0.07, 0.12)
				temp.damage = 1.3
				temp.health = 9

			end
			image:updateAndColorImage(temp.gfx,temp.x*16, temp.y*16, temp.r, temp.g, temp.b)
			table.insert(self.teamOneTable, temp)

			--return cost
			Game.points = Game.points - cost
		else
			print("NOT ENOUGH DO-RE-MI BROTHA + GamePoints: "..Game.points.."")
		end

end

function teamOne:updateOutsideOfSim( )
	for i,v in ipairs(self.teamOneTable) do
		image:updateAndColorImage(v.gfx,v.x*16, v.y*16, v.r, v.g, v.b)
	end
end

function teamOne:_debugSpawnRandom( _x, _y )
	for i = 1, math.random(2,17) do
		teamOne:new(_x, _y)
	end
end

function teamOne:draw( )
	for i,v in ipairs(self.teamOneTable) do

	--	love.graphics.rectangle("line",v.act_x*32,v.act_y*32,32,32)

	end
end

function teamOne:checkIfNearOpponent(_id)
	local ent = self.teamOneTable[_id]
	for i,v in ipairs(teamTwo:returnTable()) do
		if math.dist(ent.x, ent.y, v.x, v.y) <= ent.range and ent.inCombat == false then
			teamOne:setGoal(_id, ent.x, ent.y)
			ent.targetID = i
			ent.inCombat = true
			ent.state = "combat"
		end
	end
end

function teamOne:clearAndDeploy(_id)
	local ent = self.teamOneTable[_id]
	if ent.y < 2 then
		Game.EnemyLife = Game.EnemyLife-1
		ent.hp = 0
		if ent.isDead == false then
			--self.deadCounter = self.deadCounter + 1
			ent.isDead = true
		end
		
		
		image:removeProp(ent.gfx)
		ent.x = 2000
		ent.y = 200000
	end
end

function teamOne:_debugDraw( )
	--[[for i,v in ipairs(self.teamOneTable) do
		if v.path ~= nil then
			print("X: "..v.x.." Act_X: "..v.act_x.." Y: "..v.y.." Act_Y: "..v.act_y.." GOAL_X "..v.goal_x.." GOAL_Y: "..v.goal_y.."",20,20*i-20)
		end
	end--]]
end

function teamOne:giveDamage(_id, damage)
	if self.teamOneTable[_id] ~= nil then
		local ent = self.teamOneTable[_id]
		ent.removeTimer = Game.worldTimer
		ent.hp = ent.hp - damage
	end
end

function teamOne:setRGBToOne(_id)
	local v = self.teamOneTable[_id]
	v.r = 1
	v.g = 1
	v.b = 1
end

function teamOne:update(_dt)
	for i,v in ipairs(self.teamOneTable) do
		
		if v.hp > 1 then
			teamOne:setRGBToOne(i)
			teamOne:handleStates(i)
			teamOne:move(i,_dt)
	
			--image:updateImage(v.gfx, v.x*16, v.y*16)
	
			--image:updateImage(v.gfx, v.x*16, v.y*16)
			image:updateAndColorImage(v.gfx, v.x*16, v.y*16, v.r, v.g, v.b)
			--print("PosX: "..v.x.." PosY: "..v.y.." v.state: "..v.state.."\n")

			teamOne:checkIfNearOpponent(i)
			teamOne:clearAndDeploy(i)
		else
			teamOne:remove( i )
		end

		
		--teamOne:updateBullet( )
	end
end


function teamOne:getNum( )
	return #self.teamOneTable
end


function teamOne:remove( _id )
	local ent = self.teamOneTable[_id]
	image:removeProp(ent.gfx)
	ent.x = 2000
	ent.y = 2000

	if Game.worldTimer > ent.removeTimer + 995 then
		table.remove(self.teamOneTable,_id)
		for i,v in ipairs(self.teamOneTable) do
			v.id = i
		end
	end
end

function teamOne:dropALL( )

	self.teamOneTable = {}
end

function teamOne:_debugESCAPE(_id, _escapePoint)

end



----------------------------------------------------
-- teamOne STATES AND SWITCHING BETWEEN STATES HERE
----------------------------------------------------

function teamOne:handleStates(_id)
	local v = self.teamOneTable[_id]

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
			--teamOne:orderMove(_id, _path)
				if v.firstMove == true then
					teamOne:setGoal(_id, v.goal_x, v.goal_y)
				elseif v.stance == "Attack" then
					if v.y <= 4 then
						teamOne:setGoal( _id , v.x, 1)
					else
						teamOne:setGoal( _id , math.random(1,grid_x), math.random(1, v.y-7)) -- 1,vy : RANDOM BETWEEN the ent position and grid 1
					end
				end
				v.moveTimer = Game.worldTimer
				--if v.cilian == 1 then
				--	v.boreMeter = v.boreMeter + 1
				--end
				--print("MOVING STATE HERE")
			--end
		elseif v.state == "acting" then
			if v.boolTarget == false then
				--teamOne:assignTarget(_id)
				v.state = "moving"
				--v.boolTarget = true
			else
				teamOne:setGoal(_id, v.goal_x, v.goal_y)
				--teamOne:_debugSteal(_id)
				v.moveTimer = Game.worldTimer
			end
			
		elseif v.state == "combat" then
			for i2, v2 in ipairs(teamTwo:returnTable()) do
				if math.dist(v.x, v.y, v2.x, v2.y) <= v.range then
					if Game.worldTimer > v.fireTimer + v.fire_rate then
						bullet:newBullet(v.x, v.y, teamTwo:returnPosX(v.targetID), teamTwo:returnPosY(v.targetID), 1,1)
					--	if v.type == 1 then
							teamTwo:giveDamage(v.targetID, v.damage)
						--else
						--	teamTwo:giveDamage(v.targetID, math.random(5,30))
						--end
						v.fireTimer = Game.worldTimer
					end
				else
					v.inCombat = false
					v.state = "moving"
				end
			end

		elseif v.state == "running" then
			teamOne:setGoal(_id, 20,0)
			v.moveTimer = Game.worldTimer

		elseif v.state == "bored" then
			teamOne:setGoal(_id, 20, 0)
			v.moveTimer = Game.worldTimer			
		end
	end
end

function teamOne:_debugSteal(_id)
	--[[local ent = self.teamOneTable[_id]
	if math.dist(v.x,v.y,object:returnTable()[ent.targetID].x, object:returnTable()[ent.targetID].y) < 4 then
		object:giveDamage(ent.targetID, 1)
	end--]]
end

function teamOne:assignTarget(_id)
	--[[local ent = self.teamOneTable[_id]
	ent.targetID = math.random(1,#object:returnTable( ))
	ent.goal_x = object:returnTable()[ent.targetID].x - 1
	ent.goal_y = object:returnTable()[ent.targetID].y + 1
	ent.boolTarget = true--]]
end

function teamOne:_debugAllTargets()
	for i,v in ipairs(self.teamOneTable) do
		v.identified = 2
	end
end

function teamOne:_debugIsNearCCTV(_id)
	--[[local ent = self.teamOneTable[_id]
	if ent.civilian ~= 1 then
		for i,v in ipairs(cctv:returnTable()) do
			if math.dist(ent.x, ent.y, v.x, v.y) < v.range then
				ent.identified = 2
			end
		end
	end--]]
end

function teamOne:dropAll( )
	self.teamOneTable = {}
end

function teamOne:orderMove( id, _path )
	self.teamOneTable[id].path = _path
	self.teamOneTable[id].isMoving = true 
  	self.teamOneTable[id].cur = 1 
  	self.teamOneTable[id].there = true
end

function teamOne:move(_id, _dt)
	local baddy = self.teamOneTable[_id]
  	if baddy.isMoving then
    	if not baddy.there then
    	 
    		teamOne:moveToTile(_id, baddy.path[baddy.cur].x,baddy.path[baddy.cur].y, _dt)
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


function teamOne:moveToTile(id, goal_tile_x,goal_tile_y, dt)
	local baddy = self.teamOneTable[id]

  	local reached_x, reached_y = false, false 
  

  	local goal_x = goal_tile_x
  	local goal_y = goal_tile_y
  

  	local vx = (goal_x-baddy.x)/math.abs(goal_x-baddy.x)
  	local vy = (goal_y-baddy.y)/math.abs(goal_y-baddy.y)
  
  	local dy, dx
 
  	if (baddy.y~=goal_y) then
   		dy = dt*baddy.speed*vy*baddy.speed_mod -- (multiply with 0.x for slower, divide by it for faster)
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
    	dx = dt*baddy.speed*vx*baddy.speed_mod -- (multiply with 0.x for slower, divide by it for faster)
    	if vx > 0 then
      		baddy.x = baddy.x + math.min(dx,goal_x-baddy.x)
    	else
      		baddy.x = baddy.x + math.max(dx,goal_x-baddy.x)
    	end
  	else 
    	baddy.x = goal_x
    	reached_x = true
  	end  
  	if (reached_x and reached_y) then 
  		if baddy.firstMove == true then
  			baddy.firstMove = false
  		end
  		if baddy.willDefend == true then
  			baddy.stance = "Defence"
  		end
  		baddy.there = true
  	end   
end

function teamOne:getPath( _teamOne )

end

function teamOne:moveToGoal(id)

end

function teamOne:setGoal(_id, _goal_x, _goal_y)


	--v = self.baddyTable[_id]
	v = self.teamOneTable[_id]
	--if v.x == _goal_x and v.y == _goal_y 
	v.goal_x = _goal_x
	v.goal_y = _goal_y


	if v.firstMove == true then
		teamOne:orderMove(_id,v.secondaryPath)
	else
		if pather.grid:isWalkableAt(v.goal_x, v.goal_y) and pather.grid:isWalkableAt(v.x, v.y) then

			local path, length = pather:getPath(v.x, v.y, v.goal_x, v.goal_y)
			if path then
				teamOne:orderMove(_id,path)

			end
		end
	end



end

function teamOne:returnPosX(_id)
	if self.teamOneTable[_id] ~= nil then
		local ent = self.teamOneTable[_id]
		return ent.x
	else
		return 1
	end
end

function teamOne:returnPosY(_id)
	if self.teamOneTable[_id] ~= nil then
		local ent = self.teamOneTable[_id]
		return ent.y
	else
		return 1
	end
end
--------------------------------------------
-- teamOne TABLE FUNCTIONS
--------------------------------------------

function teamOne:returnTable( )
	return self.teamOneTable
end

function teamOne:returnEscapeNumber( )
	return #self.escapedConvicts
end

function teamOne:spawnNewIndividual( )
	--[[if #self.teamOneTable <= 1 then
		teamOne:new(1, math.random(1,grid_y))
	end--]]
end