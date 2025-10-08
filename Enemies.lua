Enemy = {
    zombie = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 80,
        health = 100,
        damage = 10,
        reward = 10,
        traits = "none"
    },
    fastZombie = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 250,
        health = 60,
        damage = 20,
        reward = 15,
        traits = "none"
    },
    tank = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 55,
        health = 380,
        damage = 20,
        reward = 25,
        traits = "armored"
    },
    hidden = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 75,
        health = 120,
        damage = 15,
        reward = 30,
        traits = "hidden"
    },
    Normalboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 50,
        health = 1600,
        damage = 20,
        reward = 150,
        traits = "none"
    },
    Fastboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 1150,
        health = 2700,
        damage = 25,
        reward = 300,
        traits = "none"
    },
    Tankboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 35,
        health = 6000,
        damage = 50,
        reward = 400,
        traits = "armored"
    },
    Hiddenboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 70,
        health = 1100,
        damage = 40,
        reward = 600,
        traits = "hidden"
    },
    hiddenBrainrot = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 60,
        health = 7000,
        damage = 90,
        reward = 1000,
        traits = "hidden","armored"
    },
    Gravedigger = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 25,
        health = 30000,
        damage = 100,
        reward = 1500,
        traits = "armored"
    },
    Ultimateboss = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 2000,
        health = 100000,
        damage = 500,
        reward = 5000,
        traits = "armored"
    },
    Destroyer = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 2000,
        health = 100000,
        damage = 500,
        reward = 5000,
        traits = "armored"
    },
    YourNightmare = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 2000,
        health = 100000,
        damage = 500,
        reward = 5000,
        traits = "armored"
    }, 
    GhostPhantasm = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 150,
        health = 100000,
        damage = 500,
        reward = 5000,
        traits = "hidden"
    },
    ScreenMuncher = {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 200,
        health = 80000,
        damage = 500,
        reward = 5000,
        traits = "armored"
    }, 
    TheONE= {
        image = love.graphics.newImage("Images/Cannon.png"),
        speed = 100,
        health = 100000000,
        damage = 500,
        reward = 0,
        traits = "none"
    }
} 
return Enemy