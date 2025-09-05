function TowerAI(TowersonMap, EnemiesOnMap)
    for i, towerData in ipairs(TowersonMap) do
        local tower = towerData.tower
        local tx = towerData.x
        local ty = towerData.y

        local closestEnemy = nil
        local closestDistance = math.huge

        for j, enemy in ipairs(EnemiesOnMap) do
            local ex = enemy.x + enemy.image:getWidth() / 2
            local ey = enemy.y + enemy.image:getHeight() / 2

            local distance = math.sqrt((ex - tx)^2 + (ey - ty)^2)

            if distance <= tower.range and distance < closestDistance then
                closestDistance = distance
                closestEnemy = enemy
            end
        end

        if closestEnemy then
            if not tower.lastShotTime then
                tower.lastShotTime = 0
            end

            if love.timer.getTime() - tower.lastShotTime >= 1 / tower.fireRate then
                closestEnemy.health = closestEnemy.health - tower.damage
                tower.lastShotTime = love.timer.getTime()

                if closestEnemy.health <= 0 then
                    for k, e in ipairs(EnemiesOnMap) do
                        if e == closestEnemy then
                            table.remove(EnemiesOnMap, k)
                            break
                        end
                    end
                end
            end
        end
    end
end

--this is just somethink to test if the game is even gonna work

return TowerAI(TowersOnMap, EnemiesOnMap)