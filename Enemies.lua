Enemy = {
    zombie = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 300,
        health = 100,
        damage = 10,
        reward = 5,
        traits = {"none"}
    },
    fastZombie = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 200,
        health = 40,
        damage = 20,
        reward = 6,
        traits = {"none"}
    },
    tank = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 30,
        health = 300,
        damage = 20,
        reward = 15,
        traits = {"armored"}
    },
    hidden = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 70,
        health = 80,
        damage = 15,
        reward = 8,
        traits = {"stealth"}
    },
    Normalboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 20,
        health = 1000,
        damage = 50,
        reward = 100,
        traits = {"none"}
    },
    Fastboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 50,
        health = 700,
        damage = 40,
        reward = 80,
        traits = {"none"}
    },
    Tankboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 20,
        health = 2000,
        damage = 70,
        reward = 150,
        traits = {"armored"}
    },
    Hiddenboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 40,
        health = 800,
        damage = 60,
        reward = 120,
        traits = {"stealth"}
    },
    Gravedigger = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 15,
        health = 10000,
        damage = 2000,
        reward = 1000,
        traits = {"armored"}
    }
    -- more soon mby
}

return Enemy