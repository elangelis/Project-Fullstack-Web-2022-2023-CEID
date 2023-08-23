


DELIMITER ;
DROP PROCEDURE IF EXISTS ADMIN_InsertProductPrices;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ADMIN_InsertProductPrices(IN in_product_id VARCHAR(255),IN in_product_name VARCHAR(255),IN in_price VARCHAR(255),IN in_date VARCHAR(255))
BEGIN
    -- CHECK IF VARIABELS ARE NOT EMPTY OR NULL

    IF (in_product_id IS NOT NULL AND in_product_id !='') THEN
        IF(in_product_name IS NOT NULL AND in_product_name !='')THEN
            IF(in_price IS NOT NULL AND in_price !='')THEN
                IF(in_date IS NOT NULL AND in_date !='')THEN

                    -- SELECT id INTO @category_id from object_category WHERE ekat_id=sub_cat_id;
                    SELECT COUNT(*) INTO @product_count From object_product WHERE name=in_product_name;
                    IF(@product_count=1)THEN
                         SELECT id INTO @product_id from object_product WHERE name=in_product_name;
                         
                         SELECT COUNT(*) INTO @COUNT FROM archive_product_mesitimi WHERE product_id=@product_id AND date=in_date;

                         IF (@COUNT IS NULL OR @COUNT=0)THEN
                              INSERT INTO  archive_product_mesitimi (product_id,mesi_timi,date) VALUES (@product_id,in_price,in_date);
                         ELSEIF (@COUNT=1)THEN
                              SELECT mesi_timi INTO @oldmesi_timi FROM archive_product_mesitimi WHERE product_id=@product_id AND date=in_date;
                              IF(@oldmesi_timi!=in_price)THEN
                                   UPDATE archive_product_mesitimi SET mesi_timi=in_price WHERE product_id=@product_id AND date=in_date;
                              END IF;
                         END IF;

                    ELSEIF(@product_count IS NULL OR @product_count=0)THEN
                         INSERT INTO object_product(name) VALUES (in_product_name);
                         SELECT id INTO @product_id from object_product WHERE name=in_product_name;
                         SELECT COUNT(*) INTO @COUNT FROM archive_product_mesitimi WHERE product_id=@product_id AND date=in_date;

                         IF (@COUNT IS NULL OR @COUNT=0)THEN
                              INSERT INTO  archive_product_mesitimi (product_id,mesi_timi,date) VALUES (@product_id,in_price,in_date);
                         END IF;
                    END IF;
                    
                END IF;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

CALL ADMIN_InsertProductPrices('','','','');