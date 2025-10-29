function DrawTowerUpgrades(tower)
    love.graphics.setColor(0.3, 0.7, 1, 0.15)
    love.graphics.circle("fill", tower.x, tower.y, tower.range)
    love.graphics.setColor(0.3, 0.7, 1, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", tower.x, tower.y, tower.range)
    love.graphics.setColor(1, 1, 1, 1)

    local Font2 = love.graphics.newFont(18)
    local FontStats = love.graphics.newFont(14)

    local statsWidth = 180
    local statsHeight = 200
    local statsX = tower.x - statsWidth - 100
    local statsY = tower.y - statsHeight/2

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", statsX, statsY, statsWidth, statsHeight, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", statsX, statsY, statsWidth, statsHeight, 10, 10)

    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.print("TOWER STATS", Font2, statsX + 35, statsY + 10)

    love.graphics.setColor(0.3, 0.7, 1, 0.5)
    love.graphics.setLineWidth(1)
    love.graphics.line(statsX + 10, statsY + 35, statsX + statsWidth - 10, statsY + 35)

    love.graphics.setColor(1, 1, 1, 1)
    local statY = statsY + 45
    local lineHeight = 22

    local towerData = tower.tower

    love.graphics.setColor(1, 0.5, 0.5, 1)
    love.graphics.print("Damage:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(towerData.dmg), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    love.graphics.setColor(0.5, 1, 0.5, 1)
    love.graphics.print("Fire Rate:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(string.format("%.1f/s", towerData.firerate), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    love.graphics.setColor(0.5, 0.5, 1, 1)
    love.graphics.print("Range:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(tower.range), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    love.graphics.setColor(1, 1, 0.5, 1)
    love.graphics.print("Pierce:", FontStats, statsX + 15, statY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(towerData.pierce), FontStats, statsX + statsWidth - 50, statY)
    statY = statY + lineHeight

    if towerData.splashRadius and towerData.splashRadius > 0 then
        love.graphics.setColor(1, 0.5, 1, 1)
        love.graphics.print("Splash:", FontStats, statsX + 15, statY)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(tostring(towerData.splashRadius), FontStats, statsX + statsWidth - 50, statY)
        statY = statY + lineHeight
    end

    if towerData.traits and #towerData.traits > 0 then
        love.graphics.setColor(0.7, 0.7, 1, 1)
        love.graphics.print("Traits:", FontStats, statsX + 15, statY)
        statY = statY + 18
        love.graphics.setColor(0.9, 0.9, 0.9, 1)
        for _, trait in ipairs(towerData.traits) do
            love.graphics.print("- " .. trait, FontStats, statsX + 25, statY)
            statY = statY + 16
        end
    end

    local button_width = ww * (1/7)
    local Button_height = wh * (1/25)
    local margin = 15
    local Total_height = (Button_height + margin) * #UpgradeButtons
    local cursor_y = 0

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", tower.x + 90, tower.y - Total_height/2 - 30, button_width + 60, Total_height + 60, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", tower.x + 90, tower.y - Total_height/2 - 30, button_width + 60, Total_height + 60, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1, 1)
    love.graphics.print("UPGRADES", Font2, tower.x + 120, tower.y - Total_height/2 - 20)
    love.graphics.setColor(1, 1, 1, 1)

    for i, Button in ipairs(UpgradeButtons) do
        Button.last = Button.now
        local bx = (tower.x + 120)
        local by = (tower.y) - (Total_height * 0.5) + cursor_y

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
        love.graphics.rectangle("fill", bx + 2, by + 2, button_width, Button_height, 5, 5)

        local r = 0.2 + Button.hover * 0.5
        local g = 0.6 + Button.hover * 0.4
        local b = 0.3 + Button.hover * 0.5

        love.graphics.setColor(r, g, b, 1)
        love.graphics.rectangle("fill", bx + offsetX, by + offsetY, button_width * scale, Button_height * scale, 5, 5)
        love.graphics.setColor(0.4 + Button.hover * 0.4, 0.8 + Button.hover * 0.2, 0.5 + Button.hover * 0.5, 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", bx + offsetX, by + offsetY, button_width * scale, Button_height * scale, 5, 5)

        Button.now = love.mouse.isDown(1)

        if Button.now and not Button.last and hot then
            Button.fn()
        end

        love.graphics.setColor(1, 1, 1, 1)

        local tetxW = Font2:getWidth(Button.text)
        local textH = Font2:getHeight(Button.text)

        love.graphics.print(Button.text, Font2, bx + button_width/2 - tetxW/2, by + Button_height/2 - textH/2)
        cursor_y = cursor_y + (Button_height + margin)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return DrawTowerUpgrades