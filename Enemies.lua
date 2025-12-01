Enemy = {
    zombie = {
        image = love.graphics.newImage("Images/zombie.png"),
        speed = 85,
        health = 100,
        damage = 10,
        reward = 10,
        traits = {}
    },
    fastZombie = {
        image = love.graphics.newImage("Images/fastZombie.png"),
        speed = 225,
        health = 60,
        damage = 20,
        reward = 15,
        traits = {}
    },
    tank = {
        image = love.graphics.newImage("Images/tank.png"),
        speed = 55,
        health = 380,
        damage = 20,
        reward = 25,
        traits = {"armored"}
    },
    hidden = {
        image = love.graphics.newImage("Images/hidden.png"),
        speed = 80,
        health = 120,
        damage = 15,
        reward = 30,
        traits = {"hidden"}
    },
    skeleton = {
        image = love.graphics.newImage("Images/skeleton.png"),
        speed = 100,
        health = 70,
        damage = 7,
        reward = 8,
        traits = {}
    },
    armoredSkeleton = {
        image = love.graphics.newImage("Images/armoredSkeleton.png"),
        speed = 55,
        health = 500,
        damage = 25,
        reward = 35,
        traits = {"armored"}
    },
    boneReaper = {
        image = love.graphics.newImage("Images/boneReaper.png"),
        speed = 75,
        health = 160,
        damage = 20,
        reward = 45,
        traits = {"hidden", "armored"}
    },
    slime = {
        image = love.graphics.newImage("Images/slime.png"),
        speed = 90,
        health = 120,
        damage = 12,
        reward = 12,
        traits = {}
    },
    pinkSlime = {
        image = love.graphics.newImage("Images/pinkSlime.png"),
        speed = 60,
        health = 500,
        damage = 25,
        reward = 35,
        traits = {"armored"}
    },
    skeletonKing = {
        image = love.graphics.newImage("Images/skeletonKing.png"),
        speed = 65,
        health = 3000,
        damage = 30,
        reward = 120,
        traits = {"armored"}
    },
    Normalboss = {
        image = love.graphics.newImage("Images/Normalboss.png"),
        speed = 70,
        health = 1600,
        damage = 20,
        reward = 150,
        traits = {}
    },
    Fastboss = {
        image = love.graphics.newImage("Images/Fastboss.png"),
        speed = 350,
        health = 2700,
        damage = 25,
        reward = 300,
        traits ={}
    },
    Tankboss = {
        image = love.graphics.newImage("Images/Tankboss.png"),
        speed = 55,
        health = 6000,
        damage = 50,
        reward = 400,
        traits = {"armored"}
    },
    Hiddenboss = {
        image = love.graphics.newImage("Images/Hiddenboss.png"),
        speed = 85,
        health = 1100,
        damage = 40,
        reward = 600,
        traits = {"hidden"}
    },
    hiddenBrainrot = {
        image = love.graphics.newImage("Images/hiddenBrainrot.png"),
        speed = 67,
        health = 7067,
        damage = 67,
        reward = 1067,
        traits = {"hidden", "armored"}
    },
    Destroyer = {
        image = love.graphics.newImage("Images/Destroyer.png"),
        speed = 180,
        health = 10000,
        damage = 500,
        reward = 2000,
        traits = {"armored"}
    },
    Gravedigger = {
        image = love.graphics.newImage("Images/Gravedigger.png"),
        speed = 35,
        health = 35000,
        damage = 100,
        reward = 1500,
        traits = {"armored"}
    },
    GhostPhantasm = {
        image = love.graphics.newImage("Images/GhostPhantasm.png"),
        speed = 150,
        health = 50000,
        damage = 500,
        reward = 4000,
        traits = {"hidden", "armored"}
    },
    YourNightmare = {
        image = love.graphics.newImage("Images/YourNightmare.png"),
        speed = 40,
        health = 70000,
        damage = 500,
        reward = 3000,
        traits = {}
    },
    ScreenMuncher = {
        image = love.graphics.newImage("Images/ScreenMuncher.png"),
        speed = 200,
        health = 80000,
        damage = 500,
        reward = 5000,
        traits = {"armored"}
    },
    Ultimateboss = {
        image = love.graphics.newImage("Images/ultimateboss.png"),
        speed = 130,
        health = 100000,
        damage = 500,
        reward = 1000,
        traits = {"armored"}
    },
    TheONE = {
        image = love.graphics.newImage("Images/TheONE.png"),
        speed = 75,
        health = 900000,
        damage = 500,
        reward = 0,
        traits = {}
    }
}

return Enemy