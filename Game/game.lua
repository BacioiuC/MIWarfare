Game = {} -- MAIN CLASS

require "tableWork"
require "Game.scene.map"
require "Game.bullet"
require "Game.entity"
require "Game.team2"
require "core.math"
require "Game.pointerPath"
require "Game.scene.gui"

local Grid = require ("Game.lib.jumper.grid") -- The grid class
local Pathfinder = require ("Game.lib.jumper.pathfinder") -- The pathfinder lass


Game.worldTimer = MOAISim.getElapsedTime( )
Game.mouseX = 0
Game.mouseY = 0

Game.AiLevel = 1

Game.MainLayer = 1
Game.GuiLayer = 2
Game.BackgroundLayer = 3
Game.score = 0
Game.FakeTimer = 691
walkable = 1

Game.stateList = { "MainMenu", "Loading", "Init", "PathTrace", "Simulation", "GameOver" }
Game.state = "MainMenu"

offset_x = -1.07
offset_y = 1.0

Game.lifes = 3
Game.EnemyLife = 3
Game.points = 1300
Game.modes = { "play", "paused" }
Game.mode = "play"

Game.levelTiles = {}
Game.levelTiles[1] = 1
Game.levelTiles[2] = 2
Game.levelTiles[3] = 3

Game.mapTiles = 3
Game.mapName = "maps/winter_wonderland.miw"
Game.menuInit = false
Game.maxEnemies = 17
function Game:init( )
	image:init( )
	
	core:offsetViewport(offset_x, offset_y)
	image:newText(215, 0, Game.points)
	
	
end


function Game:update( )
	dt = 1
	_dt = 1
	Game.worldTimer = MOAISim.getElapsedTime ()
	

	if Game.state == "MainMenu" then
		if Game.menuInit == false then
			gui:loadMM()
			Game.menuInit = true
		else

		end
	elseif Game.state == "Loading" then
		gui:hideMMBackground( )
		map:init(Game.mapName)
		gui:init( )
		bullet:init( )
		Game:initPathfinding( )
		pointerPath:init( )
		teamOne:init( )
		teamTwo:init( )
		
		gui:setInitStageVisibility( )
		Game.state = "Init"
	elseif Game.state == "Init" then
		
		teamOne:updateOutsideOfSim( )
		print(""..gui:returnSelection( ).."")
		gui:updateUnitBar( )
		image:renderText(Game.points)
	elseif Game.state == "PathTrace" then
		gui:updateUnitBar( )
		--image:setVisible(unit_bar, false)
		teamOne:updateOutsideOfSim( )

	elseif Game.state == "Simulation" and Game.mode == "play" then
		
		bullet:updateBullet(1)
		teamOne:update(1)
		teamTwo:update(1)

		gui:updateHearts( )

		if Game.lifes <= 0 then
			Game.state = "GameOver"
		end

		if Game.EnemyLife <= 0 then
			Game.state = "GameOver"
		end

		if teamTwo:howManyAlive() < 1 then
			Game.state = "GameOver"
		end

		--print("ALIVE: "..teamTwo:howManyAlive( ).."")
		
	elseif Game.state == "GameOver" then
		--Game.state = "Init"
		teamOne:dropAll( )
		teamTwo:dropAll( )
		
		if  Game.EnemyLife <= 0 then
			image:updateImage(p1_win_1, 15, 0)
			image:updateImage(p1_win_2, 275, 0)
		elseif Game.lifes <= 0 then
			image:updateImage(p2_win_1, 15, 0)
			image:updateImage(p2_win_2, 275, 0)			
		elseif teamTwo:howManyAlive( ) >= 1  then
			image:updateImage(p2_win_1, 15, 0)
			image:updateImage(p2_win_2, 275, 0)
		else
			image:updateImage(p1_win_1, 15, 0)
			image:updateImage(p1_win_2, 275, 0)
		end
		image:setVisible(resetButton, true)
	end

	if Game.mode == "paused" then
		gui:updateUnitBarDuringPause( )

	end
	--entity:_debugDraw( )	
end


function Game:draw( )


end

function Game:keypressed( key )

end

function Game:keyreleased( key )

end

function Game:touchPressed ( )
	if Game.state == "MainMenu" then
		if Game.mouseX > 12 and Game.mouseX < 215 then
			if Game.mouseY > 200 and Game.mouseY < 339 then
				
				Game.mapName = "maps/forest_frenzy.miw"
				Game.mapTiles = 1
				Game.maxEnemies = 17
				Game.state = "Loading"
				
			end

		elseif Game.mouseX > 284 and Game.mouseX < 487 then
			if Game.mouseY > 31 and Game.mouseY < 170 then
				Game.mapName = "maps/autumn_ashes.miw"
				Game.mapTiles = 2
				Game.maxEnemies = 26
				Game.state = "Loading"
				
			elseif Game.mouseY > 199 and Game.mouseY < 323 then
				Game.mapName = "maps/winter_wonderland.miw"
				Game.mapTiles = 3
				Game.maxEnemies = 32
				Game.state = "Loading"

			end
		end
	elseif Game.state == "Init" then

		if Game.mouseY > 34 and Game.mouseY < 94 then
			if Game.mouseX > 20 and Game.mouseX < 50 then
				gui.selection = 1
			elseif Game.mouseX > 70 and Game.mouseX < 100 then
				gui.selection = 2
			elseif Game.mouseX > 475 then
				Game.state = "PathTrace"
			end
		end

		if math.floor(Game.mouseY/16) > 20 then

			teamOne:new(math.floor(Game.mouseX/16),math.floor(Game.mouseY/16),gui:returnSelection( ))

		end
	elseif Game.state == "PathTrace" then
		if math.floor(Game.mouseY/16) > 5 then
			if teamOne:returnUnderMouse(math.floor(Game.mouseX/16), math.floor(Game.mouseY/16)) == true then

			else
				--teamOne:setTableGoal(math.floor(Game.mouseX/16), math.floor(Game.mouseY/16))
			end
		end

		-- MEH ZA SELECT PATH TYPE
		if Game.mouseY > 34 and Game.mouseY < 94 then
			if Game.mouseX > 20 and Game.mouseX < 50 then
				gui.selection = 1
			elseif Game.mouseX > 70 and Game.mouseX < 100 then
				gui.selection = 2
			elseif Game.mouseX > 120 and Game.mouseX < 150 then
				pointerPath:endSection(nil, nil)
			elseif Game.mouseX > 475 then
				
				 pointerPath:endSection(nil, nil)
				 gui:hideAll( )
				Game.state = "Simulation"
			end
		end
		--pointerPath:newSection(math.floor(Game.mouseX/16),math.floor(Game.mouseY/16))

		--if Game.mouseX > 200 then
			
		--end
	elseif Game.state == "Simulation" and Game.mode == "paused" then
		teamOne:updateOutsideOfSim( )
		if math.floor(Game.mouseY/16) > 3 then
			teamOne:returnUnderMouseBasedOnDist(math.floor(Game.mouseX/16), math.floor(Game.mouseY/16)) 
		end
		if Game.mouseY > 34 and Game.mouseY < 94 then
			if Game.mouseX > 20 and Game.mouseX < 50 then
				gui.selection = 1
			elseif Game.mouseX > 70 and Game.mouseX < 100 then
				gui.selection = 2
			elseif Game.mouseX > 120 and Game.mouseX < 150 then
				pointerPath:endSection(nil, nil)
			elseif Game.mouseX > 475 then
				print("SIMU + PLAY???")
				 pointerPath:endSection(nil, nil)
				 gui:hideAll( )
				 Game.mode = "play"
			end
		elseif Game.mouseY >=0 and Game.mouseY <= 16 then
			if Game.mouseX > 215 and Game.mouseX < 279 then
				Game:dropAll( )
				Game.mode = "play"
				--gui:showMMBackground( )
				Game.menuInit = false
				Game.lifes = 3
				Game.EnemyLife = 3
				Game.points = 1290
				Game.state = "MainMenu"	
			end
		end
	elseif Game.state == "GameOver" then
		if Game.mouseX > 197 and Game.mouseX < 279 then
			if Game.mouseY > 307 then
				Game:dropAll( )
				
				--gui:showMMBackground( )
				Game.menuInit = false
				Game.lifes = 3
				Game.EnemyLife = 3
				Game.points = 1290
				Game.state = "MainMenu"				
			end
		end
	end

end

function Game:dropAll( )
	image:dropAllImages( )
end

function Game:touchRight( )
	--[[if Game.state == "Init" then
		gui:hideUnitBarStuff( )
		Game.state = "PathTrace"
		--Game.lifes = 2
		--pointerPath:endSection(math.floor(Game.mouseX/16),math.floor(Game.mouseY/16))
	elseif Game.state == "PathTrace" then
		Game.state = "Simulation"
	end--]]

	if Game.state == "Simulation" then
		if Game.mode == "play" then
			Game.mode = "paused"
		elseif Game.mode == "paused" then
			gui:hideAll( )
			Game.mode = "play"
		end
	end

	if Game.state == "GameOver" then

	end
end

function Game:touchReleased ( )

end

function Game.touchLocation( x, y )
	
	Game.mouseX, Game.mouseY = core:returnLayerTable( )[1].layer:wndToWorld(x, y)
	Game.msX, Game.msY = x, y
	--print("TOUCHING! ALL THE TOUCHING AT: "..x.." and "..y.."")
	
	

end

function Game:ViewportScale(_ammount)
	core:returnViewPort( )[1].viewPort:setScale(core:returnVPWidth()/_ammount, -core:returnVPHeight()/_ammount)
end
--MOAIInputMgr.device.pointer:setCallback(Game.touchLocation)

function Game:estimateGridLocation( )

end

function Game:initPathfinding( )
	grid = Grid(map.collision) 
	
	pather = Pathfinder(grid, 'ASTAR', walkable) 
end

function Game:updatePathfinding( )
	grid = Grid(map.collision) 
	
	pather = Pathfinder(grid, 'ASTAR', walkable) 
end

function Game:loop( )
	Game:update( )
	Game:draw( )
end

function Game:drop( )
	image:dropProps( )

end

function onMouseLeftEvent(down)
  if (down) then
   
  else
    
  end
end
--MOAIInputMgr.device.mouseLeft:setCallback(onMouseLeftEvent)