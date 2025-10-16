local Levels = require("GameLevels")
local ButtonRects = {}
local HoveredButton = nil

function LevelSelector()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local text = "Select Level"
    local font = love.graphics.getFont()

    local textWidth = font:getWidth(text) * 3
    local textHeight = font:getHeight() * 3

    local x = (ww - textWidth) / 2
    local y = 100

    love.graphics.setColor(0.2, 0.8, 1, 1)
    love.graphics.print(text, x, y, 0, 3, 3)
    love.graphics.setColor(1, 1, 1, 1)

    local Buttons = {}

    for i, level in ipairs(Levels.list) do
        table.insert(Buttons, NewButton(
            "Level " .. i,
            function()
                Map = level.map
                Flags = level.flags
                GameState = "building"
            end
        ))
    end

    local a = 0
    ButtonRects = {}

    for i, button in ipairs(Buttons) do
        local button_width = ww / 9
        local button_height = wh / 7
        local button_x_start = 140
        local buttonX_spacing = 200
        local buttonY_spacing = 400
        local button_y = 200 + (buttonY_spacing * a)
        local button_x = button_x_start + (i - 1 - (a * 5)) * (button_height + buttonX_spacing)

        table.insert(ButtonRects, {
            x = button_x,
            y = button_y,
            width = button_width,
            height = button_height,
            callback = button.callback
        })

        local mx, my = love.mouse.getPosition()
        local isHovered = mx >= button_x and mx <= button_x + button_width and my >= button_y and my <= button_y + button_height

        if isHovered then
            love.graphics.setColor(1, 0.9, 0.3)
            HoveredButton = i
        else
            love.graphics.setColor(0.5, 0.8, 0.9)
        end

        love.graphics.print(button.text, button_x + 87.5, button_y + 65.5)
        love.graphics.rectangle("line", button_x, button_y, button_width, button_height)
        love.graphics.setColor(1, 1, 1, 1)

        if i % 5 == 0 then
            a = a + 1
        end
    end

    return ButtonRects
end

function CheckLevelSelectorClick(x, y, button)
    if button == 1 then
        for i, rect in ipairs(ButtonRects) do
            if x >= rect.x and x <= rect.x + rect.width and
               y >= rect.y and y <= rect.y + rect.height then
                rect.callback()
                break
            end
        end
    end
end

return LevelSelector