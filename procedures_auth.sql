-- Use the database
USE 0ce;

-- Player Procedures

DELIMITER //

CREATE OR REPLACE PROCEDURE register_player(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_hashed_password VARBINARY(255),
    IN p_salt VARBINARY(16)
)
BEGIN
    DECLARE name_exists INT;
    DECLARE email_exists INT;

    -- Check if the player name already exists
    SELECT COUNT(*) INTO name_exists
    FROM player
    WHERE player_name = p_name;

    IF name_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Player name already exists';
    END IF;

    -- Check if the email already exists
    SELECT COUNT(*) INTO email_exists
    FROM player
    WHERE email = p_email;

    IF email_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;

    -- Insert the new player record
    INSERT INTO player (player_name, email, hashed_password, salt)
    VALUES (p_name, p_email, p_hashed_password, p_salt);
END //

CREATE OR REPLACE PROCEDURE login_player(
    IN p_email VARCHAR(100)
)
BEGIN
    -- Check if the player exists
    IF NOT EXISTS (
        SELECT 1
        FROM player
        WHERE email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Player not found';
    END IF;

    -- Retrieve the hashed password and salt as a result set
    SELECT hashed_password, salt
    FROM player
    WHERE email = p_email;
END //

DELIMITER ;
