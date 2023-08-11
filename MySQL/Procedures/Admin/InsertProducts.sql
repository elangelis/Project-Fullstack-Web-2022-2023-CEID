


DELIMITER ;
DROP PROCEDURE IF EXISTS ADMIN_InsertProducts;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ADMIN_InsertProducts(IN product_id VARCHAR(255),IN product_name VARCHAR(255),IN product_cat_id VARCHAR(255),IN product_sub_id VARCHAR(255))
BEGIN
    -- CHECK IF VARIABELS ARE NOT EMPTY OR NULL

    IF (product_id IS NOT NULL AND product_id !='') THEN
        IF(product_name IS NOT NULL AND product_name !='')THEN
            IF(product_cat_id IS NOT NULL AND product_cat_id !='')THEN
                IF(product_sub_id IS NOT NULL AND product_sub_id !='')THEN

                    -- SELECT id INTO @category_id from object_category WHERE ekat_id=sub_cat_id;
                    SELECT id INTO @category_id from object_category WHERE ekat_id=product_cat_id;
                    SELECT id INTO @subcategory_id from object_subcategory WHERE ekat_id=product_sub_id;

                    SELECT count(*) INTO @COUNT FROM object_product WHERE name=product_name OR ekat_id=product_id;
                    
                    IF (@COUNT IS NULL OR @COUNT=0)THEN
                        INSERT INTO  object_product (name,ekat_id,ekat_cat_id,ekat_sub_id,category_id,subcategory_id) VALUES (product_name,product_id,product_cat_id,product_sub_id,@category_id,@subcategory_id);
                    ELSEIF (@COUNT=1)THEN
                        SELECT id,name,ekat_id,ekat_cat_id,ekat_sub_id INTO @current_id,@current_name,@current_ekatid,@current_cat_id,@current_sub_id FROM object_product WHERE name=product_name OR ekat_id=product_id;
                        
                        IF(@current_name IS NOT NULL AND @current_name!=product_name)THEN
                            UPDATE object_product SET name=product_name,ekat_cat_id=product_cat_id,ekat_sub_id=product_sub_id WHERE id=@current_id;
                        ELSEIF(@current_ekatid IS NOT NULL AND@current_ekatid!=product_id)THEN
                            UPDATE object_product SET ekat_id=product_id,ekat_cat_id=product_cat_id, ekat_sub_id=product_sub_id WHERE id=@current_id;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

CALL ADMIN_InsertProducts('','','','');