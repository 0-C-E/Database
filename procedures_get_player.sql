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
    SELECT c.city_id, c.city_name, c.island_id
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

DELIMITER ;
