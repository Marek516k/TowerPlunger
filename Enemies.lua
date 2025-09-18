Enemy = {
    zombie = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 80,
        health = 85,
        damage = 10,
        reward = 8,
        traits = "none"
    },
    fastZombie = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 200,
        health = 55,
        damage = 20,
        reward = 12,
        traits = "none"
    },
    tank = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 45,
        health = 350,
        damage = 20,
        reward = 18,
        traits = "armored"
    },
    hidden = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 75,
        health = 110,
        damage = 15,
        reward = 22,
        traits = "hidden"
    },
    Normalboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 50,
        health = 1500,
        damage = 50,
        reward = 150,
        traits = "none"
    },
    Fastboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 1125,
        health = 2500,
        damage = 40,
        reward = 350,
        traits = "none"
    },
    Tankboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 35,
        health = 5500,
        damage = 70,
        reward = 500,
        traits = "armored"
    },
    Hiddenboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 70,
        health = 950,
        damage = 60,
        reward = 675,
        traits = "hidden"
    },
    Gravedigger = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 20,
        health = 27000,
        damage = 100,
        reward = 1500,
        traits = "armored"
    }
    -- more soon mby
}

return Enemy