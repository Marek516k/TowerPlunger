Towers = {
    Cannon = {
        image = love.graphics.newImage("Images/cannon.png"),
        dmg = 5,
        firerate = 1.5,
        range = 300,
        cost = 37,
        traits = {"none"},
        projectile = "bullet",
        projectileSpeed = 700,
        pierce = 0,
        splashRadius = 0,
        rotation = 0
    },
    MultiCannon = {
        image = love.graphics.newImage("Images/multicannon.png"),
        dmg = 2.5,
        firerate = 6,
        range = 530,
        cost = 250,
        traits = {"none"},
        projectile = "bullet",
        projectileSpeed = 700,
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
        rotation = 0,
    },
    RailgunTower = {
        image = love.graphics.newImage("Images/railguntower.png"),
        dmg = 20,
        firerate = 0.55,
        range = 370,
        cost = 190,
        traits = {"detection"},
        projectile = "laser",
        projectileSpeed = 1200,
        splashRadius = 0,
        pierce = 2,
        rotation = 0,
    },
    BombTower = {
        image = love.graphics.newImage("Images/bombtower.png"),
        dmg = 5,
        firerate = 1,
        range = 300,
        cost = 150,
        traits = {"none"},
        projectile = "bomb",
        projectileSpeed = 450,
        splashRadius = 100,
        pierce = 0,
        rotation = 0
    }
}

TowerUpgrades = {
    Cannon = {
        Path1 = {
            lvl1 = {
                damage = 2,
                range = 50,
                fireRate = 0.2,
                upgradeCost = 25
            },
            lvl2 = {
                damage = 3,
                range = 25,
                fireRate = 0.3,
                upgradeCost = 40
            },
            lvl3 = {
                damage = 5,
                range = 50,
                fireRate = 0.5,
                upgradeCost = 100
            },
            lvl4 = {
                damage = 7,
                range = 50,
                fireRate = 0.7,
                upgradeCost = 200
            }
        },
        Path2 = {
            lvl1 = {
                upgradeCost = 20,
                range = 30,
                traits = {"detection"},
            },
            lvl2 = {
                damage = 5,
                range = 20,
                fireRate = 0.1,
                upgradeCost = 50,
            },
            lvl3 = {
                damage = 1,
                range = 50,
                fireRate = 0.4,
                upgradeCost = 90,
            },
            lvl4 = {
                damage = 2,
                range = 30,
                fireRate = 0.2,
                upgradeCost = 170,
            }
        }
    },
    MultiCannon = {
        Path1 = {
            lvl1 = {
                damage = 1,
                range = 50,
                fireRate = 1,
                upgradeCost = 60
            },
            lvl2 = {
                damage = 1,
                range = 30,
                fireRate = 1,
                upgradeCost = 80
            },
            lvl3 = {
                damage = 1,
                range = 50,
                fireRate = 2,
                upgradeCost = 150
            },
            lvl4 = {
                damage = 2,
                range = 50,
                fireRate = 3,
                upgradeCost = 300
            }
        },
        Path2 = {
            lvl1 = {
                upgradeCost = 50,
                range = 30,
            },
            lvl2 = {
                damage = 2,
                range = 20,
                fireRate = 0.5,
                upgradeCost = 100,
            },
            lvl3 = {
                damage = 1,
                range = 50,
                fireRate = 1,
                upgradeCost = 150,
            },
            lvl4 = {
                damage = 2,
                range = 30,
                fireRate = 0.5,
                upgradeCost = 250,
            }
        }
    },
    IceTower = {
        Path1 = {
            lvl1 = {
                damage = 2,
                range = 50,
                fireRate = 0.2,
                upgradeCost = 40
            },
            lvl2 = {
                damage = 3,
                range = 25,
                fireRate = 0.3,
                upgradeCost = 60
            },
            lvl3 = {
                damage = 5,
                range = 50,
                fireRate = 0.5,
                upgradeCost = 120
            },
            lvl4 = {
                damage = 7,
                range = 50,
                fireRate = 0.7,
                upgradeCost = 250
            }
        },
        Path2 = {
            lvl1 = {
                upgradeCost = 30,
                range = 30,
            },
            lvl2 = {
                damage = 5,
                range = 20,
                fireRate = 0.1,
                upgradeCost = 70,
            },
            lvl3 = {
                damage = 1,
                range = 50,
                fireRate = 0.4,
                upgradeCost = 110,
            },
            lvl4 = {
                damage = 2,
                range = 30,
                fireRate = 0.2,
                upgradeCost = 200,
            }
        }
    },
    RailgunTower = {
        Path1 = {
            lvl1 = {
                damage = 5,
                range = 50,
                fireRate = 0.1,
                upgradeCost = 70
            },
            lvl2 = {
                damage = 10,
                range = 25,
                fireRate = 0.1,
                upgradeCost = 90
            },
            lvl3 = {
                damage = 15,
                range = 50,
                fireRate = 0.2,
                upgradeCost = 180
            },
            lvl4 = {
                damage = 20,
                range = 50,
                fireRate = 0.3,
                upgradeCost = 350
            }
        },
        Path2 = {
            lvl1 = {
                upgradeCost = 60,
                range = 30,
            },
            lvl2 = {
                damage = 10,
                range = 20,
                fireRate = 0.05,
                upgradeCost = 120,
            },
            lvl3 = {
                damage = 5,
                range = 50,
                fireRate = 0.2,
                upgradeCost = 170,
            },
            lvl4 = {
                damage = 10,
                range = 30,
                fireRate = 0.1,
                upgradeCost = 300,
            }
        }
    },
    BombTower = {
        Path1 = {
            lvl1 = {
                damage = 2,
                range = 50,
                fireRate = 0.2,
                upgradeCost = 50
            },
            lvl2 = {
                damage = 3,
                range = 25,
                fireRate = 0.3,
                upgradeCost = 70
            },
            lvl3 = {
                damage = 5,
                range = 50,
                fireRate = 0.5,
                upgradeCost = 140
            },
            lvl4 = {
                damage = 7,
                range = 50,
                fireRate = 0.7,
                upgradeCost = 300
            }
        },
        Path2 = {
            lvl1 = {
                upgradeCost = 40,
                range = 30,
            },
            lvl2 = {
                damage = 5,
                range = 20,
                fireRate = 0.1,
                upgradeCost = 80,
            },
            lvl3 = {
                damage = 1,
                range = 50,
                fireRate = 0.4,
                upgradeCost = 130,
            },
            lvl4 = {
                damage = 2,
                range = 30,
                fireRate = 0.2,
                upgradeCost = 220,
            }
        }
    }
}

return Towers, TowerUpgrades