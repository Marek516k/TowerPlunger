UpgradeLogic = require("UpgradeLogic")

function loading()
    PendingSpawns = {}
    Bullets = {}
    Buttons = {}
    UpgradeButtons = {}
    Shop = {}
    TowersOnMap = {}
    TWdata = {}
    Particles = {}
    SelectedTower = nil
    SelectedTowerForUpgrade = nil
    GameStarted = false

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
                if GameStarted == false then
                    GameState = "select"
                    GameStarted = true
                else
                    GameState = "building"
                end
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
    NotPossible = love.audio.newSource("sounds/Nuh-uh.wav", "static")
    Song = love.audio.newSource("sounds/Song.mp3", "static")
    SongState = false
    ShowUpgradeUI = false
    Bought = false
    Timer = 0
    Interval = 0.35
    Money = 50000
    GameState = "menu"
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
    autoWaveTimer = 10
end

return loading