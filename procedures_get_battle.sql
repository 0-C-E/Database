-- Use the database
USE 0ce;

-- Battle Procedures

DELIMITER //

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

DELIMITER ;
