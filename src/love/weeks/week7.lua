local stageBack, stageFront, ballisticStage, ballisticEffect

return {
	enter = function(self)
		weeks:enter()
		
		enemy = love.filesystem.load("sprites/week7/Whitty.lua")()
		enemy.x, enemy.y = -380, -50

		stageBack = Image(love.graphics.newImage(graphics.imagePath("week7/whittyBack")))
		stageFront = Image(love.graphics.newImage(graphics.imagePath("week7/whittyFront")))
		stageFront.y = 400

		girlfriend = love.filesystem.load("sprites/week7/girlfriend-sway.lua")()
		girlfriend.x, girlfriend.y = 30, 0
		boyfriend.x, boyfriend.y = 260, 100
		
		if songNum == 3 then
			enemyIcon:animate("crazy whitty", false)
		else
			enemyIcon:animate("whitty", false)
		end

		self:load()
	end,
	
	load = function(self)
		weeks:load()
		
		if songNum == 3 then
			ballisticStage = love.filesystem.load("sprites/week7/street-ballistic.lua")()
			ballisticEffect = Image(love.graphics.newImage(graphics.imagePath("week7/red")))
			ballisticEffect.x, ballisticEffect.y = cam.x, cam.y

			enemy = love.filesystem.load("sprites/week7/WhittyCrazy.lua")()
			enemy.x, enemy.y = -450, -50
			
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
		if songNum == 3 then
			ballisticStage:update(dt)
						
			if ballisticStage.anim.name ~= "moving" then 
				ballisticStage:animate("moving", true)
			end
		end

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

		if girlfriend.anim.name == "idle" then
			girlfriend.anim.speed = 6 / (60 / bpm)
		end

		if songNum == 3 and girlfriend.anim.name ~= "scared" then
			girlfriend:animate("scared", true)
		end
				
		if health >= 80 then
			if songNum == 3 and enemyIcon.anim.name == "crazy whitty" then
				enemyIcon:animate("crazy whitty losing", false)
			elseif enemyIcon.anim.name == "whitty" then
				enemyIcon:animate("whitty losing", false)
			end
		else
			if songNum == 3 and enemyIcon.anim.name == "crazy whitty losing" then
				enemyIcon:animate("crazy whitty", false)
			elseif enemyIcon.anim.name == "whitty losing" then
				enemyIcon:animate("whitty", false)
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
				
				if songNum == 3 then
					ballisticStage:draw()
					ballisticEffect:draw()
				else
					stageBack:draw()
					stageFront:draw()
				end

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
		ballisticStage = nil
		
		weeks:leave()
		
	end
	}