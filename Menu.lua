function Menu()
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

return Menu