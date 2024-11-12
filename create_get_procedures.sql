-- Use the database
USE 0ce;

-- Player Procedures

DELIMITER //

CREATE PROCEDURE get_all_players()
BEGIN
    SELECT player_id, player_name, email, gold, created_at, last_login FROM player;
END //

CREATE PROCEDURE get_player_by_id(IN player_id INT)
BEGIN
    SELECT player_id, player_name, email, gold, created_at, last_login
    FROM player
    WHERE id = player_id;
END //

CREATE PROCEDURE get_player_by_name(IN player_name VARCHAR(100))
BEGIN
    SELECT player_id, player_name, email, gold, created_at, last_login
    FROM player
    WHERE player_name = player_name;
END //

CREATE PROCEDURE get_player_worlds(IN player_id INT)
BEGIN
    SELECT w.world_id, w.world_name, w.world_description, w.created_at
    FROM world w
    JOIN player_world pw ON w.world_id = pw.world_id
    WHERE pw.player_id = player_id;
END //

CREATE PROCEDURE get_player_cities(IN player_id INT)
BEGIN
    SELECT c.city_id, c.city_name, c.x, c.y, c.island_id
    FROM city c
    WHERE c.owner_id = player_id;
END //

-- World Procedures

CREATE PROCEDURE get_all_worlds()
BEGIN
    SELECT world_id, world_name, world_description, seed, action_speed, unit_speed, trade_speed,
        night_bonus, beginner_protection, morale, alliance_cap, world_status, created_at
    FROM world;
END //

CREATE PROCEDURE get_world_by_id(IN world_id INT)
BEGIN
    SELECT world_id, world_name, world_description, seed, action_speed, unit_speed, trade_speed,
        night_bonus, beginner_protection, morale, alliance_cap, world_status, created_at
    FROM world
    WHERE world_id = world_id;
END //

CREATE PROCEDURE get_active_worlds()
BEGIN
    SELECT world_id, world_name, world_description, created_at
    FROM world
    WHERE STATUS = 1;
END //

CREATE PROCEDURE get_players_in_world(IN world_id INT)
BEGIN
    SELECT p.player_id, p.player_name, p.email, p.gold, p.created_at
    FROM player p
    JOIN player_world pw ON p.player_id = pw.player_id
    WHERE pw.world_id = world_id;
END //

CREATE PROCEDURE get_world_islands(IN world_id INT)
BEGIN
    SELECT island_id, x, y
    FROM island
    WHERE world_id = world_id;
END //

-- Island Procedures

CREATE PROCEDURE get_all_islands()
BEGIN
    SELECT island_id, x, y, world_id
    FROM island;
END //

CREATE PROCEDURE get_island_by_id(IN island_id INT)
BEGIN
    SELECT island_id, x, y, world_id
    FROM island
    WHERE island_id = island_id;
END //

CREATE PROCEDURE get_island_cities(IN island_id INT)
BEGIN
    SELECT city_id, city_name, x, y, owner_id
    FROM city
    WHERE island_id = island_id;
END //

-- City Procedures

CREATE PROCEDURE get_all_cities()
BEGIN
    SELECT city_id, city_name, x, y, island_id, owner_id
    FROM city;
END //

CREATE PROCEDURE get_city_by_id(IN city_id INT)
BEGIN
    SELECT city_id, city_name, x, y, island_id, owner_id
    FROM city
    WHERE id = city_id;
END //

CREATE PROCEDURE get_cities_in_world(IN world_id INT)
BEGIN
    SELECT c.city_id, c.city_name, c.x, c.y, c.owner_id, c.island_id
    FROM city c
    JOIN island i ON c.island_id = i.island_id
    WHERE i.world_id = world_id;
END //

-- Building Procedures

CREATE PROCEDURE get_all_buildings()
BEGIN
    SELECT building_id, building_name, building_level, max_level, city_id
    FROM building;
END //

CREATE PROCEDURE get_city_buildings(IN city_id INT)
BEGIN
    SELECT building_id, building_name, building_level, max_level
    FROM building
    WHERE city_id = city_id;
END //

CREATE PROCEDURE get_building_by_id(IN building_id INT)
BEGIN
    SELECT building_id, building_name, building_level, max_level, city_id
    FROM building
    WHERE id = building_id;
END //

CREATE PROCEDURE get_building_prerequisites(IN building_id INT)
BEGIN
    SELECT prerequisite_id
    FROM building_prerequisite
    WHERE building_id = building_id;
END //

-- Unit Procedures

CREATE PROCEDURE get_all_units()
BEGIN
    SELECT unit_id, unit_name, unit_description, unit_type, wood_cost, stone_cost, silver_cost,
        population_cost, training_time, damage, defense_blunt, defense_distance, defense_sharp,
        speed, can_fly
    FROM unit;
END //

CREATE PROCEDURE get_city_units(IN city_id INT)
BEGIN
    SELECT u.unit_id, u.unit_name, cu.quantity
    FROM unit u
    JOIN city_unit cu ON u.unit_id = cu.unit_id
    WHERE cu.city_id = city_id;
END //

CREATE PROCEDURE get_unit_by_id(IN unit_id INT)
BEGIN
    SELECT unit_id, unit_name, unit_description, unit_type, wood_cost, stone_cost, silver_cost,
        population_cost, training_time, damage, defense_blunt, defense_distance, defense_sharp,
        speed, can_fly
    FROM unit
    WHERE id = unit_id;
END //

-- Battle Procedures

CREATE PROCEDURE get_all_battles()
BEGIN
    SELECT battle_id, attacker_id, defender_id, battle_time, winner_id, loser_id, loot_wood,
        loot_stone, loot_silver
    FROM battle;
END //

CREATE PROCEDURE get_battle_by_id(IN battle_id INT)
BEGIN
    SELECT battle_id, attacker_id, defender_id, battle_time, winner_id, loser_id, loot_wood,
        loot_stone, loot_silver
    FROM battle
    WHERE id = battle_id;
END //

CREATE PROCEDURE get_player_battles(IN player_id INT)
BEGIN
    SELECT battle_id, attacker_id, defender_id, battle_time, winner_id, loser_id, loot_wood,
        loot_stone, loot_silver
    FROM battle
    WHERE attacker_id = player_id OR defender_id = player_id;
END //

CREATE PROCEDURE get_battle_units(IN battle_id INT)
BEGIN
    SELECT unit_id, quantity, side
    FROM battle_unit
    WHERE battle_id = battle_id;
END //

-- Miscellaneous Procedures

CREATE PROCEDURE get_building_requirements(IN building_id INT)
BEGIN
    SELECT required_wood, required_stone, required_silver, required_population
    FROM building_requirement
    WHERE building_id = building_id;
END //

DELIMITER ;
