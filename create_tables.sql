CREATE TABLE IF NOT EXISTS player (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARBINARY(255) NOT NULL,
    salt VARBINARY(16),
    gold INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS world (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    description TEXT,
    seed INT NOT NULL,
    action_speed INT DEFAULT 1 NOT NULL,
    unit_speed INT DEFAULT 1 NOT NULL,
    trade_speed INT DEFAULT 1 NOT NULL,
    night_bonus INT DEFAULT 0 NOT NULL,
    BEGINNER_PROTECTION INT DEFAULT 0 NOT NULL,
    MORALE BOOL DEFAULT FALSE NOT NULL,
    ALLIANCE_CAP INT DEFAULT 0 NOT NULL,
    STATUS TINYINT DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS player_world (
    player_id INT NOT NULL,
    world_id INT NOT NULL,
    PRIMARY KEY (player_id, world_id),
    FOREIGN KEY (player_id) REFERENCES player(id),
    FOREIGN KEY (world_id) REFERENCES world(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS island (
    id SERIAL PRIMARY KEY NOT NULL,
    x INT NOT NULL,
    y INT NOT NULL,
    world_id INT NOT NULL,
    FOREIGN KEY (world_id) REFERENCES world(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS city (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    island_id INT NOT NULL,
    x INT NOT NULL,
    y INT NOT NULL,
    owner_id INT NOT NULL,
    FOREIGN KEY (island_id) REFERENCES island(id),
    FOREIGN KEY (owner_id) REFERENCES player(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS building (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    level INT DEFAULT 0 NOT NULL CHECK (level <= max_level),
    max_level INT DEFAULT 10 NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS building_requirement (
    wood INT DEFAULT 0 NOT NULL,
    stone INT DEFAULT 0 NOT NULL,
    silver INT DEFAULT 0 NOT NULL,
    population INT DEFAULT 0 NOT NULL,
    building_id INT NOT NULL,
    FOREIGN KEY (building_id) REFERENCES building(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS building_prerequisite (
    building_id INT NOT NULL,
    prerequisite_id INT NOT NULL,
    PRIMARY KEY (building_id, prerequisite_id),
    FOREIGN KEY (building_id) REFERENCES building(id),
    FOREIGN KEY (prerequisite_id) REFERENCES building(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS unit (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    description TEXT,
    type TINYINT NOT NULL,
    wood_cost INT DEFAULT 0 NOT NULL,
    stone_cost INT DEFAULT 0 NOT NULL,
    silver_cost INT DEFAULT 0 NOT NULL,
    population_cost INT DEFAULT 0 NOT NULL,
    training_time INT DEFAULT 0 NOT NULL,
    damage INT DEFAULT 1 NOT NULL,
    defense_blunt INT DEFAULT 0 NOT NULL,
    defense_distance INT DEFAULT 0 NOT NULL,
    defense_sharp INT DEFAULT 0 NOT NULL,
    speed INT DEFAULT 1 NOT NULL,
    can_fly BOOL DEFAULT FALSE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS city_unit (
    city_id INT NOT NULL,
    unit_id INT NOT NULL,
    quantity INT DEFAULT 0 NOT NULL,
    PRIMARY KEY (city_id, unit_id),
    FOREIGN KEY (city_id) REFERENCES city(id),
    FOREIGN KEY (unit_id) REFERENCES unit(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS battle (
    id SERIAL PRIMARY KEY NOT NULL,
    attacker_id INT NOT NULL,
    defender_id INT NOT NULL,
    time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    winner_id INT NOT NULL,
    loser_id INT NOT NULL,
    loot_wood INT DEFAULT 0 NOT NULL,
    loot_stone INT DEFAULT 0 NOT NULL,
    loot_silver INT DEFAULT 0 NOT NULL,
    FOREIGN KEY (attacker_id) REFERENCES player(id),
    FOREIGN KEY (defender_id) REFERENCES player(id),
    FOREIGN KEY (winner_id) REFERENCES player(id),
    FOREIGN KEY (loser_id) REFERENCES player(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS battle_unit (
    battle_id INT NOT NULL,
    unit_id INT NOT NULL,
    quantity INT DEFAULT 0 NOT NULL,
    side TINYINT NOT NULL,
    PRIMARY KEY (battle_id, unit_id),
    FOREIGN KEY (battle_id) REFERENCES battle(id),
    FOREIGN KEY (unit_id) REFERENCES unit(id)
) ENGINE=InnoDB;

-- Island & City Positioning
ALTER TABLE island ADD CONSTRAINT unique_island_position UNIQUE (x, y, world_id);
ALTER TABLE city ADD CONSTRAINT unique_city_position UNIQUE (x, y, island_id);

-- Player-Related Indexes
CREATE INDEX idx_player_email ON player(email);
CREATE INDEX idx_player_last_login ON player(last_login);

-- Player-World Index
CREATE INDEX idx_player_world_world_id (world_id);

-- World & City Indexes
CREATE INDEX idx_world_status ON world(STATUS);
CREATE INDEX idx_city_owner ON city(owner_id);

-- Composite index for attacker/defender queries
INDEX idx_battle_attacker_defender (attacker_id, defender_id);

-- Foreign Key Indexes
CREATE INDEX idx_city_island_id ON city(island_id);
CREATE INDEX idx_city_owner_id ON city(owner_id);
CREATE INDEX idx_battle_attacker_id ON battle(attacker_id);
CREATE INDEX idx_battle_defender_id ON battle(defender_id);
