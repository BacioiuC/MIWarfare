animation = {}

function animation:init( )
	self.atlasTable = {}
	self.animTable = {}
end

function animation:newAtlas(_pathToAtlas, _rows, _columns)
	local temp = { }
	temp.id = #self.atlasTable + 1
	temp.atlas = MOAITileDeck2D.new()
	temp.atlas:setTexture(_pathToAtlas)
	temp.atlast:setSize(_rows, _columns)

	table.insert(self.atlasTable, temp)
	return self.atlasTable[#self.atlasTable].atlas
end

