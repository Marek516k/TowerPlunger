love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
PathData = require("TowerUpgrades")
loadStuff = require("Stuff to load")
mouse = require("mys")
LevelLogic = require("LevelLogic")
Menu = require("Menu")
DrawT_ups = require("UpgradeLogic").DrawT_ups
utilities = require("InfoStuff")
TowerLogic = require("TowerLogic")

function love.load()
    GameState = "menu"
    loadStuff()
    LevelLogic.loadLevel()
end

function love.update(dt)
    if GameState == "building" then
        UpdateCountdown(dt)
    end

    if UIAlpha < 1 then
        UIAlpha = math.min(1, UIAlpha + dt * 2)
    end

    if WaveTransition > 0 then
        WaveTransition = math.max(0, WaveTransition - dt * 2)
    end

    if ShakeAmount > 0 then
        ShakeAmount = math.max(0, ShakeAmount - dt * 5)
    end

    for i = #Particles, 1, -1 do
        local p = Particles[i]
        p.life = p.life - dt
        if p.life <= 0 then
            table.remove(Particles, i)
        else
            p.x = p.x + p.vx * dt
            p.y = p.y + p.vy * dt
            p.alpha = p.life / p.maxLife
        end
    end

    for i = #Explosions, 1, -1 do
        local e = Explosions[i]
        e.life = e.life - dt
        if e.life <= 0 then
            table.remove(Explosions, i)
        else
            local t = 1 - (e.life / e.maxLife)
            e.radius = e.maxRadius * t
        end
    end


    if GameState == "wave" then
        LevelLogic.Enemyupdate(dt)
    end

    if GameState == "wave" then
        for _, tower in ipairs(TowersOnMap) do
            tower.lastShot = (tower.lastShot) + dt
            local towerData = tower.tower
            local fireRate = towerData.firerate
            local projectileSpeed = towerData.projectileSpeed

            if tower.lastShot >= (1 / fireRate) then
                local target = TowerLogic.findNearestTargetForTower(tower)

                if target then
                    local projectile = TowerLogic.createProjectile(
                        tower.x, tower.y,
                        target.x, target.y,
                        projectileSpeed,
                        towerData.dmg,
                        towerData.pierce,
                        towerData.splashRadius,
                        towerData.traits
                    )
                    table.insert(Bullets, projectile)
                    tower.lastShot = 0
                    tower.shootFlash = 0.2
                end
            end

            if tower.shootFlash and tower.shootFlash > 0 then
                tower.shootFlash = tower.shootFlash - dt
            end
        end
        TowerLogic.updateProjectiles(dt)
    end
end

function createParticle(x, y, color)
    table.insert(Particles, {
        x = x,
        y = y,
        vx = (math.random() - 0.5) * 100,
        vy = (math.random() - 0.5) * 100 - 50,
        life = 0.5,
        maxLife = 0.5,
        color = color or {1, 0.8, 0, 1},
        alpha = 1
    })
end

function createExplosion(x, y, radius)
    table.insert(Explosions, {
        x = x,
        y = y,
        radius = 0,
        maxRadius = radius * 0.9,
        life = 0.4,
        maxLife = 0.4,
    })
end


function DrawCountdown()
    local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()
    local secondsLeft = math.ceil(autoWaveTimer)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("The wave starts in " .. secondsLeft, 0, wh/2 - 40, ww, "center")
end

function love.draw()
    local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

    if GameState == "select" then
        LevelLogic.DrawLevelSel()
    end

    if GameState == "menu" then
        Menu()
    end

    if Victory then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, ww, wh)
        love.graphics.setColor(0, 1, 0.3, 1)

        local text = "VICTORY!"
        local textW = FontLarge:getWidth(text)
        local textH = FontLarge:getHeight(text)
        love.graphics.print(text, FontLarge, ww/2 - textW/2, wh/2 - textH/2)

        love.graphics.setColor(1, 1, 1, 0.8)
        local subText = "All waves cleared!"
        local subW = Font:getWidth(subText)
        love.graphics.print(subText, Font, ww/2 - subW/2, wh/2 + textH)
        love.graphics.setColor(1, 1, 1, 1)

        local mx, my = love.mouse.getPosition()
        local isHovered = mx > VictoryButton.x and mx < VictoryButton.x + VictoryButton.w and my > VictoryButton.y and my < VictoryButton.y + VictoryButton.h

        if isHovered then
            love.graphics.setColor(0, 0.9, 0.4)
        else
            love.graphics.setColor(0, 0.8, 0.15)
        end

        love.graphics.rectangle("fill", VictoryButton.x, VictoryButton.y, VictoryButton.w, VictoryButton.h, 12, 12)
        love.graphics.setColor(0, 0.5, 0.1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", VictoryButton.x, VictoryButton.y, VictoryButton.w, VictoryButton.h, 12, 12)

        love.graphics.setColor(0, 0, 0)
        local btnText = "Return to Menu"
        local font = love.graphics.getFont()
        local textHeight = font:getHeight()
        local textY = VictoryButton.y + (VictoryButton.h - textHeight) / 2
        love.graphics.printf(btnText, VictoryButton.x, textY, VictoryButton.w, "center")
        return
    end

    if ShakeAmount > 0 then
        love.graphics.push()
        love.graphics.translate(
            (math.random() - 0.5) * ShakeAmount * 20,
            (math.random() - 0.5) * ShakeAmount * 20
        )
    end

    if GameState == "building" or GameState == "wave" then
        LevelLogic.drawMap()
    end

    for _, e in ipairs(Explosions) do
        local alpha = e.life / e.maxLife
        love.graphics.setColor(1, 0.5, 0, alpha * 0.3)
        love.graphics.circle("fill", e.x, e.y, e.radius)
        love.graphics.setColor(1, 0.9, 0.4, alpha * 0.4)
        love.graphics.circle("line", e.x, e.y, e.radius * 0.8)
    end
    love.graphics.setColor(1, 1, 1, 1)

    if GameState == "building" then
        love.graphics.setColor(0, 0.8, 0.2)
        love.graphics.rectangle("fill", waveButton.x, waveButton.y, waveButton.w, waveButton.h, 12)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Start Wave", waveButton.x, waveButton.y + 25, waveButton.w, "center")

        if autoWaveTimer < 5 then
            DrawCountdown()
        end
    end

    if GameState == "building" or GameState == "wave" then
        utilities()
    end

    if GameState == "wave" or GameState == "building" then
        for _, proj in ipairs(Bullets) do
            if proj.alive then
                love.graphics.setColor(0, 0.5, 0, 0.3)
                love.graphics.circle("fill", proj.x, proj.y, proj.radius * 2.5)
                love.graphics.setColor(0, 1, 0, 1)
                love.graphics.circle("fill", proj.x, proj.y, proj.radius)
            end
        end
        love.graphics.setColor(1, 1, 1, 1)

        for _, p in ipairs(Particles) do
            love.graphics.setColor(p.color[1], p.color[2], p.color[3], p.alpha * 0.8)
            love.graphics.circle("fill", p.x, p.y, 4)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    if GameState == "gameover" then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, ww, wh)
        love.graphics.setColor(1, 0, 0, 1)

        local text = "GAME OVER"
        local textW = FontLarge:getWidth(text)
        local textH = FontLarge:getHeight(text)

        love.graphics.print(text, FontLarge, ww/2 - textW/2, wh/2 - textH/2)
        love.graphics.setColor(1, 1, 1, 0.8)

        local subText = "Wave " .. CurrentWave .. " reached"
        local subW = Font:getWidth(subText)
        local subH = Font:getHeight(subText)

        love.graphics.print(subText, Font, ww/2 - subW/2, wh/2 + textH)
        love.graphics.setColor(1, 1, 1, 1)

        local mx, my = love.mouse.getPosition()
        local isHovered = mx > GameOverButton.x and mx < GameOverButton.x + GameOverButton.w and my > GameOverButton.y and my < GameOverButton.y + GameOverButton.h

        if isHovered then
            love.graphics.setColor(0, 0.9, 0.4)
        else
            love.graphics.setColor(0, 0.8, 0.15)
        end

        love.graphics.rectangle("fill", GameOverButton.x, GameOverButton.y, GameOverButton.w, GameOverButton.h, 12, 12)

        love.graphics.setColor(0, 0.5, 0.1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", GameOverButton.x, GameOverButton.y, GameOverButton.w, GameOverButton.h, 12, 12)

        love.graphics.setColor(0, 0, 0)
        local text2 = "Return to Menu"
        local font = love.graphics.getFont()
        local textHeight = font:getHeight()
        local textY = GameOverButton.y + (GameOverButton.h - textHeight) / 2
        love.graphics.printf(text2, GameOverButton.x, textY, GameOverButton.w, "center")
    end

    if GameState == "wave" or GameState == "building" then
        if Bought and not Placed and SelectedTower and SelectedTower.image then
            local mx, my = love.mouse.getPosition()
            love.graphics.setColor(1, 1, 1, 0.6)
            love.graphics.draw(SelectedTower.image, mx, my, 0, 1, 1, SelectedTower.image:getWidth()/2, SelectedTower.image:getHeight()/2)
            love.graphics.setColor(0.3, 0.7, 1, 0.2)

            love.graphics.circle("fill", mx, my, SelectedTower.range)
            love.graphics.setColor(0.3, 0.7, 1, 0.5)

            love.graphics.setLineWidth(2)
            love.graphics.circle("line", mx, my, SelectedTower.range)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if GameState == "wave" or GameState == "building" then
        for _, tw in ipairs(TowersOnMap) do
            local ox = tw.image:getWidth() / 2
            local oy = tw.image:getHeight() / 2

            if tw.shootFlash and tw.shootFlash > 0 then
                love.graphics.setColor(1, 1, 0, tw.shootFlash * 2)
                love.graphics.circle("fill", tw.x, tw.y, 30)
            end

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(tw.image, tw.x, tw.y, tw.rotation or 0, 1, 1, ox, oy)

            local mx, my = love.mouse.getPosition()
            local dist = math.sqrt((mx - tw.x)^2 + (my - tw.y)^2)

            if love.mouse.isDown(1) then
                if dist < 41 and not ShowUpgradeUI and not AnotherMenuOpen then
                    TWdata = tw
                    ShowUpgradeUI = true
                    AnotherMenuOpen = true
                end
            elseif love.mouse.isDown(2) then
                ShowUpgradeUI = false
                AnotherMenuOpen = false
                TWdata = nil
            end
        end
    end

    if GameState == "wave" then
        LevelLogic.DrawEnemies()
    end

    if ShowUpgradeUI and TWdata and (GameState == "wave" or GameState == "building") and not Bought then
        AnotherMenuOpen = true
        DrawT_ups(TWdata)
    else
        if not ShowUpgradeUI then
            AnotherMenuOpen = false
        end
    end

    if WaveTransition > 0 then
        love.graphics.setColor(0.2, 0.5, 1, WaveTransition * 0.3)
        love.graphics.rectangle("fill", 0, 0, ww, wh)

        local waveText = "WAVE " .. CurrentWave
        local scale = 2 * WaveTransition

        love.graphics.setColor(1, 1, 1, WaveTransition)
        local textW = FontLarge:getWidth(waveText)

        love.graphics.print(waveText, FontLarge, ww/2 - textW * scale/2, wh/2 - 50, 0, scale, scale)
        love.graphics.setColor(1, 1, 1, 1)
    end

    if ShakeAmount > 0 then
        love.graphics.pop()
    end
end

function love.keypressed(key,x,y,button)
    if key == "escape" and (GameState == "building" or GameState == "wave") then
        GameState = "menu"
        ShowUpgradeUI = false
        TWdata = nil
    end
end

function love.mousepressed(x, y, button,istouch,presses)
    if Victory then
        if x >= VictoryButton.x and x <= VictoryButton.x + VictoryButton.w and y >= VictoryButton.y and y <= VictoryButton.y + VictoryButton.h and button == 1 then
            GameState = "select"
            Victory = false
            GameStarted = false
            loadStuff()
            return
        end
    end

    if GameState == "building" then
        if x >= waveButton.x and x <= waveButton.x + waveButton.w and y >= waveButton.y and y <= waveButton.y + waveButton.h and button == 1 then
            LevelLogic.startWave()
            GameState = "wave"
        end
    end

    if GameState == "gameover" then
        if x >= GameOverButton.x and x <= GameOverButton.x + GameOverButton.w and y >= GameOverButton.y and y <= GameOverButton.y + GameOverButton.h and button == 1 then
            GameStarted = false
            loadStuff()
            GameState = "menu"
        end
    end

    if GameState == "select" then
        LevelLogic.CheckLevelSelectorClick(x, y, button)
    end

    mouse(x, y, button)
end

function UpdateCountdown(dt)
    autoWaveTimer = autoWaveTimer - dt

    if autoWaveTimer <= 0 then
        startWave()
    end
end

--TODO:
-- fix tower hitting hidden enemies when they shouldn't be able to, wave button appearing after u close menu is a mistake
-- pictures and sound effects and music
-- Balancing game difficulty and economy
-- bug fixes if there are any to fix
-- user feedback stuff