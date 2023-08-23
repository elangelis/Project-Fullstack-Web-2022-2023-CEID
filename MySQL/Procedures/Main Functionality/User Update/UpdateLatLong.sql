
DROP PROCEDURE IF EXISTS M_UpdateUserLatLong;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserLatLong`(IN `in_latitude` DECIMAL(12,7), IN `in_longitude` DECIMAL(12,7), IN `in_username` CHAR(255))
BEGIN
    UPDATE object_user 
    SET latitude=in_latitude, longitude=in_longitude
    WHERE username=in_username;
END$$
DELIMITER ;