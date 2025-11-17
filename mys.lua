function towerHasTrait(tower, trait)
    if type(tower.traits) == "table" then
        for _, t in ipairs(tower.traits) do
            if t == trait then return true end
        end
    end
    return false
end

function mys(x, y, button)
    if button == 1 and Bought and SelectedTower then
        local canPlace = true
        local towerW = SelectedTower.image:getWidth()
        local towerH = SelectedTower.image:getHeight()
        local newX = x - towerW / 2
        local newY = y - towerH / 2
        local mapWidth  = (Map and #Map[1]) * 64
        local mapHeight = (Map and #Map) * 64

        if newX < 0 or newY < 0 or newX + towerW > mapWidth or newY + towerH > mapHeight then
            love.audio.play(NotPossible)
            canPlace = false
        end

        for i, t in ipairs(TowersOnMap) do
            local tW = t.tower.image:getWidth()
            local tH = t.tower.image:getHeight()
            local tX = t.x - tW / 2
            local tY = t.y - tH / 2
            if newX < tX + tW and newX + towerW > tX and newY < tY + tH and newY + towerH > tY then
                love.audio.play(NotPossible)
                canPlace = false
                break
            end
        end

        for i, path in ipairs(Path) do
            local pX = (path.x - 1) * 64
            local pY = (path.y - 1) * 64
            local pW = 64
            local pH = 64

            if newX < pX + pW and newX + towerW > pX and newY < pY + pH and newY + towerH > pY then
                love.audio.play(NotPossible)
                canPlace = false
                break
            end
        end

        if canPlace then
            local towerCopy = deepCopyTower(SelectedTower)
            table.insert(TowersOnMap, {
                tower = towerCopy,
                towerType = SelectedTowerName,
                image = SelectedTower.image,
                range = SelectedTower.range,
                rotation = 0,
                x = x,
                y = y,
                target = nil,
                lastShot = 0,
                upgraded = false,
                upgradePath = 0,
                upgradeLevel = 0,
                shootFlash = 0,
                canDetectHidden = towerHasTrait(towerCopy, "detection")
            })
            Bought = false
            Placed = true

            for i = 1, 10 do
                createParticle(x, y, {0.3, 0.7, 1, 1})
            end
        end
    end
end

return mys
