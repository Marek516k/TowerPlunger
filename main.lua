love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
Upgrades = require("Upgrades")
Level1 = require("Level1")

function NewButton(text, fn)
    return {text = text,
            fn = fn,
            now = false,
            last = false
        }
end

Buttons = {}
Font = love.graphics.newFont(32)

function love.load()
    love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    Towers.Cannon.image = love.graphics.newImage("Images/cannon.png")
    Map = love.graphics.newImage("Images/Roundabout.png")
    Timer = 0
    Interval = 0.5
    SelectedTower = nil
    Money = 500
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    States = {
        "menu",
        "building",
        "wave",
        "gameover"
    }
    GameState = "menu"

    Wavetimer = 0
    WaveInterval = 10
    CurrentWave = 1

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

    if GameState == "wave" and GameState ~= "gameover" then
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

    if GameState == "building" then
        love.graphics.draw(Map, 0, 0)
        local shopX = ww - 250  -- 250 px from right edge
        local shopY = 100
        local shopW = 200
        local shopH = 100

        -- button background
        love.graphics.setColor(0.8,0.8,0.8,1)
        love.graphics.rectangle("fill", shopX, shopY, shopW, shopH)

        -- tower image
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(Towers.Cannon.image, shopX + 10, shopY + 10, 0, 0.5, 0.5)

        -- tower text
        love.graphics.setColor(0,0,0,1)
        love.graphics.print("Cannon - $"..Towers.Cannon.cost, shopX + 80, shopY + 40)
        love.graphics.setColor(1,1,1,1)
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
        SelectedTower = Towers[1]
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
        SelectedTower = Towers[5]
    end
end