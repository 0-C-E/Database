-- Use the database
USE 0ce;

-- Player Procedures

DELIMITER //

CREATE OR REPLACE PROCEDURE get_all_players()
BEGIN
    SELECT player_id, player_name, email, gold, created_at, last_login
    FROM player;
END //

CREATE OR REPLACE PROCEDURE get_player_by_id(IN p_player_id INT)
BEGIN
    SELECT player_id, player_name, email, gold, created_at, last_login
    FROM player
    WHERE player_id = p_player_id;
END //

-- This procedure is used to check if an email already exists in the database
CREATE OR REPLACE PROCEDURE get_player_by_email(IN p_email VARCHAR(100), OUT email_exists BOOLEAN)
BEGIN
    SELECT EXISTS(SELECT 1 FROM player WHERE email = p_email) INTO email_exists;
END //

CREATE OR REPLACE PROCEDURE get_player_by_name(IN p_player_name VARCHAR(100))
BEGIN
    SELECT player_id, player_name, email, gold, created_at, last_login
    FROM player
    WHERE player_name = p_player_name;
END //

CREATE OR REPLACE PROCEDURE get_player_worlds(IN p_player_id INT)
BEGIN
    SELECT w.world_id, w.world_name, w.world_description, w.created_at
    FROM world w
    JOIN player_world pw ON w.world_id = pw.world_id
    WHERE pw.player_id = p_player_id;
END //

CREATE OR REPLACE PROCEDURE get_player_cities(IN p_world_id INT, IN p_player_id INT)
BEGIN
    SELECT c.city_id, c.city_name, c.x, c.y, c.island_id
    FROM city c
    JOIN world w ON c.world_id = w.world_id
    WHERE c.owner_id = p_player_id
    AND w.world_id = p_world_id;
END //

CREATE OR REPLACE PROCEDURE get_player_battles(IN p_player_id INT)
BEGIN
    SELECT battle_id, attacker_id, defender_id, battle_time, winner_id, loser_id, loot_wood,
        loot_stone, loot_silver
    FROM battle
    WHERE attacker_id = p_player_id OR defender_id = p_player_id;
END //

-- World Procedures

CREATE OR REPLACE PROCEDURE get_all_worlds()
BEGIN
    SELECT world_id, world_name, world_description, seed, action_speed, unit_speed, trade_speed,
        night_bonus, beginner_protection, morale, world_status, created_at
    FROM world;
END //

CREATE OR REPLACE PROCEDURE get_world_by_id(IN p_world_id INT)
BEGIN
    SELECT world_id, world_name, world_description, seed, action_speed, unit_speed, trade_speed,
        night_bonus, beginner_protection, morale, world_status, created_at
    FROM world
    WHERE world_id = p_world_id;
END //

CREATE OR REPLACE PROCEDURE get_active_worlds()
BEGIN
    SELECT world_id, world_name, world_description, created_at
    FROM world
    WHERE world_status = 1;
END //

CREATE OR REPLACE PROCEDURE get_players_in_world(IN p_world_id INT)
BEGIN
    SELECT p.player_id, p.player_name, p.email, p.gold, p.created_at
    FROM player p
    JOIN p_player_world pw ON p.player_id = pw.player_id
    WHERE pw.world_id = p_world_id;
END //

CREATE OR REPLACE PROCEDURE get_islands_in_world(IN p_world_id INT)
BEGIN
    SELECT island_id, x, y
    FROM island
    WHERE world_id = p_world_id;
END //

CREATE OR REPLACE PROCEDURE get_cities_in_world(IN p_world_id INT)
BEGIN
    SELECT c.city_id, c.city_name, c.x, c.y, c.owner_id, c.island_id
    FROM city c
    JOIN island i ON c.island_id = i.island_id
    WHERE i.world_id = p_world_id;
END //

-- Island Procedures

CREATE OR REPLACE PROCEDURE get_all_islands()
BEGIN
    SELECT island_id, x, y, world_id
    FROM island;
END //

CREATE OR REPLACE PROCEDURE get_island_by_id(IN p_island_id INT)
BEGIN
    SELECT island_id, x, y, world_id
    FROM island
    WHERE island_id = p_island_id;
END //

CREATE OR REPLACE PROCEDURE get_island_cities(IN p_island_id INT)
BEGIN
    SELECT city_id, city_name, x, y, owner_id
    FROM city
    WHERE island_id = p_island_id;
END //

-- City Procedures

CREATE OR REPLACE PROCEDURE get_all_cities()
BEGIN
    SELECT city_id, city_name, x, y, island_id, owner_id
    FROM city;
END //

CREATE OR REPLACE PROCEDURE get_city_by_id(IN p_city_id INT)
BEGIN
    SELECT city_id, city_name, x, y, island_id, owner_id
    FROM city
    WHERE id = p_city_id;
END //

CREATE OR REPLACE PROCEDURE get_city_buildings(IN p_city_id INT)
BEGIN
    SELECT building_id, building_name, building_level, max_level
    FROM building
    WHERE city_id = p_city_id;
END //

CREATE OR REPLACE PROCEDURE get_city_units(IN p_city_id INT)
BEGIN
    SELECT u.unit_id, u.unit_name, cu.quantity
    FROM unit u
    JOIN city_unit cu ON u.unit_id = cu.unit_id
    WHERE cu.city_id = p_city_id;
END //

-- Building Procedures

CREATE OR REPLACE PROCEDURE get_all_buildings()
BEGIN
    SELECT building_id, building_name, building_level, max_level, city_id
    FROM building;
END //

CREATE OR REPLACE PROCEDURE get_building_by_id(IN p_building_id INT)
BEGIN
    SELECT building_id, building_name, building_level, max_level, city_id
    FROM building
    WHERE id = p_building_id;
END //

CREATE OR REPLACE PROCEDURE get_building_prerequisites(IN p_building_id INT)
BEGIN
    SELECT prerequisite_id
    FROM building_prerequisite
    WHERE building_id = p_building_id;
END //

-- Unit Procedures

CREATE OR REPLACE PROCEDURE get_all_units()
BEGIN
    SELECT unit_id, unit_name, unit_description, unit_type, wood_cost, stone_cost, silver_cost,
        population_cost, training_time, damage, defense_blunt, defense_distance, defense_sharp,
        speed, can_fly
    FROM unit;
END //

CREATE OR REPLACE PROCEDURE get_unit_by_id(IN p_unit_id INT)
BEGIN
    SELECT unit_id, unit_name, unit_description, unit_type, wood_cost, stone_cost, silver_cost,
        population_cost, training_time, damage, defense_blunt, defense_distance, defense_sharp,
        speed, can_fly
    FROM unit
    WHERE id = p_unit_id;
END //

-- Battle Procedures

CREATE OR REPLACE PROCEDURE get_all_battles()
BEGIN
    SELECT battle_id, attacker_id, defender_id, battle_time, winner_id, loser_id, loot_wood,
        loot_stone, loot_silver
    FROM battle;
END //

CREATE OR REPLACE PROCEDURE get_battle_by_id(IN p_battle_id INT)
BEGIN
    SELECT battle_id, attacker_id, defender_id, battle_time, winner_id, loser_id, loot_wood,
        loot_stone, loot_silver
    FROM battle
    WHERE battle_id = p_battle_id;
END //

CREATE OR REPLACE PROCEDURE get_battle_units(IN p_battle_id INT)
BEGIN
    SELECT unit_id, quantity, side
    FROM battle_unit
    WHERE battle_id = p_battle_id;
END //

-- Miscellaneous Procedures

CREATE OR REPLACE PROCEDURE get_building_requirements(IN p_building_id INT)
BEGIN
    SELECT required_wood, required_stone, required_silver, required_population
    FROM building_requirement
    WHERE building_id = p_building_id;
END //

DELIMITER ;
