function UpgradeLogic(PathNumber, TWdata)
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
        if not TWdata.tower.traits then
            TWdata.tower.traits = {}
        end
        for _, trait in ipairs(nextLevelData.traits) do
            table.insert(TWdata.tower.traits, trait)
        end
    end
end

return UpgradeLogic