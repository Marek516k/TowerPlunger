function utilities()
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

return utilities