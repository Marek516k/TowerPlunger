love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
Upgrades = require("Upgrades")
Level1 = require("Level1")
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

function love.load()
    love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    Map = love.graphics.newImage("Images/Roundabout.png")
    TowersOnMap = {}
    EnemiesOnMap = {}
    TemporaryPos = {
        x = 0,
        y = 0
    }
    Bought = false
    Timer = 0
    Interval = 0.5
    SelectedTower = Towers.Cannon
    Money = 5000000
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    GameState = "menu"
    Wavetimer = 0
    WaveInterval = 10
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

    if GameState == "wave" and not GameState == "gameover" then
        Wavetimer = Wavetimer + dt
        if Wavetimer > WaveInterval then
            GameState = GameState[1]
            Wavetimer = 0
        end
    Timer = 0
    end
end

function love.draw()
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

    if GameState == "building" then
        love.graphics.draw(Map, 0, 0)

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

    --[[for i, Enemy in ipairs(EnemiesOnMap) do
        love.graphics.draw(Enemy.image, Enemy.x, Enemy.y)
    end --]]
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

        if canPlace then
            table.insert(TowersOnMap, {tower = SelectedTower, x = x, y = y})
            Bought = false
            Placed = true
        else
            -- future feedback feature
        end
    end
end
