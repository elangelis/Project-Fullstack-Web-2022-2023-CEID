DELIMITER ;
DROP PROCEDURE IF EXISTS InsertPOIS;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InsertPOIS(IN shop_name VARCHAR(255),IN shop_description VARCHAR(255),IN shop_latitude VARCHAR(255),IN shop_longitude VARCHAR(255),IN shop_address VARCHAR(255))
BEGIN

    IF(shop_name IS NOT NULL AND shop_name!='')THEN
        IF(shop_latitude IS NOT NULL AND shop_latitude!='')THEN
            IF(shop_longitude IS NOT NULL AND shop_longitude!='')THEN

                SELECT CONVERT(shop_latitude,DECIMAL(10,7)) INTO @latitude;
                SELECT CONVERT(shop_longitude,DECIMAL(10,7)) INTO @longitude;
                
                SELECT COUNT(*) INTO @shop_count FROM object_shop WHERE latitude=@latitude AND longitude=@longitude;

                SELECT @shop_count;
                IF(@shop_count IS NOT NULL AND @shop_count=1)THEN 
                    SELECT id,name,address,description INTO @current_id,@current_name,@current_address,@current_description FROM object_shop WHERE latitude=@latitude AND longitude=@longitude;
                    IF(shop_address IS NOT NULL AND shop_address!='')THEN
                        UPDATE object_shop SET address=shop_address WHERE shop_id=@current_id;
                    END IF;
                    IF(shop_description IS NOT NULL AND shop_description!='')THEN
                        UPDATE object_shop SET description=shop_description WHERE shop_id=@current_id;
                    END IF;
                ELSE
                    INSERT INTO object_shop (name,description,latitude,longitude,address) VALUES (shop_name,shop_description,@latitude,@longitude,shop_address);
                END IF;
            END IF;
        END IF;
    END IF;


END$$

DELIMITER ;

CALL InsertPOIS('a','','1.000000','1.000000','');