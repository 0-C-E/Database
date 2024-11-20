-- Use the database
USE 0ce;

-- Building Procedures

DELIMITER //

CREATE OR REPLACE PROCEDURE get_all_buildings()
BEGIN
    SELECT building_id, building_name, building_level, max_level, city_id
    FROM building;
END //

CREATE OR REPLACE PROCEDURE get_building_by_id(IN p_building_id INT)
BEGIN
    SELECT building_id, building_name, building_level, max_level, city_id
    FROM building
    WHERE building_id = p_building_id;
END //

CREATE OR REPLACE PROCEDURE get_building_upgrade_requirements(
    IN p_building_id INT,
    IN target_level INT
)
BEGIN
    -- Check if the building level is valid
    DECLARE max_building_level INT;

    SELECT max_level INTO max_building_level
    FROM building
    WHERE building_id = p_building_id;

    IF target_level > max_building_level THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Target level exceeds maximum building level.';
    END IF;

    -- Fetch required resources
    SELECT
        br.required_wood,
        br.required_stone,
        br.required_silver,
        br.required_population
    FROM building_requirement br
    WHERE br.building_id = p_building_id AND br.building_level = target_level;

    -- Fetch prerequisite buildings
    SELECT
        bp.prerequisite_building_id,
        b.building_name AS prerequisite_building_name,
        bp.building_level AS required_level
    FROM building_prerequisite bp
    JOIN building b ON bp.prerequisite_building_id = b.building_id
    WHERE bp.building_id = p_building_id AND bp.building_level = target_level;

END //

DELIMITER ;
