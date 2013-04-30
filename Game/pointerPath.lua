pointerPath = {}

function pointerPath:init( )
	self.pointerTable = {}
	self.path = {}
	self.cur = 1
	self.pathList = {}

	path_tex = image:newTexture("Game/media/path_attack.png",Game.MainLayer,"PATH_TEX")
	path_end_tex = image:newTexture("Game/media/path_end.png",Game.MainLayer,"PATH_END_TEX")

	self.PathGFX = { }
	self.gfxCounter = 0
	self.sectionPlaced = false
end

function pointerPath:newSection(_x, _y)
	local temp = {
		x = _x,
		y = _y,
	}

	table.insert(self.pointerTable,temp)
	self.cur = #self.pointerTable

	if self.cur >= 2 then
		self.path = pather:getPath(self.pointerTable[self.cur-1].x, self.pointerTable[self.cur-1].y, self.pointerTable[self.cur].x, self.pointerTable[self.cur].y)
		if self.path ~= nil then
			for i,v in ipairs(self.path) do
				self.PathGFX[self.gfxCounter+i] = image:newImage(path_tex,v.x*16,v.y*16)

			end
		end
	end

	self.sectionPlaced = true

	self.gfxCounter = #self.PathGFX
end

function pointerPath:endSection(_x, _y)
	--image:newImage(path_end_tex,_x*16,_y*16)

	table.insert(self.pathList,path)
	print("AUQI TINGAMS UNA PROBLEMA ---- ")
	if self.pointerTable ~= nil and self.pathList ~= nil then
		if self.sectionPlaced == true then
			teamOne:setTableGoal(self.pointerTable[self.cur].x, self.pointerTable[self.cur].y, self.pointerTable)
		end
	end
	for i = 1, #self.PathGFX do
		image:removeProp(self.PathGFX[i])
	end

	if self.sectionPlaced == true then
		posTable[#posTable+1] = image:newImage(pos_marker_tex, self.pointerTable[self.cur].x*16, self.pointerTable[self.cur].y*16 )
	end
	path = {}
	self.cur = 1
	self.pointerTable = {}
	self.sectionPlaced = false
end