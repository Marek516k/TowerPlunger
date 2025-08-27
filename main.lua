Love = require("love")

function Love.load()
    Timer = 0
    Interval = 0.5
    Love.window.setMode(1920, 1080, {resizable=false, vsync=true})

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
        Tower = Cannon
    end
    if key == "ě" then
        Tower = MachineGun
    end
    if key == "š" then
        Tower = SlowTower
    end
    if key == "č" then
        Tower = RailgunTower
    end
    if key == "ř" then
        Tower = BombTower
    end
end