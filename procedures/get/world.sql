-- Use the database
USE 0ce;

-- World Procedures

DELIMITER //

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
    SELECT c.city_id, c.city_name, c.owner_id, c.island_id
    FROM city c
    JOIN island i ON c.island_id = i.island_id
    WHERE i.world_id = p_world_id;
END //

DELIMITER ;
