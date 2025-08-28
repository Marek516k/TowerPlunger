Love = require("love")
Enemy = require("Enemies")
Towers = require("Towers")
Upgrades = require("Upgrades")
Level1 = require("Level1")

function Love.load()
    Love.window.setMode(1920, 1080, {resizable=false, vsync=true})
    Timer = 0
    Interval = 0.5
    SelectedTower = nil
    Money = 500
    Health = 100
    CurrentWave = 1
    EnemiesAlive = 0
    GameState = "building" -- "building", "inWave", "gameOver"
    Wavetimer = 0
    WaveInterval = 10
    CurrentWave = 1


end

function Love.update(dt)
    Timer = Timer + dt
    if Timer > Interval then
        Timer = 0
    end
end

function Love.draw()

end

function Love.keypressed(key)
    if key == "escape" then
        Love.event.quit()
    end
    if key == "" then
        Love.window.setFullscreen(not Love.window.getFullscreen())
    end
    if key == "+" then
        SelectedTower = Towers[1]
    end
    if key == "ě" then
        SelectedTower = Towers[2]
    end
    if key == "š" then
        SelectedTower = Towers[3]
    end
    if key == "č" then
        SelectedTower = Towers[4]
    end
    if key == "ř" then
        SelectedTower = Towers[5]
    end
end