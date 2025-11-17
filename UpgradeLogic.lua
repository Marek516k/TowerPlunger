local FontTitle = love.graphics.newFont(20, "light")
local FontStats = love.graphics.newFont(14, "light")
local FontButton = love.graphics.newFont(16, "light")

function towerHasTrait(tower, trait)
    if type(tower.traits) == "table" then
        for _, t in ipairs(tower.traits) do
            if t == trait then return true end
        end
    end
    return false
end

function Ulogic(PathNumber, TWdata)
    if not TWdata.upgradePath then
        TWdata.upgradePath = 0
    end

    if not TWdata.upgradeLevel then
        TWdata.upgradeLevel = 0
    end

    if TWdata.upgradePath ~= 0 and TWdata.upgradePath ~= PathNumber then
        love.audio.play(NotPossible)
        return
    end

    if not TWdata.towerType or not PathData[TWdata.towerType] then
        love.audio.play(NotPossible)
        return
    end

    local towerUpgradeData = PathData[TWdata.towerType].PathData
    local currentLevel = TWdata.upgradeLevel
    local nextLevel = currentLevel + 1

    if nextLevel >= 6 then
        love.audio.play(NotPossible)
        return
    end

    local upgradeKey = "Path" .. PathNumber .. "_lvl" .. tostring(nextLevel)
    local nextLevelData = towerUpgradeData[upgradeKey]
    local upgradeCost = nextLevelData.upgradeCost

    if not nextLevelData then
        love.audio.play(NotPossible)
        return
    end

    if Money < upgradeCost then
        love.audio.play(NotPossible)
        return
    else
        Money = Money - upgradeCost
        for i = 1, 15 do
            createParticle(TWdata.x, TWdata.y, {0.2, 1, 0.3, 1})
        end
    end

    if TWdata.upgradePath == 0 then
        TWdata.upgradePath = PathNumber
    end

    TWdata.upgradeLevel = nextLevel

    if nextLevelData.dmg then
        TWdata.tower.dmg = (TWdata.tower.dmg) + nextLevelData.dmg
    end

    if nextLevelData.range then
        TWdata.range = (TWdata.range) + nextLevelData.range
    end

    if nextLevelData.fireRate then
        TWdata.tower.firerate = (TWdata.tower.firerate) + nextLevelData.fireRate
    end

    if nextLevelData.projectileSpeed then
        TWdata.tower.projectileSpeed = (TWdata.tower.projectileSpeed) + nextLevelData.projectileSpeed
    end

    if nextLevelData.pierce then
        TWdata.tower.pierce = (TWdata.tower.pierce) + nextLevelData.pierce
    end

    if nextLevelData.splashRadius then
        TWdata.tower.splashRadius = (TWdata.tower.splashRadius) + nextLevelData.splashRadius
    end

    if nextLevelData.traits then
        if not TWdata.tower.traits then TWdata.tower.traits = {} end

        for _, trait in ipairs(nextLevelData.traits) do
            table.insert(TWdata.tower.traits, trait)
        end

        TWdata.canDetectHidden = towerHasTrait(TWdata.tower, "detection")
    end
end

function DrawT_ups(tower)
    love.graphics.setColor(0.3, 0.7, 1, 0.15)
    love.graphics.circle("fill", tower.x, tower.y, tower.range)
    love.graphics.setColor(0.3, 0.7, 1, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", tower.x, tower.y, tower.range)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(FontStats)

    local towerData = tower.tower

    local hoveredNextLevelData = nil
    local button_width = 160
    local button_height = 34
    local margin = 12
    local Total_height = (#UpgradeButtons * (button_height + margin))
    local panelX = tower.x + 90
    local panelY = tower.y - Total_height / 2 - 40
    local cursor_y = panelY + 50
    local mx, my = love.mouse.getPosition()

    for i, Button in ipairs(UpgradeButtons) do
        local bx = panelX + ((button_width + 40) - button_width) / 2
        local by = cursor_y
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + button_height

        if hot and tower.towerType and PathData[tower.towerType] then
            local currentLevel = tower.upgradeLevel or 0
            local nextLevel = currentLevel + 1
            local PathNumber = i

            if nextLevel < 6 then
                local upgradeKey = "Path" .. PathNumber .. "_lvl" .. tostring(nextLevel)
                hoveredNextLevelData = PathData[tower.towerType].PathData[upgradeKey]
            end
            break
        end
        cursor_y = cursor_y + button_height + margin
    end

    local baseLines = 5

    if towerData.splashRadius and towerData.splashRadius > 0 then
        baseLines = baseLines + 1
    end

    if towerData.traits and #towerData.traits > 0 then
        baseLines = baseLines + 1 + #towerData.traits
    end

    if hoveredNextLevelData and hoveredNextLevelData.traits and #hoveredNextLevelData.traits > 0 then
        baseLines = baseLines + #hoveredNextLevelData.traits
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
    local title = "Tower Stats"
    local titleW = FontTitle:getWidth(title)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.print(title, statsX + (statsWidth - titleW) / 2, statsY + 8)

    love.graphics.setColor(0.3, 0.7, 1, 0.4)
    love.graphics.setLineWidth(1)
    love.graphics.line(statsX + 10, statsY + 35, statsX + statsWidth - 10, statsY + 35)

    love.graphics.setFont(FontStats)
    local statY = statsY + 45

    local function printStat(label, color, value, bonus)
        love.graphics.setColor(color)
        love.graphics.print(label, statsX + 15, statY)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(value, statsX + statsWidth - 95, statY)

        if bonus then
            love.graphics.setColor(0.3, 1, 0.3)
            love.graphics.print("+" .. tostring(bonus), statsX + statsWidth - 55, statY)
        end
        statY = statY + lineHeight
    end

    if hoveredNextLevelData then

        local upgradeCost = hoveredNextLevelData.upgradeCost or 0
        local costText = "Cost: $" .. tostring(upgradeCost)

        love.graphics.setFont(FontButton)
        local costW = FontButton:getWidth(costText)
        local costX = statsX + (statsWidth - costW) / 2
        local costY = statsY + statsHeight - 30

        if Money < upgradeCost then
            love.graphics.setColor(1, 0.3, 0.3)
        else
            love.graphics.setColor(0.3, 1, 0.3)
        end

        love.graphics.print(costText, costX, costY)
        love.graphics.setColor(1, 1, 1)

        local nextDmg = hoveredNextLevelData.dmg or 0
        local nextFireRate = hoveredNextLevelData.fireRate or 0
        local nextRange = hoveredNextLevelData.range or 0
        local nextPierce = hoveredNextLevelData.pierce or 0
        local nextSplash = hoveredNextLevelData.splashRadius or 0

        printStat("Damage:", {1, 0.5, 0.5}, towerData.dmg, nextDmg > 0 and nextDmg or nil)
        printStat("Fire Rate:", {0.5, 1, 0.5}, string.format("%.1f/s", towerData.firerate), nextFireRate > 0 and string.format("%.1f", nextFireRate) or nil)
        printStat("Range:", {0.5, 0.5, 1}, tower.range, nextRange > 0 and nextRange or nil)
        printStat("Pierce:", {1, 1, 0.5}, towerData.pierce, nextPierce > 0 and nextPierce or nil)

        if towerData.splashRadius and towerData.splashRadius > 0 then
            printStat("Splash:", {1, 0.5, 1}, towerData.splashRadius, nextSplash > 0 and nextSplash or nil)
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

        if hoveredNextLevelData.traits and #hoveredNextLevelData.traits > 0 then
            love.graphics.setColor(0.3, 1, 0.3)

            for _, trait in ipairs(hoveredNextLevelData.traits) do
                love.graphics.print("- " .. trait, statsX + 25, statY)
                statY = statY + 16
            end
        end
    else
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
    end

    local panelWidth = button_width + 40
    local panelHeight = Total_height + 80

    love.graphics.setColor(0.15, 0.15, 0.25, 0.95)
    love.graphics.rectangle("fill", panelX, panelY, panelWidth, panelHeight, 10, 10)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", panelX, panelY, panelWidth, panelHeight, 10, 10)

    love.graphics.setFont(FontTitle)
    local upTitle = "Upgrades"
    local upW = FontTitle:getWidth(upTitle)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.print(upTitle, panelX + (panelWidth - upW) / 2, panelY + 10)

    love.graphics.setFont(FontButton)
    cursor_y = panelY + 50

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

return {
    Ulogic = Ulogic,
    DrawT_ups = DrawT_ups
}