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

CREATE OR REPLACE PROCEDURE get_building_prerequisites(IN p_building_id INT)
BEGIN
    SELECT prerequisite_id
    FROM building_prerequisite
    WHERE building_id = p_building_id;
END //

-- This procedure is used to get the requirements for a building
CREATE OR REPLACE PROCEDURE get_building_requirements(IN p_building_id INT)
BEGIN
    SELECT required_wood, required_stone, required_silver, required_population
    FROM building_requirement
    WHERE building_id = p_building_id;
END //

DELIMITER ;
