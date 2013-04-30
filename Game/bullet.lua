bullet = {}

function bullet:init( )
	self.bulletTable = {}
	bullet_2_gfx = image:newTexture("Game/media/bullet2.png",Game.MainLayer,"Bullet_2_gfx")
end
function bullet:newBullet(_x, _y, _tx, _ty, _angle, _type)
	local tempBullet = {
		id = #self.bulletTable + 1,
		x = _x,
		y = _y,
		angle = _angle,
		life = 2000,
		target_x = _tx,
		target_y = _ty,
		speed = 0.13,
	}
	if _type == 1 then
		tempBullet.gfx = image:newImage(teamOne.ammo[1], _x*16, _y*16)
	elseif _type == 2 then
		tempBullet.gfx = image:newImage(bullet_2_gfx,_x*16,_y*16)
	end

	table.insert(self.bulletTable, tempBullet)
end

function bullet:updateBullet( )
		dt = 1
	for i,v in ipairs(self.bulletTable) do
		if v.life > 3 then

			local goal_x = v.target_x
  			local goal_y = v.target_y

  			local reached_x = false
  			local reached_y = false

  			if goal_x ~= nil then

			  	local vx = (goal_x-v.x)/math.abs(goal_x-v.x)
			  	local vy = (goal_y-v.y)/math.abs(goal_y-v.y)
			  

			  
			  	local dy, dx

			  	if (v.y~=goal_y) then
			   		dy = dt*v.speed*vy
			    	if vy > 0 then
			      		v.y = v.y + math.min(dy,goal_y-v.y)
			    	else 
			      		v.y = v.y + math.max(dy,goal_y-v.y)
			    	end
			  	else
			    	v.y = goal_y
			    	reached_y = true
			  	end  
		
			  	if (v.x ~= goal_x) then
			    	dx = dt*v.speed*vx
			    	if vx > 0 then
			      		v.x = v.x + math.min(dx,goal_x-v.x)
			    	else
			      		v.x = v.x + math.max(dx,goal_x-v.x)
			    	end
			  	else 
			    	v.x = goal_x
			    	reached_x = true
			  	end  

			  	if (reached_x and reached_y) then v.life = 0 end
			  	v.life = v.life - 10
				image:updateImage(v.gfx,v.x*16+8, v.y*16+8)
			end
		else
			bullet:removeBullet(i)
		end

	end
end

function bullet:removeBullet(_id)
	local bllt = self.bulletTable[_id]
	--if bllt.life <= 1 then
		image:removeProp(bllt.gfx)
		bllt.gfx = nil
		table.remove(self.bulletTable, _id)
		for i,v in ipairs(self.bulletTable) do
			v.id = i
		end
	--end
end
