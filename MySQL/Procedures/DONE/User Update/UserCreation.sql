
DROP PROCEDURE IF EXISTS M_UserCreation;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UserCreation`(IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255))
BEGIN
    INSERT INTO User(username,password,email)
    VALUES (in_username,in_password,in_email);
END$$
DELIMITER ;