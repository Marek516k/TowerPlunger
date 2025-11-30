Level10 = {
    wave1 = {
        enemies = {
            {type = "tank", count = 6},
            {type = "pinkSlime", count = 4}
        },
        spawnRate = 0.5,
        reward = 300
    },
    wave2 = {
        enemies = {
            {type = "armoredSkeleton", count = 6},
            {type = "tank", count = 4}
        },
        spawnRate = 0.45,
        reward = 350
    },
    wave3 = {
        enemies = {
            {type = "pinkSlime", count = 6},
            {type = "tank", count = 3},
            {type = "skeleton", count = 6}
        },
        spawnRate = 0.45,
        reward = 400
    },
    wave4 = {
        enemies = {
            {type = "skeletonKing", count = 1},
            {type = "tank", count = 6}
        },
        spawnRate = 0.5,
        reward = 450
    },
    wave5 = {
        enemies = {
            {type = "tank", count = 8},
            {type = "armoredSkeleton", count = 4}
        },
        spawnRate = 0.4,
        reward = 500
    },
    wave6 = {
        enemies = {
            {type = "pinkSlime", count = 8},
            {type = "tank", count = 6}
        },
        spawnRate = 0.4,
        reward = 600
    },
    wave7 = {
        enemies = {
            {type = "skeletonKing", count = 2},
            {type = "armoredSkeleton", count = 6}
        },
        spawnRate = 0.45,
        reward = 700
    },
    wave8 = {
        enemies = {
            {type = "Tankboss", count = 1},
            {type = "pinkSlime", count = 8}
        },
        spawnRate = 0.55,
        reward = 850
    },
    wave9 = {
        enemies = {
            {type = "Tankboss", count = 1},
            {type = "tank", count = 8},
            {type = "skeletonKing", count = 1}
        },
        spawnRate = 0.5,
        reward = 950
    },
    wave10 = {
        enemies = {
            {type = "Gravedigger", count = 1},
            {type = "tank", count = 6}
        },
        spawnRate = 0.6,
        reward = 1100
    },
    wave11 = {
        enemies = {
            {type = "skeletonKing", count = 2},
            {type = "Tankboss", count = 1},
            {type = "pinkSlime", count = 6}
        },
        spawnRate = 0.45,
        reward = 1300
    },
    wave12 = {
        enemies = {
            {type = "Gravedigger", count = 1},
            {type = "Tankboss", count = 1}
        },
        spawnRate = 0.6,
        reward = 1500
    },
    wave13 = {
        enemies = {
            {type = "skeletonKing", count = 3},
            {type = "armoredSkeleton", count = 8}
        },
        spawnRate = 0.45,
        reward = 1600
    },
    wave14 = {
        enemies = {
            {type = "Tankboss", count = 2},
            {type = "pinkSlime", count = 8}
        },
        spawnRate = 0.5,
        reward = 1800
    },
    wave15 = {
        enemies = {
            {type = "Gravedigger", count = 1},
            {type = "skeletonKing", count = 2},
            {type = "Tankboss", count = 1}
        },
        spawnRate = 0.55,
        reward = 2000
    },
    wave16 = {
        enemies = {
            {type = "Ultimateboss", count = 1},
            {type = "tank", count = 8}
        },
        spawnRate = 0.6,
        reward = 2300
    },
    wave17 = {
        enemies = {
            {type = "Gravedigger", count = 2},
            {type = "Tankboss", count = 2}
        },
        spawnRate = 0.6,
        reward = 2600
    },
    wave18 = {
        enemies = {
            {type = "Ultimateboss", count = 1},
            {type = "skeletonKing", count = 3}
        },
        spawnRate = 0.65,
        reward = 3000
    },
    wave19 = {
        enemies = {
            {type = "Destroyer", count = 1},
            {type = "Tankboss", count = 2},
            {type = "Gravedigger", count = 1}
        },
        spawnRate = 0.7,
        reward = 3500
    },
    wave20 = {
        enemies = {
            {type = "Destroyer", count = 1},
            {type = "Ultimateboss", count = 1},
            {type = "skeletonKing", count = 2}
        },
        spawnRate = 0.75,
        reward = 0
    }
}

Map = {
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "############..........###########",
    "############.########.###########",
    "############.########.###########",
    "############.########.###########",
    "############.########.###########",
    "......................###########",
    "############.####################",
    "############.####################",
    "############.....................",
    "#################################",
    "#################################",
    "#################################",
    "#################################"
}

Flags = {
    {x = 0, y = 10},
    {x = 22, y = 10},
    {x = 22, y = 5},
    {x = 13, y = 5},
    {x = 13, y = 13},
    {x = 32, y = 13},
}

Level10.map = Map
Level10.flags = Flags
return Level10