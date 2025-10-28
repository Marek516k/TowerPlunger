Level7 = {
    wave1 = {
        enemies = {
            {type = "Normalboss", count = 1}
        },
        spawnRate = 1.2,
        reward = 600
    },
    wave2 = {
        enemies = {
            {type = "Fastboss", count = 1},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 1.3,
        reward = 700
    },
    wave3 = {
        enemies = {
            {type = "Tankboss", count = 1}
        },
        spawnRate = 1.5,
        reward = 800
    },

    wave4 = {
        enemies = {
            {type = "Normalboss", count = 2},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 1.2,
        reward = 900
    },
    wave5 = {
        enemies = {
            {type = "Fastboss", count = 2}
        },
        spawnRate = 1.4,
        reward = 1000
    },
    wave6 = {
        enemies = {
            {type = "Tankboss", count = 2},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 1.5,
        reward = 1200
    },

    wave7 = {
        enemies = {
            {type = "Hiddenboss", count = 2},
            {type = "Normalboss", count = 1}
        },
        spawnRate = 1.4,
        reward = 1400
    },
    wave8 = {
        enemies = {
            {type = "Fastboss", count = 1},
            {type = "Tankboss", count = 1},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 1.6,
        reward = 1600
    },
    wave9 = {
        enemies = {
            {type = "Ultimateboss", count = 1}
        },
        spawnRate = 1.8,
        reward = 1800
    },

    wave10 = {
        enemies = {
            {type = "Hiddenboss", count = 2},
            {type = "Tankboss", count = 1},
            {type = "Ultimateboss", count = 1}
        },
        spawnRate = 2.0,
        reward = 2000
    },
    wave11 = {
        enemies = {
            {type = "GhostPhantasm", count = 1},
            {type = "Hiddenboss", count = 1}
        },
        spawnRate = 2.0,
        reward = 2200
    },
    wave12 = {
        enemies = {
            {type = "Destroyer", count = 1},
            {type = "Tankboss", count = 1}
        },
        spawnRate = 2.5,
        reward = 2500
    },

    wave13 = {
        enemies = {
            {type = "Destroyer", count = 1},
            {type = "Ultimateboss", count = 1}
        },
        spawnRate = 2.5,
        reward = 3000
    },
    wave14 = {
        enemies = {
            {type = "GhostPhantasm", count = 1},
            {type = "Hiddenboss", count = 1},
            {type = "Destroyer", count = 1}
        },
        spawnRate = 2.8,
        reward = 3500
    },

    wave15 = {
        enemies = {
            {type = "TheONE", count = 1},
            {type = "Destroyer", count = 1},
            {type = "GhostPhantasm", count = 1}
        },
        spawnRate = 1.5,
        reward = 0
    }
}

Map = {
    "#################################",
    "#################################",
    "#################################",
    "#################################",
    "....................#############",
    "###################.#############",
    "###################.#############",
    "###################.#############",
    "###################.#############",
    "###################.#############",
    "###################.#############",
    "#################...#############",
    "################..###############",
    ".................################",
    "#################################",
    "#################################",
    "#################################"
}

Flags = {
    {x = 0, y = 5},
    {x = 20, y = 5},
    {x = 20, y = 12},
    {x = 18, y = 12},
    {x = 18, y = 13},
    {x = 17, y = 13},
    {x = 17, y = 14},
    {x = 0, y = 14},
}

Level7.map = Map
Level7.flags = Flags
return Level7