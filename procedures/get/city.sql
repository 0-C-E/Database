-- Use the database
USE 0ce;

-- City Procedures

DELIMITER //

CREATE OR REPLACE PROCEDURE get_all_cities()
BEGIN
    SELECT city_id, city_name, island_id, owner_id
    FROM city;
END //

CREATE OR REPLACE PROCEDURE get_city_by_id(IN p_city_id INT)
BEGIN
    SELECT city_id, city_name, island_id, owner_id
    FROM city
    WHERE city_id = p_city_id;
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

DELIMITER ;
