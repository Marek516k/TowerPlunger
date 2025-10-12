local Map1 = Level1.Map1
local Flags = Level1.Flags
Level1 = require("GameLevels.Level1")
UpgradeLogic = require("UpgradeLogic")

function loading()
    PendingSpawns = {}
    Grass = {}
    Path = {}
    Bullets = {}
    Buttons = {}
    UpgradeButtons = {}
    Shop = {}
    TowersOnMap = {}
    EnemiesOnMap = {}
    TWdata = {}
    Particles = {}
    SelectedTower = nil
    SelectedTowerForUpgrade = nil
    Map1 = _G.Map1
    Flags = _G.Flags

    if Map1 then
        for y,row in ipairs(Map1) do
            for x = 1, #row do
                local tile = row:sub(x,x)
                if tile == "#" then
                    table.insert(Grass, { x = x, y = y })
                elseif tile == "." then
                    table.insert(Path, { x = x, y = y })
                end
            end
        end
    end

    function NewButton(text, fn)
        return {text = text, fn = fn,
            now = false,
            last = false,
            hover = 0,
            scale = 1
        }
    end

    for name, tower in pairs(Towers) do
        table.insert(Shop, {
            text = name .. " - $" .. (tower.cost),
            image = tower.image,
            towerName = name,
            towerData = tower,
            hover = 0,
            fn = function(self)
                if Money >= (self.towerData.cost) and not Bought then
                    Money = Money - (self.towerData.cost)
                    SelectedTower = self.towerData
                    SelectedTowerName = self.towerName
                    Bought = true
                    Placed = false
                else
                    love.audio.play(NotPossible)
                end
            end
        })
    end

    table.insert(Buttons, NewButton(
            "Let's GO",
            function()
                GameState = "building"
            end))

    table.insert(Buttons, NewButton(
            "Music ON/OFF",
            function()
                if SongState then
                    love.audio.pause(Song)
                    SongState = false
                else
                    love.audio.play(Song)
                    SongState = true
                end
            end))

    table.insert(Buttons, NewButton(
            "Quit",
            function()
                love.event.quit(0)
            end))

        table.insert(UpgradeButtons, NewButton(
            "Upgrade Path 1",
            function ()
                UpgradeLogic(1,TWdata)
            end))

        table.insert(UpgradeButtons, NewButton(
            "Upgrade Path 2",
            function ()
                UpgradeLogic(2,TWdata)
            end))

    love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    GrassImage = love.graphics.newImage("Images/green.png")
    PathImage = love.graphics.newImage("Images/white.png")
    NotPossible = love.audio.newSource("sounds/Nuh-uh.wav", "static")
    Song = love.audio.newSource("sounds/Song.mp3", "static")
    SongState = false
    ShowUpgradeUI = false
    Spawning = false
    Bought = false
    Timer = 0
    Interval = 0.4
    Money = 50000
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    GameState = "menu"
    Wavetimer = 0
    WaveInterval = 3
    EnemyspawnTimer = 0
    Placed = false
    Slowness = false
    Font = love.graphics.newFont(25)
    FontLarge = love.graphics.newFont(48)
    FontSmall = love.graphics.newFont(18)
    ww = love.graphics.getWidth()
    wh = love.graphics.getHeight()
    UIAlpha = 0
    WaveTransition = 0
    ShakeAmount = 0
end

return loading