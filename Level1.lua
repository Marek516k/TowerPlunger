Level1 = {
    wave1 = {
        enemies = {
            {type = "zombie", count = 8}
        },
        spawnRate = 0.7,
        reward = 100
    },
    wave2 = {
        enemies = {
            {type = "zombie", count = 5},
            {type = "fastZombie", count = 5}
        },
        spawnRate = 0.5,
        reward = 150
    },
    wave3 = {
        enemies = {
            {type = "tank", count = 3},
            {type = "hidden", count = 2}
        },
        spawnRate = 1.5,
        reward = 100
    },
    wave4 = {
        enemies = {
            {type = "Normalboss", count = 1}
        },
        spawnRate = 0.5,
        reward = 200
    },
    wave5 = {
        enemies = {
            {type = "fastZombie", count = 10},
            {type = "tank", count = 10}
        },
        spawnRate = 1.0,
        reward = 300
    },
    wave6 = {
        enemies = {
            {type = "Normalboss", count = 4},
            {type = "hidden", count = 5}
        },
        spawnRate = 0.5,
        reward = 300
    },
    wave7 = {
        enemies = {
            {type = "zombie", count = 10},
            {type = "fastZombie", count = 10},
            {type = "tank", count = 5},
            {type = "hidden", count = 5}
        },
        spawnRate = 1.0,
        reward = 400
    },
    wave8 = {
        enemies = {
            {type = "Normalboss", count = 20},
            {type = "fastZombie", count = 10}
        },
        spawnRate = 0.2,
        reward = 590
    },
    wave9 = {
        enemies = {
            {type = "zombie", count = 15},
            {type = "fastZombie", count = 10},
            {type = "tank", count = 30},
            {type = "hidden", count = 10}
        },
        spawnRate = 0.8,
        reward = 500
    },
    wave10 = {
        enemies = {
            {type = "Normalboss", count = 1},
            {type = "Fastboss", count = 1},
            {type = "Tankboss", count = 1}
        },
        spawnRate = 0.5,
        reward = 2000
    },
    wave11 = {
        enemies = {
            {type = "Tankboss", count = 3}
        },
        spawnRate = 2,
        reward = 1500
    },wave12 = {
        enemies = {
            {type = "zombie", count = 20},
            {type = "fastZombie", count = 15},
            {type = "tank", count = 15},
            {type = "hidden", count = 15},
            {type = "Hiddenboss", count = 5}
        },
        spawnRate = 3.0,
        reward = 1000
    },
    wave13 = {
        enemies = {
            {type = "Normalboss", count = 10},
            {type = "Fastboss", count = 2},
            {type = "Tankboss", count = 1},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 2.5,
        reward = 3000
    },
    wave14 = {
        enemies = {
            {type = "Gravedigger", count = 1}
        },
        spawnRate = 0.2,
        reward = 2000
    },
    wave15 = {
        enemies = {
            {type = "zombie", count = 25},
            {type = "fastZombie", count = 20},
            {type = "tank", count = 20},
            {type = "hidden", count = 20},
            {type = "Fastboss", count = 20}
        },
        spawnRate = 1.0,
        reward = 700
    },
    wave16 = {
        enemies = {
            {type = "Normalboss", count = 1},
            {type = "Fastboss", count = 1},
            {type = "Tankboss", count = 1},
            {type = "Hiddenboss", count = 1},
            {type = "Gravedigger", count = 2}
        },
        spawnRate = 0.1,
        reward = 0
    },
    wave17 = {
        enemies = {
            {type = "zombie", count = 100}
        },
        spawnRate = 0.1,
        reward = 0
    }
}

Map1 = {
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "############.....################",
    "############.###.################",
    ".............###.################",
    "################.#####...........",
    "#########....###.#####.##########",
    "#########.##.###.#####.##########",
    "#########.##.....#####.##########",
    "#########.############.##########",
    "#########..............##########",
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "#################################"
}

Flags = {
    {x = 0, y = 8},
    {x = 13, y = 8},
    {x = 13, y = 6},
    {x = 17, y = 6},
    {x = 17, y = 12},
    {x = 13, y = 12},
    {x = 13, y = 10},
    {x = 10, y = 10},
    {x = 10, y = 14},
    {x = 23, y = 14},
    {x = 23, y = 9},
    {x = 31, y = 9},
}

return Level1, Map1, Flags