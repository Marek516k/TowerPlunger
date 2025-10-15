local Levels = require("GameLevels")

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

    local button_width = ww/3
    local button_height = wh/12
    local button_x = (ww - button_width) / 2
    local button_y_start = 250
    local button_spacing = 20
    local Buttons = {}

    for i, level in ipairs(Levels) do
        local button_y = button_y_start + (i - 1) * (button_height + button_spacing)
        table.insert(Buttons, NewButton(
            "Level " .. i,
            function()
                Map = level.map
                Flags = level.flags
                loadStuff()
                GameState = "building"
            end
        ))
    end
end

return LevelSelector
