map = {}
map.data = {}
map.collision = {}

grid_x = resX/32
grid_y = resY/32-2

tile_size = 16

map.tCounter = 1

map.tex = {}
map.gfx = {}

offset_y = 16

function map:dropAll( )
end

function map:init(_fileToLoad)
	self.mapTable = {}
	--grass_tex = image:newTexture("Game/media/grass.png", Game.MainLayer, "GRASS_TEX")
	--deep_grass_tex = image:newTexture("Game/media/deep_grass.png", Game.MainLayer, "DEEP_GRASS_TEX")
	--obstacle_tex = image:newTexture("Game/media/obstacle.png",Game.MainLayer, "OBSTACLE_TEX")
	--tree_tex = image:newTexture("Game/media/tree.png",Game.MainLayer,"TREE_TEX")

	map.tex[1] = {}
	map.tex[1].grass = image:newTexture("Game/media/grass.png", Game.MainLayer, "GRASS_TEX")
	map.tex[1].deep_grass = image:newTexture("Game/media/deep_grass.png", Game.MainLayer, "DEEP_GRASS_TEX")
	map.tex[1].obstacle = image:newTexture("Game/media/obstacle.png",Game.MainLayer, "OBSTACLE_TEX")
	map.tex[1].tree = image:newTexture("Game/media/tree.png",Game.MainLayer,"TREE_TEX")

	map.tex[2] = {}
	map.tex[2].grass = image:newTexture("Game/media/autumn_grass.png", Game.MainLayer, "AUTUMN_GRASS_TEX")
	map.tex[2].deep_grass = image:newTexture("Game/media/autumn_deepgrass.png", Game.MainLayer, "AUTUMN_DEEP_GRASS_TEX")
	map.tex[2].obstacle = image:newTexture("Game/media/autumn_rock.png",Game.MainLayer, "AUTUMN_OBSTACLE_TEX")
	map.tex[2].tree = image:newTexture("Game/media/autumn_tree.png",Game.MainLayer,"AUTUMN_TREE_TEX")	

	map.tex[3] = {}
	map.tex[3].grass = image:newTexture("Game/media/winter_grass.png", Game.MainLayer, "winter_GRASS_TEX")
	map.tex[3].deep_grass = image:newTexture("Game/media/winter_deepgrass.png", Game.MainLayer, "winter_DEEP_GRASS_TEX")
	map.tex[3].obstacle = image:newTexture("Game/media/winter_rock.png",Game.MainLayer, "winter_OBSTACLE_TEX")
	map.tex[3].tree = image:newTexture("Game/media/winter_tree.png",Game.MainLayer,"winter_TREE_TEX")
	
	map.gfx[1] = {}

	map:generateGrid( )
	--map:fuckUpGrid( )
	--map:addTrees( )
	map:load(_fileToLoad)
	map:generateCollision( )

	-- 0 = grass
	-- 1 = deep_grass
	-- 2 = rock
	-- 3 = tree

	map.tiles = {}
	map.tiles[0] = map.tex[Game.mapTiles].grass
	map.tiles[1] = map.tex[Game.mapTiles].deep_grass
	map.tiles[2] = map.tex[Game.mapTiles].obstacle
	map.tiles[3] = map.tex[Game.mapTiles].tree

	map:fillWithTiles( )

end

function map:updateTileTable( )
	map.tiles[0] = map.tex[Game.mapTiles].grass
	map.tiles[1] = map.tex[Game.mapTiles].deep_grass
	map.tiles[2] = map.tex[Game.mapTiles].obstacle
	map.tiles[3] = map.tex[Game.mapTiles].tree
end

function map:newTimeAt(_x, _y)
	map.data[_y][_x] = Game.tCounter
	image:newImage(map.tiles[Game.tCounter],_x*16,_y*16)

	
end

function map:updatePreviewImage( )
	image:newImage(map.tiles[Game.tCounter],6,6)
end

function map:load(_file)
	if _file ~= nil then
		table_string = table.load(_file)
		for y = 1, #table_string do
			map.data[y] = {}
			for x = 1, #table_string[y] do
				map.data[y][x] = table_string[y][x]
			end
		end
		--map:fillWithTiles( )
	else
		print("CANNOT LOAD MAP")
	end
end

function map:generateGrid( )
	for y = 1, grid_y do
		map.data[y] = {}
		for x = 1, grid_x do
			map.data[y][x] = math.random(0,1)
			--[[if map.data[y][x] == 0 then
				map.gfx[1].grass = image:newImage(map.tex[Game.mapTiles].grass,x*tile_size ,y*tile_size )	
			elseif map.data[y][x] == 1 then
				map.gfx[1].deep_grass = image:newImage(map.tex[Game.mapTiles].deep_grass,x*tile_size, y*tile_size)
			end--]]
		end
	end

end

function map:fuckUpGrid( )
	for y = 1, grid_y do
		for x = 1, grid_x do
			local rndPass = math.random(1,62)
			if y > 2 and y < grid_y - 2 then
				if rndPass == 3 then
					map.data[y][x] = 2
					--map.gfx[1].obstacle = image:newImage(map.tex[Game.mapTiles].obstacle, x*tile_size ,y*tile_size )
				--end
				elseif rndPass > 23 and rndPass < 30--[[rndPass == 27 or rndPass == 61  or rndPass == 9--]] then
					map.data[y][x] = 3
					--map.gfx[1].tree = image:newImage(map.tex[Game.mapTiles].tree, x*tile_size ,y*tile_size )
				end
			end
		end
	end
end

function map:fillWithTiles( )
	for y = 1, grid_y do
		for x = 1, grid_x do
			image:newImage(map.tiles[map.data[y][x]],x*tile_size,(y)*tile_size)
		end
	end
end

function map:addTrees( )
--[[	tCounter = 1
	for y = 1, grid_y do
		for x = 1, grid_x do
			if y > 3 and y < grid_y - 5 then
				if x >= 1 and x <= grid_x - 5 then
					local rndPass = math.random(1, 25)
					--if rndPass == 11 then
							for k = 1, 5 do
								for j = 1, 5 do
									map.data[y][x] = map.treeGrid[k][j]
								end
							end
							tCounter = tCounter + 1
					--end
				end
			end
		end
	end

	for y = 1, grid_y do
		for x = 1, grid_x do
			if map.data[y][x] == 5 then
				tree = image:newImage(tree_tex,x*16,y*16)
			end
		end
	end

]]
end


function map:generateCollision( )
	for y = 1, grid_y do
		map.collision[y] = {}
		for x = 1, grid_x do
			if map.data[y][x] == 2 or map.data[y][x] == 3 then
				map.collision[y][x] = 0
			else
				map.collision[y][x] = 1
			end
		end
	end
end

function map:update( )

end