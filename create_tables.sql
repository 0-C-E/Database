-- Use the database
USE 0ce;

CREATE TABLE IF NOT EXISTS player (
    player_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    player_name VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hashed_password VARBINARY(255) NOT NULL,
    salt VARBINARY(16) NOT NULL,
    gold INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS world (
    world_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    world_name VARCHAR(100) UNIQUE NOT NULL,
    world_description TEXT,
    seed INT,
    action_speed TINYINT UNSIGNED DEFAULT 1,
    unit_speed TINYINT UNSIGNED DEFAULT 1,
    trade_speed TINYINT UNSIGNED DEFAULT 1,
    night_bonus INT DEFAULT 0,
    beginner_protection INT DEFAULT 0,
    morale BOOL DEFAULT FALSE,
    world_status TINYINT DEFAULT 2,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS player_world (
    player_id INT UNSIGNED NOT NULL,
    world_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (player_id, world_id),
    FOREIGN KEY (player_id) REFERENCES player (player_id),
    FOREIGN KEY (world_id) REFERENCES world (world_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS island (
    island_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    x INT NOT NULL,
    y INT NOT NULL,
    world_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (world_id) REFERENCES world (world_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS city (
    city_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    city_name VARCHAR(100),
    island_id INT UNSIGNED NOT NULL,
    owner_id INT UNSIGNED NOT NULL,
    world_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (island_id) REFERENCES island (island_id),
    FOREIGN KEY (owner_id) REFERENCES player (player_id),
    FOREIGN KEY (world_id) REFERENCES world (world_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS building (
    building_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    building_name VARCHAR(100),
    building_level INT DEFAULT 0 NOT NULL,
    max_level INT DEFAULT 10 NOT NULL,
    city_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city (city_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS building_requirement (
    required_wood INT DEFAULT 0 NOT NULL,
    required_stone INT DEFAULT 0 NOT NULL,
    required_silver INT DEFAULT 0 NOT NULL,
    required_population INT DEFAULT 0 NOT NULL,
    building_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (building_id) REFERENCES building (building_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS building_prerequisite (
    building_id INT UNSIGNED NOT NULL,
    prerequisite_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (building_id, prerequisite_id),
    FOREIGN KEY (building_id) REFERENCES building (building_id),
    FOREIGN KEY (prerequisite_id) REFERENCES building (building_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS unit (
    unit_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    unit_name VARCHAR(100),
    unit_description TEXT,
    unit_type TINYINT NOT NULL,
    wood_cost INT DEFAULT 0 NOT NULL,
    stone_cost INT DEFAULT 0 NOT NULL,
    silver_cost INT DEFAULT 0 NOT NULL,
    population_cost INT DEFAULT 0 NOT NULL,
    training_time INT DEFAULT 0 NOT NULL,
    damage INT DEFAULT 0 NOT NULL,
    defense_blunt INT DEFAULT 0 NOT NULL,
    defense_distance INT DEFAULT 0 NOT NULL,
    defense_sharp INT DEFAULT 0 NOT NULL,
    speed INT DEFAULT 1 NOT NULL,
    can_fly BOOL DEFAULT FALSE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS city_unit (
    city_id INT UNSIGNED NOT NULL,
    unit_id TINYINT UNSIGNED NOT NULL,
    quantity INT DEFAULT 0 NOT NULL,
    PRIMARY KEY (city_id, unit_id),
    FOREIGN KEY (city_id) REFERENCES city (city_id),
    FOREIGN KEY (unit_id) REFERENCES unit (unit_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS battle (
    battle_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    attacker_id INT UNSIGNED NOT NULL,
    defender_id INT UNSIGNED NOT NULL,
    battle_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    winner_id INT UNSIGNED NOT NULL,
    loser_id INT UNSIGNED NOT NULL,
    loot_wood INT DEFAULT 0 NOT NULL,
    loot_stone INT DEFAULT 0 NOT NULL,
    loot_silver INT DEFAULT 0 NOT NULL,
    FOREIGN KEY (attacker_id) REFERENCES player (player_id),
    FOREIGN KEY (defender_id) REFERENCES player (player_id),
    FOREIGN KEY (winner_id) REFERENCES player (player_id),
    FOREIGN KEY (loser_id) REFERENCES player (player_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS battle_unit (
    battle_id INT UNSIGNED NOT NULL,
    unit_id TINYINT UNSIGNED NOT NULL,
    quantity INT DEFAULT 0 NOT NULL,
    side TINYINT NOT NULL,
    PRIMARY KEY (battle_id, unit_id),
    FOREIGN KEY (battle_id) REFERENCES battle (battle_id),
    FOREIGN KEY (unit_id) REFERENCES unit (unit_id)
) ENGINE = InnoDB;

-- Island & City Positioning
ALTER TABLE island ADD CONSTRAINT unique_island_position UNIQUE (x, y, world_id);
ALTER TABLE city ADD CONSTRAINT unique_city_position UNIQUE (x, y, island_id);

-- Player-Related Indexes
CREATE INDEX idx_player_email ON player (email);
CREATE INDEX idx_player_last_login ON player (last_login);

-- Player-World Index
CREATE INDEX idx_player_world_world_id ON player_world (world_id);

-- World & City Indexes
CREATE INDEX idx_world_status ON world (world_status);
CREATE INDEX idx_city_owner ON city (owner_id);

-- Composite index for attacker/defender queries
CREATE INDEX idx_battle_attacker_defender ON battle (attacker_id, defender_id);

-- Foreign Key Indexes
CREATE INDEX idx_city_island_id ON city (island_id);
CREATE INDEX idx_city_owner_id ON city (owner_id);
CREATE INDEX idx_battle_attacker_id ON battle (attacker_id);
CREATE INDEX idx_battle_defender_id ON battle (defender_id);
