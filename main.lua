love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
Level1 = require("GameLevels.Level1")
PathData = require("TowerUpgrades")
local Map1 = Level1.Map1
local Flags = Level1.Flags

function WaveShi()
    local waveKey = "wave" .. tostring(CurrentWave)
    local waveData = Level1[waveKey]
    if not waveData or not waveData.enemies then
        PendingSpawns = {}
        Spawning = false
        return
    end

    for _, EnemyInfo in ipairs(waveData.enemies) do
        for i = 1, EnemyInfo.count do
            table.insert(PendingSpawns, {
                type = EnemyInfo.type
            })
        end
    end

    Spawning = true
    EnemyspawnTimer = 0
end

function love.load()
    PendingSpawns = {}
    Grass = {}
    Path = {}
    Bullets = {}
    Buttons = {}
    UpgradeButtons = {}
    Shop = {}
    TowersOnMap = {}
    EnemiesOnMap = {}
    TWdata = {}
    SelectedTower = nil
    SelectedTowerForUpgrade = nil
    Map1 = _G.Map1
    Flags = _G.Flags

    if Map1 then
        for y,row in ipairs(Map1) do
            for x = 1, #row do
                local tile = row:sub(x,x)
                if tile == "#" then
                    table.insert(Grass, { x = x, y = y })
                elseif tile == "." then
                    table.insert(Path, { x = x, y = y })
                end
            end
        end
    end

    function NewButton(text, fn)
        return {text = text, fn = fn,
            now = false,
            last = false
        }
    end

    for name, tower in pairs(Towers) do
        table.insert(Shop, {
            text = name .. " - $" .. (tower.cost),
            image = tower.image,
            towerName = name,
            towerData = tower,
            fn = function(self)
                if Money >= (self.towerData.cost) and not Bought then
                    Money = Money - (self.towerData.cost)
                    SelectedTower = self.towerData
                    SelectedTowerName = self.towerName
                    Bought = true
                    Placed = false
                else
                    love.audio.play(NotPossible)
                end
            end
        })
    end

    table.insert(Buttons, NewButton(
            "Let's GO",
            function()
                GameState = "building"
            end))

    table.insert(Buttons, NewButton(
            "Music ON/OFF",
            function()
                if SongState then
                    love.audio.pause(Song)
                    SongState = false
                else
                    love.audio.play(Song)
                    SongState = true
                end
            end))

    table.insert(Buttons, NewButton(
            "Quit",
            function()
                love.event.quit(0)
            end))

        table.insert(UpgradeButtons, NewButton(
            "Upgrade Path 1",
            function ()
                UpgradeLogic(1,TWdata)
            end))

        table.insert(UpgradeButtons, NewButton(
            "Upgrade Path 2",
            function ()
                UpgradeLogic(2,TWdata)
            end))

    love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    GrassImage = love.graphics.newImage("Images/green.png")
    PathImage = love.graphics.newImage("Images/white.png")
    NotPossible = love.audio.newSource("sounds/Nuh-uh.wav", "static")
    Song = love.audio.newSource("sounds/Song.mp3", "static")
    SongState = false
    ShowUpgradeUI = false
    Spawning = false
    Bought = false
    Timer = 0
    Interval = 0.4
    Money = 500000
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    GameState = "menu"
    Wavetimer = 0
    WaveInterval = 3
    EnemyspawnTimer = 0
    Placed = false
    Slowness = false
    Font = love.graphics.newFont(25)
    ww = love.graphics.getWidth()
    wh = love.graphics.getHeight()
end

function love.update(dt)
    EnemyspawnTimer = EnemyspawnTimer + dt
    Wavetimer = Wavetimer + dt

    if Wavetimer > WaveInterval and GameState == "building" then
        Wavetimer = 0
        GameState = "wave"
        WaveShi()
    end

    if GameState == "wave" and Spawning then
        local waveData = Level1["wave" .. tostring(CurrentWave)]
        local spawnRate = waveData.spawnRate

        if EnemyspawnTimer >= spawnRate and #PendingSpawns > 0 then
            local pending = table.remove(PendingSpawns, 1)
            local spawnType = pending.type
            local eData = Enemy[spawnType]

            if eData then
                table.insert(EnemiesOnMap, {
                    type   = spawnType,
                    image  = eData.image,
                    speed  = eData.speed,
                    health = eData.health,
                    maxHealth = eData.health,
                    damage = eData.damage,
                    reward = eData.reward,
                    traits = eData.traits,
                    x = (Flags[1].x - 1) * 64,
                    y = (Flags[1].y - 1) * 64,
                    flagIndex = 2
                })
                EnemiesAlive = EnemiesAlive + 1
            end
            EnemyspawnTimer = 0
        end

        if #PendingSpawns == 0 then
            Spawning = false
        end
    end

    if GameState == "wave" then
        for enemyIndex = #EnemiesOnMap, 1, -1 do
            local enemy = EnemiesOnMap[enemyIndex]
            local targetFlag = Flags[enemy.flagIndex]

            if not targetFlag then
                EnemiesAlive = math.max(0, EnemiesAlive - 1)
                table.remove(EnemiesOnMap, enemyIndex)
            else
                local targetX = (targetFlag.x - 1) * 64
                local targetY = (targetFlag.y - 1) * 64
                local dx = targetX - enemy.x
                local dy = targetY - enemy.y
                local distance = math.sqrt(dx*dx + dy*dy)

                if distance < (enemy.speed) * dt then
                    enemy.x = targetX
                    enemy.y = targetY
                    enemy.flagIndex = enemy.flagIndex + 1

                    if enemy.flagIndex > #Flags then
                        EnemiesAlive = math.max(0, EnemiesAlive - 1)
                        Health = Health - (enemy.damage or 1)
                        table.remove(EnemiesOnMap, enemyIndex)

                        if Health <= 0 then
                            GameState = "gameover"
                        end
                    end
                else
                    if distance > 0 then
                        enemy.x = enemy.x + (dx / distance) * (enemy.speed) * dt
                        enemy.y = enemy.y + (dy / distance) * (enemy.speed) * dt
                    end
                end
            end
        end
    end

    if GameState == "wave" then
        for _, tower in ipairs(TowersOnMap) do
            tower.lastShot = (tower.lastShot or 0) + dt
            local towerData = tower.tower
            local fireRate = towerData.firerate or 1
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
                end
            end
        end
        updateProjectiles(dt)

        if GameState == "wave" and EnemiesAlive == 0 and not Spawning then
            GameState = "building"
            CurrentWave = CurrentWave + 1
        end
    end
end

function love.draw()
    if GameState == "building" or GameState == "wave" then
        for i, grass in ipairs(Grass) do
            love.graphics.draw(GrassImage, (grass.x -1) *64, (grass.y -1) *64)
        end
        for i, path in ipairs(Path) do
            love.graphics.draw(PathImage, (path.x -1) *64, (path.y -1) *64)
        end
    end

    if GameState == "menu" then
        local button_width = ww * (1/3)
        local Button_height = wh * (1/10)
        local margin = 16
        local Total_height = (Button_height + margin) * #Buttons
        local cursor_y = 0

        for i, Button in ipairs(Buttons) do
            Button.last = Button.now
            local bx = (ww * 0.5 ) - (button_width * 0.5)
            local by = (wh * 0.5) - (Total_height * 0.5) + cursor_y

            local color = {1,0,0,1}
            local mx, my = love.mouse.getPosition()
            local hot = mx > bx and mx < bx + button_width and my > by and my < by + Button_height

            if hot then
                color = {0,1,0,1}
            end

            Button.now = love.mouse.isDown(1)

            if Button.now and not Button.last and hot then
                Button.fn()
            end

            love.graphics.setColor(color)
            love.graphics.rectangle("fill", bx, by, button_width, Button_height)
            love.graphics.setColor(0,0,0,1)

            local tetxW = Font:getWidth(Button.text)
            local textH = Font:getHeight(Button.text)
            love.graphics.print(Button.text, Font, bx + button_width/2 - tetxW/2, by + Button_height/2 - textH/2)

            cursor_y = cursor_y + (Button_height + margin)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if GameState == "building" or GameState == "wave" then
        local shopX = ww - 250
        local shopY = 100
        local shopW = 200
        local buttonH = 100
        local marginS = 20
        local cursorS_y = 0
        local mx, my = love.mouse.getPosition()

        for i, Button in ipairs(Shop) do
            Button.last = Button.now
            local bx = shopX
            local by = shopY + cursorS_y
            love.graphics.setColor(0.8, 0.8, 0.8, 1)
            love.graphics.rectangle("fill", bx, by, shopW, buttonH)
            local hot = mx > bx and mx < bx + shopW and my > by and my < by + buttonH

            if hot then
                love.graphics.setColor(1, 1, 0, 0.3)
                love.graphics.rectangle("fill", bx, by, shopW, buttonH)
            end
            love.graphics.setColor(1, 1, 1, 1)

            if Button.image then
                love.graphics.draw(Button.image, bx + 10, by + 10, 0, 0.5, 0.5)
            end
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(Button.text, bx + 80, by + 40)
            Button.now = love.mouse.isDown(1)

            if Button.now and not Button.last and hot then
                Button.fn(Button)
            end
            cursorS_y = cursorS_y + (buttonH + marginS)
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Money: $" .. Money, 10, 10)
        love.graphics.print("Health: " .. Health, 10, 50)
        love.graphics.print("Wave: " .. CurrentWave, 10, 90)
        love.graphics.print("Enemies: " .. EnemiesAlive, 10, 130)
    end

    if GameState == "wave" or GameState == "building" then
        love.graphics.setColor(0, 0.3, 0, 1) -- dark green
        for _, proj in ipairs(Bullets) do
            if proj.alive then
                love.graphics.circle("fill", proj.x, proj.y, proj.radius)
            end
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    if GameState == "gameover" then
        love.graphics.setColor(1,0,0,1)
        local text = "Game Over"
        local textW = Font:getWidth(text)
        local textH = Font:getHeight(text)
        love.graphics.print(text, Font, ww/2 - textW/2, wh/2 - textH/2)
        love.graphics.setColor(1,1,1,1)
    end

    if GameState == "wave" or GameState == "building" then
        if Bought and not Placed and SelectedTower and SelectedTower.image then
            local mx, my = love.mouse.getPosition()
            love.graphics.setColor(1, 1, 1, 0.7)
            love.graphics.draw(SelectedTower.image, mx, my, 0, 1, 1, SelectedTower.image:getWidth()/2, SelectedTower.image:getHeight()/2)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if GameState == "wave" or GameState == "building" then
        for _, tw in ipairs(TowersOnMap) do
            local ox = tw.image:getWidth() / 2
            local oy = tw.image:getHeight() / 2
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

    if GameState == "wave" or GameState == "building" then
        for _, enemy in ipairs(EnemiesOnMap) do
            love.graphics.draw(enemy.image, enemy.x, enemy.y)
            local maxHealth = enemy.maxHealth or enemy.health

            if enemy.health and maxHealth then
                local enemyWidth = enemy.image:getWidth()
                local barWidth = 40
                local barHeight = 6
                local barX = enemy.x + (enemyWidth - barWidth) / 2
                local barY = enemy.y - 10
                local healthPercent = math.max(0, enemy.health / maxHealth)
                love.graphics.setColor(0, 0, 0, 0.8)
                love.graphics.rectangle("fill", barX - 1, barY - 1, barWidth + 2, barHeight + 2)
                local r = 1 - healthPercent
                local g = healthPercent
                love.graphics.setColor(r, g, 0, 1)
                love.graphics.rectangle("fill", barX, barY, barWidth * healthPercent, barHeight)
                love.graphics.setColor(1, 1, 1, 1)
            end

            local mx, my = love.mouse.getPosition()
            local enemyWidth = enemy.image:getWidth()
            local enemyHeight = enemy.image:getHeight()
            local enemyCenterX = enemy.x + enemyWidth / 2
            local enemyCenterY = enemy.y + enemyHeight / 2
            local Edist = math.sqrt((mx - enemyCenterX)^2 + (my - enemyCenterY)^2)

            if Edist < 30 then
                love.graphics.setColor(0, 0, 0, 0.8)
                love.graphics.rectangle("fill", mx + 10, my - 20, 120, 40)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.print(enemy.type or "Enemy", mx + 15, my - 15)
                love.graphics.print("HP: " .. (enemy.health or 0) .. "/" .. (maxHealth or 0), mx + 15, my - 2)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end

    if ShowUpgradeUI and TWdata and (GameState == "wave" or GameState == "building") and Bought == false then
        DrawTowerUpgrades(TWdata)
    end
end

function DrawTowerUpgrades(tower)
    love.graphics.setColor(1, 0, 0, 0.2)
    love.graphics.circle("fill", tower.x, tower.y, tower.range)
    love.graphics.setColor(1, 1, 1, 1)
    local Font2 = love.graphics.newFont(20)
    local button_width = ww * (1/8)
    local Button_height = wh * (1/30)
    local margin = 12
    local Total_height = (Button_height + margin) * #UpgradeButtons
    local cursor_y = 0
    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle("fill", tower.x + 100, tower.y - Total_height/2 - 20, button_width + 40, Total_height + 40)
    love.graphics.setColor(1, 1, 1, 1)

    for i, Button in ipairs(UpgradeButtons) do
        Button.last = Button.now
        local bx = (tower.x + 120)
        local by = (tower.y) - (Total_height * 0.5) + cursor_y

        local color = {1,0,0,1}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + Button_height

        if hot then
            color = {0,1,0,1}
        end

        Button.now = love.mouse.isDown(1)

        if Button.now and not Button.last and hot then
            Button.fn()
        end

        love.graphics.setColor(color)
        love.graphics.rectangle("fill", bx, by, button_width, Button_height)
        love.graphics.setColor(0,0,0,1)

        local tetxW = Font2:getWidth(Button.text)
        local textH = Font2:getHeight(Button.text)
        love.graphics.print(Button.text, Font2, bx + button_width/2 - tetxW/2, by + Button_height/2 - textH/2)

        cursor_y = cursor_y + (Button_height + margin)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function UpgradeLogic(PathNumber, TWdata)
    if not TWdata.upgradePath then
        TWdata.upgradePath = 0
    end
    if not TWdata.upgradeLevel then
        TWdata.upgradeLevel = 0
    end

    if TWdata.upgradePath ~= 0 and TWdata.upgradePath ~= PathNumber then
        love.audio.play(NotPossible)
        return
    end

    if not TWdata.towerType or not PathData[TWdata.towerType] then
        love.audio.play(NotPossible)
        return
    end

    local towerUpgradeData = PathData[TWdata.towerType].PathData
    local currentLevel = TWdata.upgradeLevel
    local nextLevel = currentLevel + 1
    if nextLevel >= 5 then
        love.audio.play(NotPossible)
        return
    end
    local upgradeKey = "Path" .. PathNumber .. "_lvl" .. tostring(nextLevel)
    local nextLevelData = towerUpgradeData[upgradeKey]
    local upgradeCost = nextLevelData.upgradeCost

    if not nextLevelData then
        love.audio.play(NotPossible)
        return
    end

    if Money < upgradeCost then
        love.audio.play(NotPossible)
        return
    else
        Money = Money - upgradeCost
    end

    if TWdata.upgradePath == 0 then
        TWdata.upgradePath = PathNumber
    end

    TWdata.upgradeLevel = nextLevel

    if nextLevelData.dmg then
        TWdata.tower.dmg = (TWdata.tower.dmg) + nextLevelData.dmg
    end

    if nextLevelData.range then
        TWdata.range = (TWdata.range) + nextLevelData.range
    end

    if nextLevelData.fireRate then
        TWdata.tower.firerate = (TWdata.tower.firerate) + nextLevelData.fireRate
    end

    if nextLevelData.projectileSpeed then
        TWdata.tower.projectileSpeed = (TWdata.tower.projectileSpeed) + nextLevelData.projectileSpeed
    end

    if nextLevelData.pierce then
        TWdata.tower.pierce = (TWdata.tower.pierce) + nextLevelData.pierce
    end

    if nextLevelData.splashRadius then
        TWdata.tower.splashRadius = (TWdata.tower.splashRadius) + nextLevelData.splashRadius
    end

    if nextLevelData.traits then
        if not TWdata.tower.traits then
            TWdata.tower.traits = {}
        end
        for _, trait in ipairs(nextLevelData.traits) do
            table.insert(TWdata.tower.traits, trait)
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
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

function love.mousepressed(x, y, button)
    if button == 1 and Bought and SelectedTower and SelectedTower.image then
        local canPlace = true
        local towerW = SelectedTower.image:getWidth()
        local towerH = SelectedTower.image:getHeight()
        local newX = x - towerW / 2
        local newY = y - towerH / 2
        local mapWidth  = (Map1 and #Map1[1]) * 64
        local mapHeight = (Map1 and #Map1) * 64

        if newX < 0 or newY < 0 or newX + towerW > mapWidth or newY + towerH > mapHeight then
            love.audio.play(NotPossible)
            canPlace = false
        end

        for i, t in ipairs(TowersOnMap) do
            local tW = t.tower.image:getWidth()
            local tH = t.tower.image:getHeight()
            local tX = t.x - tW / 2
            local tY = t.y - tH / 2

            if newX < tX + tW and newX + towerW > tX and newY < tY + tH and newY + towerH > tY then
                love.audio.play(NotPossible)
                canPlace = false
                break
            end
        end

        for i, path in ipairs(Path) do
            local pX = (path.x - 1) * 64
            local pY = (path.y - 1) * 64
            local pW = 64
            local pH = 64

            if newX < pX + pW and newX + towerW > pX and newY < pY + pH and newY + towerH > pY then
                love.audio.play(NotPossible)
                canPlace = false
                break
            end
        end

        if canPlace then
            local towerCopy = deepCopyTower(SelectedTower)
            table.insert(TowersOnMap, {
                tower = towerCopy,
                towerType = SelectedTowerName,
                image = SelectedTower.image,
                range = SelectedTower.range,
                rotation = 0,
                x = x,
                y = y,
                target = nil,
                lastShot = 0,
                upgraded = false,
                upgradePath = 0,
                upgradeLevel = 0
            })
            Bought = false
            Placed = true
        end
    end
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
    if distance == 0 then distance = 1 end
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
-- fix tower selection, fix upgrade path selection and make it so that only the selected tower gets upgraded
-- tower range display only while looking at upgrades
-- Add sound effects and music
-- Polish UI and overall game experience
-- Implement save/load functionality for game progress
-- Optimize performance for larger maps and more entities if needed   
-- More maps at least and map selection menu if i feel like doin so
-- Balancing game difficulty and economy
-- bug fixes
-- user feedback stuff