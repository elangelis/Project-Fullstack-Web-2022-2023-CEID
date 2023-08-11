


DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllShopDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllShopDetails()
BEGIN

    SELECT * FROM object_shop;
    
END$$

DELIMITER ;


