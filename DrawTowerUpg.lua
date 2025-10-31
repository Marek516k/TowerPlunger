local FontTitle = love.graphics.newFont(20, "light")
local FontStats = love.graphics.newFont(14, "light")
local FontButton = love.graphics.newFont(16, "light")

function DrawTowerUpgrades(tower)
    love.graphics.setColor(0.3, 0.7, 1, 0.15)
    love.graphics.circle("fill", tower.x, tower.y, tower.range)
    love.graphics.setColor(0.3, 0.7, 1, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", tower.x, tower.y, tower.range)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(FontStats)

    local towerData = tower.tower
    local baseLines = 5

    if towerData.splashRadius and towerData.splashRadius > 0 then
        baseLines = baseLines + 1
    end

    if towerData.traits and #towerData.traits > 0 then
        baseLines = baseLines + 1 + #towerData.traits
    end

    local lineHeight = 22
    local statsHeight = 50 + baseLines * lineHeight
    local statsWidth = 190
    local statsX = tower.x - statsWidth - 100
    local statsY = tower.y - statsHeight / 2

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", statsX, statsY, statsWidth, statsHeight, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", statsX, statsY, statsWidth, statsHeight, 10, 10)

    love.graphics.setFont(FontTitle)
    local title = "TOWER STATS"
    local titleW = FontTitle:getWidth(title)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.print(title, statsX + (statsWidth - titleW) / 2, statsY + 8)

    love.graphics.setColor(0.3, 0.7, 1, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(statsX + 10, statsY + 35, statsX + statsWidth - 10, statsY + 35)

    love.graphics.setFont(FontStats)
    local statY = statsY + 45

    local function printStat(label, color, value)
        love.graphics.setColor(color)
        love.graphics.print(label, statsX + 15, statY)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(value, statsX + statsWidth - 55, statY)
        statY = statY + lineHeight
    end

    printStat("Damage:", {1, 0.5, 0.5}, towerData.dmg)
    printStat("Fire Rate:", {0.5, 1, 0.5}, string.format("%.1f/s", towerData.firerate))
    printStat("Range:", {0.5, 0.5, 1}, tower.range)
    printStat("Pierce:", {1, 1, 0.5}, towerData.pierce)

    if towerData.splashRadius and towerData.splashRadius > 0 then
        printStat("Splash:", {1, 0.5, 1}, towerData.splashRadius)
    end

    if towerData.traits and #towerData.traits > 0 then
        love.graphics.setColor(0.7, 0.7, 1)
        love.graphics.print("Traits:", statsX + 15, statY)
        statY = statY + 18
        love.graphics.setColor(0.9, 0.9, 0.9)
        for _, trait in ipairs(towerData.traits) do
            love.graphics.print("- " .. trait, statsX + 25, statY)
            statY = statY + 16
        end
    end

    local button_width = 160
    local button_height = 34
    local margin = 12
    local Total_height = (#UpgradeButtons * (button_height + margin))
    local panelX = tower.x + 90
    local panelY = tower.y - Total_height / 2 - 40
    local panelWidth = button_width + 40
    local panelHeight = Total_height + 80

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", panelX, panelY, panelWidth, panelHeight, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", panelX, panelY, panelWidth, panelHeight, 10, 10)

    love.graphics.setFont(FontTitle)
    local upTitle = "UPGRADES"
    local upW = FontTitle:getWidth(upTitle)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.print(upTitle, panelX + (panelWidth - upW) / 2, panelY + 10)

    love.graphics.setFont(FontButton)
    local cursor_y = panelY + 50
    for _, Button in ipairs(UpgradeButtons) do
        Button.last = Button.now
        local bx = panelX + (panelWidth - button_width) / 2
        local by = cursor_y

        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + button_height

        Button.hover = math.max(0, math.min(1, Button.hover + (hot and 0.1 or -0.1)))
        local scale = 1 + Button.hover * 0.05
        local offsetX = (button_width - button_width * scale) / 2
        local offsetY = (button_height - button_height * scale) / 2

        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.rectangle("fill", bx + 2, by + 2, button_width, button_height, 5, 5)

        local r = 0.2 + Button.hover * 0.5
        local g = 0.6 + Button.hover * 0.4
        local b = 0.3 + Button.hover * 0.5
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", bx + offsetX, by + offsetY, button_width * scale, button_height * scale, 5, 5)
        love.graphics.setColor(0.4 + Button.hover * 0.4, 0.8 + Button.hover * 0.2, 0.5 + Button.hover * 0.5)
        love.graphics.rectangle("line", bx + offsetX, by + offsetY, button_width * scale, button_height * scale, 5, 5)

        Button.now = love.mouse.isDown(1)

        if Button.now and not Button.last and hot then
            Button.fn()
        end

        love.graphics.setColor(1, 1, 1)
        local textW = FontButton:getWidth(Button.text)
        local textH = FontButton:getHeight()
        love.graphics.print(Button.text, bx + (button_width - textW) / 2, by + (button_height - textH) / 2 - 2)

        cursor_y = cursor_y + button_height + margin
    end

    love.graphics.setColor(1, 1, 1)
end

return DrawTowerUpgrades