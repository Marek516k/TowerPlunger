
Towers = {
    Cannon = {
        dmg = 10,
        firerate = 1,
        range = 100,
        cost = 50,
        firstUpgrade = 30,
        upgrades = 4,
        traits = {"none"},
        projectile = "bullet",
        projectileSpeed = 300,
        gridSize = 4
    },
    MachineGun = {
        dmg = 10,
        firerate = 0.3,
        range = 100,
        cost = 50,
        firstUpgrade = 30,
        upgrades = 4,
        traits = {"none"},
        projectile = "bullet",
        projectileSpeed = 300,
        gridSize = 4
    },
    IceTower = {
        dmg = 10,
        firerate = 1,
        range = 100,
        cost = 50,
        firstUpgrade = 30,
        upgrades = 4,
        traits = {"detection","slow"},
        projectile = "ice",
        projectileSpeed = 300,
        gridSize = 4
    },
    RailgunTower = {
        dmg = 10,
        firerate = 1,
        range = 100,
        cost = 50,
        firstUpgrade = 30,
        upgrades = 4,
        traits = {"piercing","detection"},
        projectile = "bullet",
        projectileSpeed = 300,
        gridSize = 4
    },
    BombTower = {
        dmg = 10,
        firerate = 1,
        range = 100,
        cost = 50,
        firstUpgrade = 30,
        upgrades = 4,
        traits = {"splash"},
        projectile = "bomb",
        projectileSpeed = 300,
        gridSize = 4
    } --mby more towers in the future
}

return Towers