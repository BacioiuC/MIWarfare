gui = {}
gui.selection = 1
gui.unitTab = {}
gui.unitTab[1] = 20 
gui.unitTab[2] = 70 
gui.unitTab[3] = 120

heartTable = {}
enemyHeartTable = {}

posTable = {}
function gui:init( )
	self.guiTable = {}
	unit_bar_tex = image:newTexture("Game/media/unit_bar.png",Game.MainLayer,"UNIT_BAR_TEX")
	unit_bar = image:newImage(unit_bar_tex,34,34)
	image:setVisible(unit_bar,false)

	unit_icon_1_tex = image:newTexture("Game/media/unit_icon_1_normal.png", Game.MainLayer,"UNIT_1_ICON_TEX")
	unit_icon_2_tex = image:newTexture("Game/media/unit_icon_2_normal.png", Game.MainLayer,"UNIT_2_ICON_TEX")
	unit_overlay_tex = image:newTexture("Game/media/unit_overlay.png",Game.MainLayer,"UNIT_OVERLAY_TEX")

	unit_icon_1 = image:newImage(unit_icon_1_tex, 20, 45)
	unit_icon_2 = image:newImage(unit_icon_2_tex, 70, 45)
	unit_overlay = image:newImage(unit_overlay_tex, 20, 45)


	move_def_tex = image:newTexture("Game/media/move_defend.png", Game.MainLayer, "MOVE_DEF_TEX")
	move_attack_tex = image:newTexture("Game/media/move_attack.png", Game.MainLayer, "MOVE_ATTK_TEX")
	end_move_tex = image:newTexture("Game/media/end_move.png",Game.MainLayer,"end_move_TEX")

	move_def = image:newImage(move_def_tex, 20, 45)
	move_attk = image:newImage(move_attack_tex, 70, 45)
	end_move = image:newImage(end_move_tex, 120, 45)

	image:setVisible(move_def,false)
	image:setVisible(move_attk,false)
	image:setVisible(end_move,false)


	p2_win_1_tex = image:newTexture("Game/media/p2_win_1.png",Game.MainLayer,"P2_Win_1")
	p2_win_2_tex = image:newTexture("Game/media/p2_win_2.png",Game.MainLayer,"P2_Win_2")

	p2_win_1 = image:newImage(p2_win_1_tex,-260,0)
	p2_win_2 = image:newImage(p2_win_2_tex,512+260,0)
	--image:seekLoc(p2_win_1,0,0)
	--image:seekLoc(p2_win_2,260,0)

	p1_win_1_tex = image:newTexture("Game/media/p1_win_1.png",Game.MainLayer,"P1_Win_1")
	p1_win_2_tex = image:newTexture("Game/media/p1_win_2.png",Game.MainLayer,"P1_Win_2")

	p1_win_1 = image:newImage(p1_win_1_tex,-260,0)
	p1_win_2 = image:newImage(p1_win_2_tex,512+260,0)

	heart_tex = image:newTexture("Game/media/life.png",Game.MainLayer,"HEART_TEX")
	for i = 1, Game.lifes do
		heartTable[i] = image:newImage(heart_tex,2 + i*16+1,1)
	end

	enemy_heart_tex = image:newTexture("Game/media/enemy_heart.png",Game.MainLayer,"ENEMY_HEART_TEX")
	for i = 1, Game.EnemyLife do
		enemyHeartTable[i] = image:newImage(enemy_heart_tex, 460 + i*16+1, 1)
	end

	

	pos_marker_tex = image:newTexture("Game/media/position_marker.png",Game.MainLayer,"POS_MARK_TEX")


	ressetButton_tex = image:newTexture("Game/media/reset_button.png",Game.MainLayer,"RST_BUTTON")
	resetButton = image:newImage(ressetButton_tex,197,307)
	image:setVisible(resetButton, false)

	mm_bttn_tex = image:newTexture("Game/media/main_menu_bttn.png",Game.MainLayer,"MM_BTTN_TEX")
	mm_bttn = image:newImage(mm_bttn_tex,215,0)
	image:setVisible(mm_bttn,false)
end

function gui:loadMM()
		-- main Menu image
	main_menu_tex = image:newTexture("Game/media/main_menu.png",Game.MainLayer,"MM_TEX")
	main_menu = image:newImage(main_menu_tex, 11, 0)
end

function gui:hideMMBackground( )
	image:setVisible(main_menu,false)
end

function gui:showMMBackground( )
	image:setVisible(main_menu,true)
end

function gui:setInitStageVisibility( )
	image:setVisible(unit_bar, true)
	image:updateImage(unit_bar,19,34)
end

function gui:updateUnitBar( )
	if Game.state == "Init" then
		image:setVisible(unit_bar, true)
		image:updateImage(unit_bar,19,34)
		image:updateImage(unit_overlay,gui.unitTab[gui.selection], 45)
	elseif Game.state == "PathTrace" then
		image:setVisible(move_def,true)
		image:setVisible(move_attk, true)
		image:setVisible(end_move,true)
		image:updateImage(unit_overlay,gui.unitTab[gui.selection], 45)
	end
end

function gui:updateUnitBarDuringPause( )
	if Game.mode == "paused" then
		image:setVisible(unit_bar, true)
		image:setVisible(move_def,true)
		image:setVisible(move_attk, true)
		image:setVisible(end_move,true)
		image:setVisible(unit_overlay, true)
		image:updateImage(unit_overlay,gui.unitTab[gui.selection], 45)
		image:setVisible(mm_bttn, true)
	end
end

function gui:dropPosMarkers( )
	for i = 1, #posTable do
		image:removeProp(posTable[i])
	end
end

function gui:updateHearts( )
	for i = 1, #heartTable do
		if i <= Game.lifes then
			image:setVisible(heartTable[i], true)
		else
			image:setVisible(heartTable[i], false)
		end
	end

	for i = 1, #enemyHeartTable do
		if i <= Game.EnemyLife then
			image:setVisible(enemyHeartTable[i], true)
		else
			image:setVisible(enemyHeartTable[i], false)
			
		end
	end
end

function gui:hideUnitBarStuff( )
	--image:setVisible(unit_bar,false)
	--image:setVisible(unit_overlay,false)
	image:setVisible(unit_icon_1,false)
	image:setVisible(unit_icon_2,false)
end

function gui:hideAll( )
	image:setVisible(unit_bar,false)
	image:setVisible(unit_overlay,false)
	image:setVisible(move_def, false)
	image:setVisible(move_attk, false)
	image:setVisible(unit_overlay, false)
	image:setVisible(unit_icon_1, false)
	image:setVisible(unit_icon_2, false)
	image:setVisible(end_move,false)
	image:setVisible(mm_bttn, false)
	gui:dropPosMarkers( )
end

function gui:returnSelection( )
	return gui.selection
end