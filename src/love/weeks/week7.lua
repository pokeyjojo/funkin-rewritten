	local stageBack, stageFront, curtains

return {
	enter = function(self)
		weeks:enter()

stageBack = Image(love.graphics.newImage(graphics.imagePath("week7/whittyBack")))
		stageFront = Image(love.graphics.newImage(graphics.imagePath("week7/whittyFront")))
	
		
		stageFront.y = 400
		
		enemy = love.filesystem.load("sprites/week1/daddy-dearest.lua")()
		
		girlfriend.x, girlfriend.y = 30, -90
		enemy.x, enemy.y = -380, -110
		boyfriend.x, boyfriend.y = 260, 100
		
		enemyIcon:animate("daddy dearest", false)
		
		self:load()
	end,
	
	load = function(self)
		weeks:load()
		
		if songNum == 3 then
			inst = love.audio.newSource("music/week7/ballistic-inst.ogg", "stream")
			voices = love.audio.newSource("music/week7/ballistic-voices.ogg", "stream")
		elseif songNum == 2 then
			inst = love.audio.newSource("music/week7/overhead-inst.ogg", "stream")
			voices = love.audio.newSource("music/week7/overhead-voices.ogg", "stream")
		else
			inst = love.audio.newSource("music/week7/lo-fight-inst.ogg", "stream")
			voices = love.audio.newSource("music/week7/lo-fight-voices.ogg", "stream")
		end
		
		self:initUI()
		
		inst:play()
		weeks:voicesPlay()
	end,
	
	initUI = function(self)
		weeks:initUI()
		
		if songNum == 3 then
			weeks:generateNotes(love.filesystem.load("charts/week7/ballistic" .. songAppend .. ".lua")())
		elseif songNum == 2 then
			weeks:generateNotes(love.filesystem.load("charts/week7/overhead" .. songAppend .. ".lua")())
		else
			weeks:generateNotes(love.filesystem.load("charts/week7/lo-fight" .. songAppend .. ".lua")())
		end
	end,
	
	update = function(self, dt)
		if gameOver then
			if not graphics.isFading then
				if input:pressed("confirm") then
					inst:stop()
					inst = love.audio.newSource("music/game-over-end.ogg", "stream")
					inst:play()
					
					Timer.clear()
					
					cam.x, cam.y = -boyfriend.x, -boyfriend.y
					
					boyfriend:animate("dead confirm", false)
					
					graphics.fadeOut(3, function() self:load() end)
				elseif input:pressed("gameBack") then
					graphics.fadeOut(0.5, function() Gamestate.switch(menu) end)
				end
			end
			
			boyfriend:update(dt)
			
			return
		end
		
		weeks:update(dt)
		
		
		end
		
		if health >= 80 then
			if enemyIcon.anim.name == "daddy dearest" then
				enemyIcon:animate("daddy dearest losing", false)
			end
		else
			if enemyIcon.anim.name == "daddy dearest losing" then
				enemyIcon:animate("daddy dearest", false)
			end
		end
		
		if not graphics.isFading and not inst:isPlaying() and not voices:isPlaying() then
			if storyMode and songNum < 3 then
				songNum = songNum + 1
				
				self:load()
			else
				graphics.fadeOut(0.5, function() Gamestate.switch(menu) end)
			end
		end
		
		weeks:updateUI(dt)
	end,
	
	draw = function(self)
		weeks:draw()
		
		if gameOver then return end
		
		love.graphics.push()
			love.graphics.translate(lovesize.getWidth() / 2, lovesize.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)
			
			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)
				
				stageBack:draw()
				stageFront:draw()
				
				girlfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)
				
				enemy:draw()
				boyfriend:draw()
			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)
				
				
			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()
		
		weeks:drawUI()
	end,
	
	leave = function(self)
		stageBack = nil
		stageFront = nil
		curtains = nil
		
		weeks:leave()
	end
}
