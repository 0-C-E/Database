-- Use the database
USE 0ce;

-- Island Procedures

DELIMITER //

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
    SELECT city_id, city_name, owner_id
    FROM city
    WHERE island_id = p_island_id;
END //

DELIMITER ;
