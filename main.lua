Love = require("love")
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
Font = Love.graphics.newFont(32)

function Love.load()
    --Love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    Timer = 0
    Interval = 0.5
    SelectedTower = nil
    Money = 500
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    GameState = {
        "building",
        "wave",
        "gameover"
    }
    Wavetimer = 0
    WaveInterval = 10
    CurrentWave = 1

    table.insert(Buttons, NewButton(
        "Start Game",
        function ()
            GameState = "1"
        end))

    table.insert(Buttons, NewButton(
        "Quit",
        function ()
            Love.event.quit(0)
        end))

end

function Love.update(dt)
    Timer = Timer + dt
        Timer = 0
end

function Love.draw()
    local ww = Love.graphics.getWidth()
    local wh = Love.graphics.getHeight()

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
        local mx, my = Love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + Button_height

        if hot then
            color = {0,1,0,1}
        end

        Button.now = Love.mouse.isDown(1)

        if Button.now and not Button.last and hot then
            Button.fn()
        end

        Love.graphics.setColor(color)
        Love.graphics.rectangle(
            "fill",
            bx,
            by,
            button_width,
            Button_height
        )
        Love.graphics.setColor(0,0,0,1)

        local tetxW = Font:getWidth(Button.text)
        local textH = Font:getHeight(Button.text)
        Love.graphics.print(
            Button.text,
            Font,
            bx + button_width/2 - tetxW/2,
            by + Button_height/2 - textH/2
        )

        cursor_y = cursor_y + (Button_height + margin)
    end
end

function Love.keypressed(key)
    if key == "escape" then
        Love.event.quit()
    end
    if key == "f" then
        Love.window.setFullscreen(not Love.window.getFullscreen())
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