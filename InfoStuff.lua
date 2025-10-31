local FontTitle = love.graphics.newFont(20, "light")
local FontNormal = love.graphics.newFont(20, "light")
local FontSmall = love.graphics.newFont(18, "light")
local FontTiny = love.graphics.newFont(16, "light")

function utilities()
    local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()
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
    love.graphics.setFont(FontTitle)
    love.graphics.print("TOWER SHOP", shopX + (shopW / 2 - FontTitle:getWidth("TOWER SHOP") / 2), shopY - 25)
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

        if Button.image then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(Button.image, bx + 15, by + 15, 0, 0.6, 0.6)
        end

        local text = Button.text
        love.graphics.setFont(FontNormal)

        if FontNormal:getWidth(text) > (shopW - 40) then
            love.graphics.setFont(FontSmall)
        end

        if FontSmall:getWidth(text) > (shopW - 40) then
            love.graphics.setFont(FontTiny)
        end

        local font = love.graphics.getFont()
        local textW = font:getWidth(text)
        local textH = font:getHeight()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(text, bx + (shopW - textW) / 2, by + (buttonH - textH) / 2)

        Button.now = love.mouse.isDown(1)
        if Button.now and not Button.last and hot then
            Button.fn(Button)
        end

        cursorS_y = cursorS_y + (buttonH + marginS)
    end

    love.graphics.setFont(FontNormal)
    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", 5, 5, 250, 170, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 5, 5, 250, 170, 10, 10)

    love.graphics.setColor(1, 0.9, 0.3, 1)
    love.graphics.printf("Money: $" .. Money, 15, 15, 220, "left")

    local healthColor = {1 - (100 - Health) / 100, Health / 100, 0, 1}
    love.graphics.setColor(healthColor)
    love.graphics.printf("Health: " .. Health, 15, 50, 220, "left")

    love.graphics.setColor(0.5, 1, 0.5, 1)
    love.graphics.printf("Wave: " .. CurrentWave, 15, 85, 220, "left")

    love.graphics.setColor(1, 0.5, 0.5, 1)
    love.graphics.printf("Enemies: " .. EnemiesAlive, 15, 120, 220, "left")

    love.graphics.setColor(1, 1, 1, 1)
end

return utilities