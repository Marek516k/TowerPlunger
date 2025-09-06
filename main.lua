love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
Upgrades = require("Upgrades")
Level1 = require("Level1")

function WaveShi()
    local waveData = Level1["wave" .. CurrentWave]
    if waveData then
        for _, enemyInfo in ipairs(waveData.enemies) do
            for i = 1, enemyInfo.count do
                table.insert(EnemiesOnMap, {
                    type = enemyInfo.type,
                    image = Enemy[enemyInfo.type].image,
                    speed = Enemy[enemyInfo.type].speed,
                    health = Enemy[enemyInfo.type].health,
                    damage = Enemy[enemyInfo.type].damage,
                    reward = Enemy[enemyInfo.type].reward,
                    traits = Enemy[enemyInfo.type].traits,
                    x = (Flags[1].x - 1) * 64,
                    y = (Flags[1].y - 1) * 64,
                    flagIndex = 2

                })
                EnemiesAlive = EnemiesAlive + 1
            end
        end
        CurrentWave = CurrentWave + 1
    else
        GameState = "gameover"
    end
end

function love.load()
    Grass = {}
    Path = {}

    for y,row in ipairs(Map1) do
        for x = 1, #row do
            local tile = row:sub(x,x)
            if tile == "#" then
                table.insert(Grass, {
                    x = x,
                    y = y})
            elseif tile == "." then
                table.insert(Path, {
                    x = x,
                    y = y})
            end
        end
    end

    Buttons = {}
    Shop = {}

    function NewButton(text, fn)
        return {text = text,
                fn = fn,
                now = false,
                last = false
            }
    end

    for name, tower in pairs(Towers) do
        table.insert(Shop, {
            text = name .. " - $" .. tower.cost,
            image = tower.image,
            fn = function()
                if Money >= tower.cost and not Bought then
                    Money = Money - tower.cost
                    SelectedTower = tower
                    Bought = true
                    Placed = false
                end
            end
        })
    end

    love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    GrassImage = love.graphics.newImage("Images/green.png")
    PathImage = love.graphics.newImage("Images/white.png")
    TowersOnMap = {}
    EnemiesOnMap = {}
    Bought = false
    Timer = 0
    Interval = 0.4
    SelectedTower = Towers.Cannon
    Money = 5000000
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    GameState = "menu"
    Wavetimer = 0
    WaveInterval = 1
    CurrentWave = 1
    Placed = false
    Font = love.graphics.newFont(32)

    States = {
        "menu",
        "building",
        "wave",
        "gameover"
    }

    table.insert(Buttons, NewButton(
        "Start Game",
        function ()
            GameState = "building"

        end))

    table.insert(Buttons, NewButton(
        "Quit",
        function ()
            love.event.quit(0)
        end))
end

function love.update(dt)
    Timer = Timer + dt
    if Timer > Interval then
        Timer = 0
    end
    Wavetimer = Wavetimer + dt
    if Wavetimer > WaveInterval and GameState == "building" then
            Wavetimer = 0
            GameState = "wave"
            WaveShi()
    end

    if GameState == "wave" then
        for i = #EnemiesOnMap, 1, -1 do
            local e = EnemiesOnMap[i]
            local targetFlag = Flags[e.flagIndex]
            if targetFlag then
                local tx = (targetFlag.x - 1) * 64
                local ty = (targetFlag.y - 1) * 64
                local dx = tx - e.x
                local dy = ty - e.y
                local dist = math.sqrt(dx*dx + dy*dy)

                if dist < e.speed * dt then
                    e.x = tx
                    e.y = ty
                    e.flagIndex = e.flagIndex + 1
                else
                    e.x = e.x + (dx / dist) * e.speed * dt
                    e.y = e.y + (dy / dist) * e.speed * dt
                end
            else
                Health = Health - e.damage
                table.remove(EnemiesOnMap, i)
                EnemiesAlive = EnemiesAlive - 1
            end
        end
    end

    if EnemiesAlive == 0 and GameState == "wave" then
        GameState = "building"
        CurrentWave = CurrentWave + 1
    end
    --TowerAI(TowersOnMap, EnemiesOnMap)
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

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local button_width = ww * (1/3)
    local Button_height = wh * (1/10)
    local margin = 16

    local Total_height = (Button_height + margin) * #Buttons
    local cursor_y = 0

    if GameState == "menu" then
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
            love.graphics.rectangle(
                "fill",
                bx,
                by,
                button_width,
                Button_height
            )
            love.graphics.setColor(0,0,0,1)

            local tetxW = Font:getWidth(Button.text)
            local textH = Font:getHeight(Button.text)
            love.graphics.print(
                Button.text,
                Font,
                bx + button_width/2 - tetxW/2,
                by + Button_height/2 - textH/2
            )

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
            love.graphics.draw(Button.image, bx + 10, by + 10, 0, 0.5, 0.5)

            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(Button.text, bx + 80, by + 40)

            Button.now = love.mouse.isDown(1)
            if Button.now and not Button.last and hot then
                Button.fn()
            end

            cursorS_y = cursorS_y + (buttonH + marginS)
        end

        love.graphics.setColor(1, 1, 1, 1)
    end

    if GameState == "gameover" then
        love.graphics.setColor(1,0,0,1)
        local text = "Game Over"
        local textW = Font:getWidth(text)
        local textH = Font:getHeight(text)
        love.graphics.print(
            text,
            Font,
            ww/2 - textW/2,
            wh/2 - textH/2
        )

        love.graphics.setColor(1,1,1,1)
    end
    if Bought and not Placed then
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.draw(SelectedTower.image, mx - SelectedTower.image:getWidth()/2, my - SelectedTower.image:getHeight()/2)
        love.graphics.setColor(1, 1, 1, 1)
    end

    for i, Tower in ipairs(TowersOnMap) do
        love.graphics.draw(Tower.tower.image, Tower.x - Tower.tower.image:getWidth()/2, Tower.y - Tower.tower.image:getHeight()/2)
    end

    for i, Enemy in ipairs(EnemiesOnMap) do
        love.graphics.draw(Enemy.image, Enemy.x, Enemy.y)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
    if key == "+" then
        SelectedTower = Towers.Cannon
    end
    if key == "ě" then
        SelectedTower = Towers[2]
    end
    if key == "š" then
        SelectedTower = Towers[3]
    end
    if key == "č" then
        SelectedTower = Towers[4]
    end
    if key == "ř" then
        SelectedTower = Towers.BombTower
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and Bought then
        local canPlace = true

        local towerW = SelectedTower.image:getWidth()
        local towerH = SelectedTower.image:getHeight()

        local newX = x - towerW / 2
        local newY = y - towerH / 2

        local mapWidth  = #Map1[1] * 64
        local mapHeight = #Map1 * 64

        if newX < 0 or newY < 0 or newX + towerW > mapWidth or newY + towerH > mapHeight then
            canPlace = false
        end

        for i, t in ipairs(TowersOnMap) do
            local tW = t.tower.image:getWidth()
            local tH = t.tower.image:getHeight()
            local tX = t.x - tW / 2
            local tY = t.y - tH / 2

            if newX < tX + tW and
               newX + towerW > tX and
               newY < tY + tH and
               newY + towerH > tY then
                canPlace = false
                break
            end
        end

        for i, path in ipairs(Path) do
            local pX = (path.x - 1) * 64
            local pY = (path.y - 1) * 64
            local pW = 64
            local pH = 64

            if newX < pX + pW and
               newX + towerW > pX and
               newY < pY + pH and
               newY + towerH > pY then
                canPlace = false
                break
            end
        end

        if canPlace then
            table.insert(TowersOnMap, {tower = SelectedTower, x = x, y = y})
            Bought = false
            Placed = true
        else
            -- future feedback feature
        end
    end
end

--TODO:
-- Add tower targeting and projectile mechanics
-- Add tower shooting and enemy health
-- Add enemy spawning and movement
-- Tower upgrade menu
-- Add wave management and difficulty scaling
-- Add sound effects and music
-- Polish UI and overall game experience
-- Implement save/load functionality for game progress
-- Optimize performance for larger maps and more entities if needed   
-- More maps at least and map selection menu if i feel like doin so
-- Balancing game difficulty and economy