Towers = {
    Cannon = {
        image = love.graphics.newImage("Images/cannon.png"),
        dmg = 5,
        firerate = 1.5,
        range = 330,
        cost = 37,
        traits = {},
        projectile = "bullet",
        projectileSpeed = 800,
        pierce = 0,
        splashRadius = 0,
        rotation = 0
    },
    MultiCannon = {
        image = love.graphics.newImage("Images/multicannon.png"),
        dmg = 2.5,
        firerate = 6,
        range = 430,
        cost = 250,
        traits = {},
        projectile = "bullet",
        projectileSpeed = 800,
        splashRadius = 0,
        pierce = 0,
        rotation = 0
    },
    IceTower = {
        image = love.graphics.newImage("Images/icetower.png"),
        dmg = 4,
        firerate = 1.2,
        range = 350,
        cost = 73,
        traits = {"detection","slow"},
        projectile = "ice",
        projectileSpeed = 550,
        splashRadius = 65,
        pierce = 0,
        rotation = 0
    },
    RailgunTower = {
        image = love.graphics.newImage("Images/railguntower.png"),
        dmg = 20,
        firerate = 0.55,
        range = 370,
        cost = 190,
        traits = {"detection"},
        projectile = "laser",
        projectileSpeed = 1500,
        splashRadius = 0,
        pierce = 2,
        rotation = 0
    },
    BombTower = {
        image = love.graphics.newImage("Images/bombtower.png"),
        dmg = 5,
        firerate = 1,
        range = 300,
        cost = 150,
        traits = {},
        projectile = "bomb",
        projectileSpeed = 450,
        splashRadius = 100,
        pierce = 0,
        rotation = 0
    }
}

return Towers
