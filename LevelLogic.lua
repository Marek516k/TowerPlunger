local Levels = require("GameLevels")
local Enemy = require("Enemies")

local Buttons = {}
local ButtonRects = {}

local Grass = {}
local Path = {}
local Flags = {}

CurrentWave = 1
CurrentLevel = nil

EnemiesOnMap = {}
PendingSpawns = {}

Spawning = false
EnemyspawnTimer = 0
EnemiesAlive = 0
Health = 100
GameState = "select"

local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

GrassImage = love.graphics.newImage("Images/green.png")
PathImage = love.graphics.newImage("Images/white.png")

local Text = "Select Level"
local font = love.graphics.getFont()
local textWidth = font:getWidth(Text) * 3
local Tx = (ww - textWidth) / 2
local Ty = 100

local function NewButton(text, fn)
    return { text = text, fn = fn }
end

function loadLevel()
    for i, level in ipairs(Levels.list) do
        table.insert(Buttons, NewButton("Level " .. i, function()
            GameState = "building"
            Grass, Path, Flags = {}, {}, {}
            EnemiesOnMap, PendingSpawns = {}, {}
            CurrentLevel = level
            CurrentWave = 1

            for j, row in ipairs(level.map) do
                for x = 1, #row do
                    local tile = row:sub(x, x)
                    if tile == "#" then
                        table.insert(Grass, {x = x, y = j})
                    elseif tile == "." then
                        table.insert(Path, {x = x, y = j})
                    end
                end
            end

            Flags = level.flags
        end))
    end
end

function DrawLevelSel()
    ButtonRects = {}
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.print(Text, Tx, Ty, 0, 3, 3)
    love.graphics.setColor(1, 1, 1)

    local buttonRows = 0

    for i, button in ipairs(Buttons) do
        local bw, bh = ww / 9, wh / 7
        local startX, xSpace, ySpace = 140, 200, 400
        local by = 200 + (ySpace * buttonRows)
        local bx = startX + (i - 1 - (buttonRows * 5)) * (bh + xSpace)

        love.graphics.setColor(0, 0, 0)
        local tw = font:getWidth(button.text)
        local th = font:getHeight()
        love.graphics.print(button.text, bx + (bw - tw)/2, by + (bh - th)/2)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", bx, by, bw, bh, 12)

        local mx, my = love.mouse.getPosition()
        local hovered = mx >= bx and mx <= bx + bw and my >= by and my <= by + bh

        if hovered then
            love.graphics.setColor(0.9,0.5,0.3)
            love.graphics.rectangle("fill", bx, by, bw, bh, 12)
        end

        table.insert(ButtonRects, {x = bx, y = by, width = bw, height = bh, callback = button.fn})

        if i % 5 == 0 then buttonRows = buttonRows + 1 end
    end
end

function drawMap()
    for _, grass in ipairs(Grass) do
        love.graphics.draw(GrassImage, (grass.x - 1) * 64, (grass.y - 1) * 64)
    end
    for _, path in ipairs(Path) do
        love.graphics.setColor(1, 1, 1, 0.9)
        love.graphics.draw(PathImage, (path.x - 1) * 64, (path.y - 1) * 64)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function CheckLevelSelectorClick(x, y, button)
    if button ~= 1 then return end
    for _, rect in ipairs(ButtonRects) do
        if x >= rect.x and x <= rect.x + rect.width and y >= rect.y and y <= rect.y + rect.height then
            rect.callback()
            break
        end
    end
end

function startWave()
    local waveKey = "wave" .. tostring(CurrentWave)
    local waveData = CurrentLevel[waveKey]

    for _, enemyGroup in ipairs(waveData.enemies) do
        for i = 1, enemyGroup.count do
            table.insert(PendingSpawns, {type = enemyGroup.type})
        end
    end

    Spawning = true
    EnemyspawnTimer = 0
    GameState = "wave"
end

function Enemyupdate(dt)
    if GameState == "wave" and Spawning then
        local waveData = CurrentLevel["wave" .. tostring(CurrentWave)]
        local spawnRate = waveData.spawnRate or 1
        EnemyspawnTimer = EnemyspawnTimer + dt

        if EnemyspawnTimer >= spawnRate and #PendingSpawns > 0 then
            local pending = table.remove(PendingSpawns, 1)
            local eData = Enemy[pending.type]
            if eData and Flags[1] then
                table.insert(EnemiesOnMap, {
                    type = pending.type,
                    image = eData.image,
                    speed = eData.speed,
                    health = eData.health,
                    maxHealth = eData.health,
                    damage = eData.damage,
                    reward = eData.reward,
                    x = (Flags[1].x) * 64,
                    y = (Flags[1].y) * 64,
                    flagIndex = 2
                })
                EnemiesAlive = EnemiesAlive + 1
            end
            EnemyspawnTimer = 0

            if #PendingSpawns == 0 then
                Spawning = false
            end
        end
    end

    if GameState == "wave" then
        for i = #EnemiesOnMap, 1, -1 do
            local e = EnemiesOnMap[i]
            local f = Flags[e.flagIndex]
            if not f then
                table.remove(EnemiesOnMap, i)
                EnemiesAlive = EnemiesAlive - 1
            else
                local tx, ty = (f.x) * 64, (f.y) * 64
                local dx, dy = tx - e.x, ty - e.y
                local dist = math.sqrt(dx*dx + dy*dy)
                if dist < e.speed * dt then
                    e.x, e.y = tx, ty
                    e.flagIndex = e.flagIndex + 1
                    if e.flagIndex > #Flags then
                        Health = Health - e.damage
                        table.remove(EnemiesOnMap, i)
                        EnemiesAlive = EnemiesAlive - 1
                        if Health <= 0 then
                            GameState = "gameover"
                        end
                    end
                else
                    e.x = e.x + (dx/dist) * e.speed * dt
                    e.y = e.y + (dy/dist) * e.speed * dt
                end
            end
        end
    end
end

function DrawEnemies()
    for _, e in ipairs(EnemiesOnMap) do
        love.graphics.draw(e.image, e.x, e.y)
    end
end

return {
    loadLevel = loadLevel,
    DrawLevelSel = DrawLevelSel,
    drawMap = drawMap,
    startWave = startWave,
    Enemyupdate = Enemyupdate,
    DrawEnemies = DrawEnemies
}