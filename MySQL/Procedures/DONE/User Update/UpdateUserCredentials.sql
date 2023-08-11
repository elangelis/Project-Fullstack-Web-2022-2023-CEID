
DROP PROCEDURE IF EXISTS M_UpdateUserCredentials;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserCredentials`(IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255), IN `in_session_username` VARCHAR(255))
BEGIN
    UPDATE object_user 
    SET 
        username=in_username,
        password=in_password,
        email=in_email 
    WHERE username=in_session_username;    
END$$
DELIMITER ;