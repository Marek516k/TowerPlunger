local soundPool = {}

function playSFX(file)
    local s = love.audio.newSource(file, "static")
    table.insert(soundPool, s)
    s:play()
end

function findNearestTargetForTower(tower)
    local bestEnemy = nil
    local bestDist = math.huge
    local tx = tower.x
    local ty = tower.y

    for _, enemy in ipairs(EnemiesOnMap) do
        if enemyHasTrait(enemy, "hidden") and not tower.canDetectHidden then
        else
            local enemyWidth = enemy.image:getWidth()
            local enemyHeight = enemy.image:getHeight()
            local ex = enemy.x + enemyWidth / 2
            local ey = enemy.y + enemyHeight / 2
            local dx = ex - tx
            local dy = ey - ty
            local dist = math.sqrt(dx*dx + dy*dy)

            if dist <= tower.range and dist < bestDist then
                bestDist = dist
                bestEnemy = {x = ex, y = ey, enemy = enemy}
            end
        end
    end

    if bestEnemy then
        local dx = bestEnemy.x - tx
        local dy = bestEnemy.y - ty
        tower.rotation = math.atan2(dy, dx)
        tower.target = bestEnemy
        return bestEnemy
    else
        tower.target = nil
        return nil
    end
end

function deepCopyTower(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" and k ~= "image" then
            copy[k] = deepCopyTower(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function hasProjectileTrait(proj, trait)
    if not proj.traits then return false end

    for i = 1, #proj.traits do
        if proj.traits[i] == trait then
            return true
        end
    end
    return false
end

function enemyHasTrait(enemy, trait)
    if not enemy.traits then return false end

    if type(enemy.traits) == "table" then
        for _, t in ipairs(enemy.traits) do
            if t == trait then
                return true
            end
        end
    elseif type(enemy.traits) == "string" then
        return enemy.traits == trait
    end
    return false
end

function calculateDamage(proj, enemy, canDetectHidden)
    if enemyHasTrait(enemy, "hidden") and not canDetectHidden then
        return 0
    elseif enemyHasTrait(enemy, "armored") then
        return proj.damage * 0.75
    else
        return proj.damage
    end
end

function checkProjectileHit(proj, enemy)
    local enemyWidth = enemy.image:getWidth()
    local enemyHeight = enemy.image:getHeight()
    local enemyCenterX = enemy.x + enemyWidth / 2
    local enemyCenterY = enemy.y + enemyHeight / 2
    local dx = proj.x - enemyCenterX
    local dy = proj.y - enemyCenterY
    local distance = math.sqrt(dx * dx + dy * dy)
    local hitRadius = proj.radius + math.min(enemyWidth, enemyHeight) / 2

    return distance <= hitRadius
end

function createProjectile(startX, startY, targetX, targetY, speed, damage, pierce, splashRadius, traits)
    local dx = targetX - startX
    local dy = targetY - startY
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance == 0 then
        distance = 1
    end

    local dirX = dx / distance
    local dirY = dy / distance

    return {
        x = startX,
        y = startY,
        vx = dirX * speed,
        vy = dirY * speed,
        radius = 3,
        alive = true,
        damage = damage,
        pierce = pierce,
        hitCount = 0,
        splashRadius = splashRadius,
        traits = traits or {}
    }
end

function updateSlowEffects(dt)
    for i = 1, #EnemiesOnMap do
        local enemy = EnemiesOnMap[i]

        if enemy.slowDuration and enemy.slowDuration > 0 then
            enemy.slowDuration = enemy.slowDuration - dt

            if enemy.slowDuration <= 0 then
                enemy.speed = enemy.originalSpeed
                enemy.slowDuration = nil
                enemy.originalSpeed = nil
            end
        end
    end
end

function updateProjectiles(dt)
    updateSlowEffects(dt)

    for i = #Bullets, 1, -1 do
        local proj = Bullets[i]

        if not proj.alive then
            table.remove(Bullets, i)
        else
            proj.x = proj.x + proj.vx * dt
            proj.y = proj.y + proj.vy * dt

            if proj.x < -50 or proj.x > love.graphics.getWidth() + 50 or
               proj.y < -50 or proj.y > love.graphics.getHeight() + 50 then
                proj.alive = false
                table.remove(Bullets, i)
            else
                processProjectileCollisions(proj)

                if proj.hitCount > proj.pierce then
                    proj.alive = false
                    table.remove(Bullets, i)
                end
            end
        end
    end
end

function applySlowEffect(enemy)
    if not enemy.originalSpeed then
        enemy.originalSpeed = enemy.speed
    end
    enemy.speed = enemy.originalSpeed * 0.7
    enemy.slowDuration = 3.0
end

function processSplashDamage(proj, targetEnemy, hasSlow)
    local targetWidth = targetEnemy.image:getWidth()
    local targetHeight = targetEnemy.image:getHeight()
    local targetCenterX = targetEnemy.x + targetWidth / 2
    local targetCenterY = targetEnemy.y + targetHeight / 2

    for k = #EnemiesOnMap, 1, -1 do
        local splashEnemy = EnemiesOnMap[k]

        if splashEnemy ~= targetEnemy then
            local splashWidth = splashEnemy.image:getWidth()
            local splashHeight = splashEnemy.image:getHeight()
            local splashCenterX = splashEnemy.x + splashWidth / 2
            local splashCenterY = splashEnemy.y + splashHeight / 2
            local dx = targetCenterX - splashCenterX
            local dy = targetCenterY - splashCenterY
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance <= proj.splashRadius then
                local canDetectHidden = hasProjectileTrait(proj, "detection")
                local splashDamage = calculateDamage(proj, splashEnemy, canDetectHidden)

                if splashDamage > 0 then
                    splashEnemy.health = splashEnemy.health - splashDamage

                    if hasSlow then
                        applySlowEffect(splashEnemy)
                    end

                    if splashEnemy.health <= 0 then
                        Money = Money + splashEnemy.reward
                        EnemiesAlive = math.max(0, EnemiesAlive - 1)
                        table.remove(EnemiesOnMap, k)
                    end
                end
            end
        end
    end
end

function processProjectileCollisions(proj)
    local canDetectHidden = hasProjectileTrait(proj, "detection")
    local hasSlow = hasProjectileTrait(proj, "slow")

    for j = #EnemiesOnMap, 1, -1 do
        local enemy = EnemiesOnMap[j]

        if checkProjectileHit(proj, enemy) then
            local damageDealt = calculateDamage(proj, enemy, canDetectHidden)

            if damageDealt > 0 then
                enemy.health = enemy.health - damageDealt
                proj.hitCount = proj.hitCount + 1

                for i = 1, 5 do
                    createParticle(proj.x, proj.y, {1, 0.3, 0, 1})
                end

                if hasSlow then
                    applySlowEffect(enemy)
                end

                if proj.splashRadius > 0 then
                    processSplashDamage(proj, enemy, hasSlow)
                    createExplosion(proj.x, proj.y, proj.splashRadius)
                end
            end

            if enemy.health <= 0 then
                Money = Money + enemy.reward
                EnemiesAlive = math.max(0, EnemiesAlive - 1)
                for i = 1, 12 do
                    createParticle(enemy.x + 32, enemy.y + 32, {1, 1, 0.3, 1})
                end
                table.remove(EnemiesOnMap, j)
                playSFX("sounds/enemydeath.wav")
            end
            break
        end
    end
end

return {
    findNearestTargetForTower = findNearestTargetForTower,
    updateProjectiles = updateProjectiles,
    createProjectile = createProjectile
}