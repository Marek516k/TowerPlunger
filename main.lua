love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
PathData = require("TowerUpgrades")
loadStuff = require("Stuff to load")
mouse = require("mys")
LevelLogic = require("LevelLogic")

function love.load()
    loadStuff()
    LevelLogic.loadLevel()
    waveButton = { x = 920, y = 30, w = 200, h = 80 }
end

function love.update(dt)
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
                local target = findNearestTargetForTower(tower)

                if target then
                    local projectile = createProjectile(
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
        updateProjectiles(dt)
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

function love.draw()
    if GameState == "select" then
        LevelLogic.DrawLevelSel()
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

    if GameState == "menu" then
        love.graphics.setColor(0.1, 0.1, 0.2, 1)
        love.graphics.rectangle("fill", 0, 0, ww, wh)

        local title = "TOWER PLUNGER"
        local titleScale = 2 + math.sin(love.timer.getTime() * 2) * 0.1

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.print(title, FontLarge, ww/2 - FontLarge:getWidth(title) * titleScale/2 + 4, 100 + 4, 0, titleScale, titleScale)
        love.graphics.setColor(0.2, 0.8, 1, 1)
        love.graphics.print(title, FontLarge, ww/2 - FontLarge:getWidth(title) * titleScale/2, 100, 0, titleScale, titleScale)

        local button_width = ww * (1/3)
        local Button_height = wh * (1/12)
        local margin = 20
        local Total_height = (Button_height + margin) * #Buttons
        local cursor_y = 0

        for i, Button in ipairs(Buttons) do
            Button.last = Button.now
            local bx = (ww * 0.5 ) - (button_width * 0.5)
            local by = (wh * 0.5) - (Total_height * 0.5) + cursor_y + 100
            local mx, my = love.mouse.getPosition()
            local hot = mx > bx and mx < bx + button_width and my > by and my < by + Button_height

            if hot then
                Button.hover = math.min(1, Button.hover + 0.1)
            else
                Button.hover = math.max(0, Button.hover - 0.1)
            end

            local scale = 1 + Button.hover * 0.05
            local offsetX = (button_width - button_width * scale) / 2
            local offsetY = (Button_height - Button_height * scale) / 2

            love.graphics.setColor(0, 0, 0, 0.4)
            love.graphics.rectangle("fill", bx + 4, by + 4, button_width, Button_height, 10, 10)

            local r, g, b = 0.2 + Button.hover * 0.3, 0.5 + Button.hover * 0.5, 0.8
            love.graphics.setColor(r, g, b, 1)
            love.graphics.rectangle("fill", bx + offsetX, by + offsetY, button_width * scale, Button_height * scale, 10, 10)
            love.graphics.setColor(0.4 + Button.hover * 0.4, 0.7 + Button.hover * 0.3, 1, 1)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", bx + offsetX, by + offsetY, button_width * scale, Button_height * scale, 10, 10)

            Button.now = love.mouse.isDown(1)

            if Button.now and not Button.last and hot then
                Button.fn()
            end

            love.graphics.setColor(1, 1, 1, 1)

            local tetxW = Font:getWidth(Button.text)
            local textH = Font:getHeight(Button.text)

            love.graphics.print(Button.text, Font, bx + button_width/2 - tetxW/2, by + Button_height/2 - textH/2)
            cursor_y = cursor_y + (Button_height + margin)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    if GameState == "building" then
            love.graphics.setColor(0, 0.8, 0.2)
            love.graphics.rectangle("fill", waveButton.x, waveButton.y, waveButton.w, waveButton.h, 12)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf("Start Wave", waveButton.x, waveButton.y + 25, waveButton.w, "center")
    end

    if GameState == "building" or GameState == "wave" then
        local shopX = ww - 270
        local shopY = 80
        local shopW = 240
        local buttonH = 110
        local marginS = 15
        local cursorS_y = 0
        local mx, my = love.mouse.getPosition()

        love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
        love.graphics.rectangle("fill", shopX - 10, shopY - 30, shopW + 20, (#Shop * (buttonH + marginS)) + 40, 15, 15)
        love.graphics.setColor(0.3, 0.7, 1, 1)
        love.graphics.print("TOWER SHOP", Font, shopX + 30, shopY - 20)
        love.graphics.setColor(1, 1, 1, 1)

        for i, Button in ipairs(Shop) do
            Button.last = Button.now
            local bx = shopX
            local by = shopY + cursorS_y
            local hot = mx > bx and mx < bx + shopW and my > by and my < by + buttonH

            if hot then
                Button.hover = math.min(1, Button.hover + 0.1)
            else
                Button.hover = math.max(0, Button.hover - 0.1)
            end

            local scale = 1 + Button.hover * 0.03
            local offsetX = (shopW - shopW * scale) / 2
            local offsetY = (buttonH - buttonH * scale) / 2

            love.graphics.setColor(0, 0, 0, 0.3)
            love.graphics.rectangle("fill", bx + 3, by + 3, shopW, buttonH, 8, 8)

            love.graphics.setColor(0.25 + Button.hover * 0.15, 0.25 + Button.hover * 0.15, 0.35 + Button.hover * 0.1, 1)
            love.graphics.rectangle("fill", bx + offsetX, by + offsetY, shopW * scale, buttonH * scale, 8, 8)

            if hot then
                love.graphics.setColor(0.4, 0.7, 1, 0.2)
                love.graphics.rectangle("fill", bx + offsetX, by + offsetY, shopW * scale, buttonH * scale, 8, 8)
            end

            love.graphics.setColor(0.4 + Button.hover * 0.3, 0.5 + Button.hover * 0.3, 0.7, 1)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", bx + offsetX, by + offsetY, shopW * scale, buttonH * scale, 8, 8)
            love.graphics.setColor(1, 1, 1, 1)

            if Button.image then
                love.graphics.draw(Button.image, bx + 15, by + 15, 0, 0.6, 0.6)
            end

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(Button.text, FontSmall, bx + 90, by + 45)
            Button.now = love.mouse.isDown(1)

            if Button.now and not Button.last and hot then
                Button.fn(Button)
            end
            cursorS_y = cursorS_y + (buttonH + marginS)
        end

        love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
        love.graphics.rectangle("fill", 5, 5, 250, 170, 10, 10)

        love.graphics.setColor(0.3, 0.7, 1, 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", 5, 5, 250, 170, 10, 10)
        love.graphics.setColor(1, 0.9, 0.3, 1)
        love.graphics.print("Money: $" .. Money, Font, 15, 15)

        local healthColor = {1 - (100 - Health) / 100, Health / 100, 0, 1}
        love.graphics.setColor(healthColor)
        love.graphics.print("Health: " .. Health, Font, 15, 50)

        love.graphics.setColor(0.5, 1, 0.5, 1)
        love.graphics.print("Wave: " .. CurrentWave, Font, 15, 85)

        love.graphics.setColor(1, 0.5, 0.5, 1)
        love.graphics.print("Enemies: " .. EnemiesAlive, Font, 15, 120)

        love.graphics.setColor(1, 1, 1, 1)
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

        love.graphics.print(subText, Font, ww/2 - subW/2, wh/2 + textH)
        love.graphics.setColor(1, 1, 1, 1)
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

            if dist < 41 and love.mouse.isDown(1) then
                TWdata = tw
                ShowUpgradeUI = true
            elseif love.mouse.isDown(2) then
                ShowUpgradeUI = false
            end
        end
    end

    if GameState == "wave" then
        LevelLogic.DrawEnemies()
    end

    if ShowUpgradeUI and TWdata and (GameState == "wave" or GameState == "building") and Bought == false then
        DrawTowerUpgrades(TWdata)
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

function DrawTowerUpgrades(tower)
    love.graphics.setColor(0.3, 0.7, 1, 0.15)
    love.graphics.circle("fill", tower.x, tower.y, tower.range)
    love.graphics.setColor(0.3, 0.7, 1, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", tower.x, tower.y, tower.range)
    love.graphics.setColor(1, 1, 1, 1)

    local Font2 = love.graphics.newFont(18)
    local FontStats = love.graphics.newFont(14)

    local statsWidth = 180
    local statsHeight = 200
    local statsX = tower.x - statsWidth - 100
    local statsY = tower.y - statsHeight/2

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", statsX, statsY, statsWidth, statsHeight, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", statsX, statsY, statsWidth, statsHeight, 10, 10)

    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.print("TOWER STATS", Font2, statsX + 35, statsY + 10)

    love.graphics.setColor(0.3, 0.7, 1, 0.5)
    love.graphics.setLineWidth(1)
    love.graphics.line(statsX + 10, statsY + 35, statsX + statsWidth - 10, statsY + 35)

    love.graphics.setColor(1, 1, 1, 1)
    local statY = statsY + 45
    local lineHeight = 22

    local towerData = tower.tower

    love.graphics.setColor(1, 0.5, 0.5, 1)
    love.graphics.print("Damage:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(towerData.dmg), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    love.graphics.setColor(0.5, 1, 0.5, 1)
    love.graphics.print("Fire Rate:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(string.format("%.1f/s", towerData.firerate), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    love.graphics.setColor(0.5, 0.5, 1, 1)
    love.graphics.print("Range:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(tower.range), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    love.graphics.setColor(1, 1, 0.5, 1)
    love.graphics.print("Pierce:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(towerData.pierce), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    if towerData.splashRadius and towerData.splashRadius > 0 then
        love.graphics.setColor(1, 0.5, 1, 1)
        love.graphics.print("Splash:", FontStats, statsX + 15, statY)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(tostring(towerData.splashRadius), FontStats, statsX + statsWidth - 50, statY)
        statY = statY + lineHeight
    end

    if towerData.traits and #towerData.traits > 0 then
        love.graphics.setColor(0.7, 0.7, 1, 1)
        love.graphics.print("Traits:", FontStats, statsX + 15, statY)
        statY = statY + 18
        love.graphics.setColor(0.9, 0.9, 0.9, 1)
        for _, trait in ipairs(towerData.traits) do
            love.graphics.print("- " .. trait, FontStats, statsX + 25, statY)
            statY = statY + 16
        end
    end

    local button_width = ww * (1/7)
    local Button_height = wh * (1/25)
    local margin = 15
    local Total_height = (Button_height + margin) * #UpgradeButtons
    local cursor_y = 0

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", tower.x + 90, tower.y - Total_height/2 - 30, button_width + 60, Total_height + 60, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", tower.x + 90, tower.y - Total_height/2 - 30, button_width + 60, Total_height + 60, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.print("UPGRADES", Font2, tower.x + 120, tower.y - Total_height/2 - 20)
    love.graphics.setColor(1, 1, 1, 1)

    for i, Button in ipairs(UpgradeButtons) do
        Button.last = Button.now
        local bx = (tower.x + 120)
        local by = (tower.y) - (Total_height * 0.5) + cursor_y

        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + Button_height

        if hot then
            Button.hover = math.min(1, Button.hover + 0.1)
        else
            Button.hover = math.max(0, Button.hover - 0.1)
        end

        local scale = 1 + Button.hover * 0.05
        local offsetX = (button_width - button_width * scale) / 2
        local offsetY = (Button_height - Button_height * scale) / 2

        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.rectangle("fill", bx + 2, by + 2, button_width, Button_height, 5, 5)

        local r = 0.2 + Button.hover * 0.5
        local g = 0.6 + Button.hover * 0.4
        local b = 0.3 + Button.hover * 0.5

        love.graphics.setColor(r, g, b, 1)
        love.graphics.rectangle("fill", bx + offsetX, by + offsetY, button_width * scale, Button_height * scale, 5, 5)
        love.graphics.setColor(0.4 + Button.hover * 0.4, 0.8 + Button.hover * 0.2, 0.5 + Button.hover * 0.5, 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", bx + offsetX, by + offsetY, button_width * scale, Button_height * scale, 5, 5)

        Button.now = love.mouse.isDown(1)

        if Button.now and not Button.last and hot then
            Button.fn()
        end

        love.graphics.setColor(1, 1, 1, 1)

        local tetxW = Font2:getWidth(Button.text)
        local textH = Font2:getHeight(Button.text)

        love.graphics.print(Button.text, Font2, bx + button_width/2 - tetxW/2, by + Button_height/2 - textH/2)
        cursor_y = cursor_y + (Button_height + margin)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function love.keypressed(key,x,y,button)
    if key == "escape" and (GameState == "building" or GameState == "wave") then
        GameState = "menu"
        ShowUpgradeUI = false
        TWdata = nil
    end
end

function deepCopyTower(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" and k ~= "image" then
            copy[k] = deepCopyTower(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function love.mousepressed(x, y, button,istouch,presses)
    if GameState == "building" then
        if x >= waveButton.x and x <= waveButton.x + waveButton.w and y >= waveButton.y and y <= waveButton.y + waveButton.h and button == 1 then
            LevelLogic.startWave()
            GameState = "wave"
        end
    end

    if GameState == "select" then
        LevelLogic.CheckLevelSelectorClick(x, y, button)
    end

    mouse(x, y, button)
end

function findNearestTargetForTower(tower)
    local bestEnemy = nil
    local bestDist = math.huge
    local tx = tower.x
    local ty = tower.y

    for _, enemy in ipairs(EnemiesOnMap) do
        local enemyWidth = enemy.image:getWidth()
        local enemyHeight = enemy.image:getHeight()
        local ex = enemy.x + enemyWidth / 2
        local ey = enemy.y + enemyHeight / 2
        local dx = ex - tx
        local dy = ey - ty
        local dist = math.sqrt(dx*dx + dy*dy)

        if dist <= (tower.range) and dist < bestDist then
            bestDist = dist
            bestEnemy = {x = ex, y = ey, enemy = enemy}
        end
    end

    if bestEnemy then
        local dx = bestEnemy.x - tx
        local dy = bestEnemy.y - ty
        tower.rotation = math.atan2(dy, dx)
        tower.target = bestEnemy
        return bestEnemy
    else
        tower.target = nil
        return nil
    end
end

function createProjectile(startX, startY, targetX, targetY, speed, damage, pierce, splashRadius,traits)
    local dx = targetX - startX
    local dy = targetY - startY
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance == 0 then
        distance = 1
    end

    local dirX = dx / distance
    local dirY = dy / distance

    return {
        x = startX,
        y = startY,
        vx = dirX * speed,
        vy = dirY * speed,
        radius = 3,
        alive = true,
        damage = damage,
        pierce = pierce,
        hitCount = 0,
        splashRadius = splashRadius,
        traits = traits
    }
end

function updateProjectiles(dt)
    updateSlowEffects(dt)

    for i = #Bullets, 1, -1 do
        local proj = Bullets[i]

        if not proj.alive then
            table.remove(Bullets, i)
        else
            proj.x = proj.x + proj.vx * dt
            proj.y = proj.y + proj.vy * dt

            if proj.x < -50 or proj.x > love.graphics.getWidth() + 50 or
               proj.y < -50 or proj.y > love.graphics.getHeight() + 50 then
                proj.alive = false
                table.remove(Bullets, i)
            else
                processProjectileCollisions(proj)

                if proj.hitCount > proj.pierce then
                    proj.alive = false
                    table.remove(Bullets, i)
                end
            end
        end
    end
end

function updateSlowEffects(dt)
    for i = 1, #EnemiesOnMap do
        local enemy = EnemiesOnMap[i]

        if enemy.slowDuration and enemy.slowDuration > 0 then
            enemy.slowDuration = enemy.slowDuration - dt

            if enemy.slowDuration <= 0 then
                enemy.speed = enemy.originalSpeed
                enemy.slowDuration = nil
                enemy.originalSpeed = nil
            end
        end
    end
end

function processProjectileCollisions(proj)
    local canDetectHidden = hasProjectileTrait(proj, "detection")
    local hasSlow = hasProjectileTrait(proj, "slow")

    for j = #EnemiesOnMap, 1, -1 do
        local enemy = EnemiesOnMap[j]

        if checkProjectileHit(proj, enemy) then
            local damageDealt = calculateDamage(proj, enemy, canDetectHidden)

            if damageDealt > 0 then
                enemy.health = enemy.health - damageDealt
                proj.hitCount = proj.hitCount + 1

                for i = 1, 5 do
                    createParticle(proj.x, proj.y, {1, 0.3, 0, 1})
                end

                if hasSlow then
                    applySlowEffect(enemy)
                end

                if proj.splashRadius > 0 then
                    processSplashDamage(proj, enemy, hasSlow)
                end
            end

            if enemy.health <= 0 then
                Money = Money + enemy.reward
                EnemiesAlive = math.max(0, EnemiesAlive - 1)
                for i = 1, 12 do
                    createParticle(enemy.x + 32, enemy.y + 32, {1, 1, 0.3, 1})
                end
                table.remove(EnemiesOnMap, j)
            end
            break
        end
    end
end

function hasProjectileTrait(proj, trait)
    for i = 1, #proj.traits do
        if proj.traits[i] == trait then
            return true
        end
    end
    return false
end

function checkProjectileHit(proj, enemy)
    local enemyWidth = enemy.image:getWidth()
    local enemyHeight = enemy.image:getHeight()
    local enemyCenterX = enemy.x + enemyWidth / 2
    local enemyCenterY = enemy.y + enemyHeight / 2
    local dx = proj.x - enemyCenterX
    local dy = proj.y - enemyCenterY
    local distance = math.sqrt(dx * dx + dy * dy)
    local hitRadius = proj.radius + math.min(enemyWidth, enemyHeight) / 2

    return distance <= hitRadius
end

function calculateDamage(proj, enemy, canDetectHidden)
    if enemy.traits == "hidden" and not canDetectHidden then
        return 0
    elseif enemy.traits == "armored" then
        return proj.damage * 0.85
    else
        return proj.damage
    end
end

function applySlowEffect(enemy)
    if not enemy.originalSpeed then
        enemy.originalSpeed = enemy.speed
    end
    enemy.speed = enemy.originalSpeed * 0.8
    enemy.slowDuration = 3.0
end

function processSplashDamage(proj, targetEnemy, hasSlow)
    local targetWidth = targetEnemy.image:getWidth()
    local targetHeight = targetEnemy.image:getHeight()
    local targetCenterX = targetEnemy.x + targetWidth / 2
    local targetCenterY = targetEnemy.y + targetHeight / 2

    for k = #EnemiesOnMap, 1, -1 do
        local splashEnemy = EnemiesOnMap[k]

        if splashEnemy ~= targetEnemy then
            local splashWidth = splashEnemy.image:getWidth()
            local splashHeight = splashEnemy.image:getHeight()
            local splashCenterX = splashEnemy.x + splashWidth / 2
            local splashCenterY = splashEnemy.y + splashHeight / 2
            local dx = targetCenterX - splashCenterX
            local dy = targetCenterY - splashCenterY
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance <= proj.splashRadius then
                splashEnemy.health = splashEnemy.health - proj.damage

                if hasSlow then
                    applySlowEffect(splashEnemy)
                end

                if splashEnemy.health <= 0 then
                    Money = Money + splashEnemy.reward
                    EnemiesAlive = math.max(0, EnemiesAlive - 1)
                    table.remove(EnemiesOnMap, k)
                end
            end
        end
    end
end

--TODO:
-- fix the bugs finally man
-- really refactor the code a bit
-- make the font correct size for everithing
-- Balancing game difficulty and economy
-- Add sound effects and music
-- bug fixes if there are any to fix
-- user feedback stuff