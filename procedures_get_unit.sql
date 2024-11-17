-- Use the database
USE 0ce;

-- Unit Procedures

DELIMITER //

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

DELIMITER ;
