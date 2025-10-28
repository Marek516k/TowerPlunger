Level1 = {
    wave1 = {
        enemies = {
            {type = "zombie", count = 8}
        },
        spawnRate = 0.5,
        reward = 80
    },
    wave2 = {
        enemies = {
            {type = "zombie", count = 6},
            {type = "fastZombie", count = 5},
        },
        spawnRate = 0.4,
        reward = 120
    },
    wave3 = {
        enemies = {
            {type = "tank", count = 3},
            {type = "hidden", count = 2}
        },
        spawnRate = 0.5,
        reward = 150
    },
    wave4 = {
        enemies = {
            {type = "Normalboss", count = 1}
        },
        spawnRate = 0.1,
        reward = 170
    },
    wave5 = {
        enemies = {
            {type = "fastZombie", count = 10},
            {type = "tank", count = 10}
        },
        spawnRate = 0.5,
        reward = 130
    },
    wave6 = {
        enemies = {
            {type = "Normalboss", count = 6},
            {type = "hidden", count = 5}
        },
        spawnRate = 1,
        reward = 250
    },
    wave7 = {
        enemies = {
            {type = "zombie", count = 10},
            {type = "fastZombie", count = 10},
            {type = "tank", count = 5},
            {type = "hidden", count = 5},
        },
        spawnRate = 0.6,
        reward = 230
    },
    wave8 = {
        enemies = {
            {type = "Normalboss", count = 20},
            {type = "fastZombie", count = 10}
        },
        spawnRate = 0.2,
        reward = 220
    },
    wave9 = {
        enemies = {
            {type = "zombie", count = 15},
            {type = "fastZombie", count = 10},
            {type = "tank", count = 30},
            {type = "hidden", count = 10},
            {type = "Normalboss", count = 5}
        },
        spawnRate = 0.4,
        reward = 607
    },
    wave10 = {
        enemies = {
            {type = "Normalboss", count = 1},
            {type = "Fastboss", count = 1},
            {type = "Tankboss", count = 1}
        },
        spawnRate = 0.5,
        reward = 1000
    },
    wave11 = {
        enemies = {
            {type = "Tankboss", count = 4}
        },
        spawnRate = 1,
        reward = 500
    },wave12 = {
        enemies = {
            {type = "zombie", count = 20},
            {type = "fastZombie", count = 15},
            {type = "tank", count = 15},
            {type = "hidden", count = 15},
            {type = "Hiddenboss", count = 5}
        },
        spawnRate = 0.5,
        reward = 800
    },
    wave13 = {
        enemies = {
            {type = "Normalboss", count = 10},
            {type = "Fastboss", count = 2},
            {type = "Tankboss", count = 1},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 0.5,
        reward = 400
    },
    wave14 = {
        enemies = {
            {type = "Gravedigger", count = 1}
        },
        spawnRate = 0.1,
        reward = 500
    },
    wave15 = {
        enemies = {
            {type = "zombie", count = 25},
            {type = "fastZombie", count = 20},
            {type = "tank", count = 20},
            {type = "hidden", count = 20},
            {type = "Fastboss", count = 20}
        },
        spawnRate = 0.75,
        reward = 750
    },
    wave16 = {
        enemies = {
            {type = "Normalboss", count = 1},
            {type = "Fastboss", count = 1},
            {type = "Tankboss", count = 1},
            {type = "Hiddenboss", count = 1},
            {type = "Gravedigger", count = 2}
        },
        spawnRate = 0.5,
        reward = 500
    },
    wave17 = {
        enemies = {
            {type = "zombie", count = 1000}
        },
        spawnRate = 0.02,
        reward = 1
    },
    wave18 = {
        enemies = {
            {type = "Ultimateboss", count = 1},
            {type = "hiddenBrainrot", count = 5}
        },
        spawnRate = 1,
        reward = 1000
    },
    wawe19 = {
        enemies = {
            {type = "Ultimateboss", count = 3}
        },
        spawnRate = 1,
        reward = 1000
    },
    wawe20 = {
        enemies = {
            {type = "Ultimateboss", count = 5},
            {type = "hiddenBrainrot", count = 10}
        },
        spawnRate = 0.5,
        reward = 0
    }
}

Map = {
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

Level1.map = Map
Level1.flags = Flags
return Level1