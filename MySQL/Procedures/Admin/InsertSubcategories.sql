


DELIMITER ;
DROP PROCEDURE IF EXISTS ADMIN_InsertSubcategories;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ADMIN_InsertSubcategories(IN subcat_id VARCHAR(255),IN subcat_name VARCHAR(255),IN sub_cat_id VARCHAR(255))
BEGIN
    -- CHECK IF VARIABELS ARE NOT EMPTY OR NULL

    IF (subcat_id IS NOT NULL AND subcat_id !='') THEN
        IF(subcat_name IS NOT NULL AND subcat_name !='')THEN
            IF(subcat_name IS NOT NULL AND subcat_name !='')THEN

                SELECT id INTO @category_id from object_category WHERE ekat_id=sub_cat_id;


                SELECT count(*) INTO @COUNT FROM object_subcategory WHERE name=subcat_name OR ekat_id=subcat_id;
                IF (@COUNT IS NULL OR @COUNT=0)THEN
                    INSERT INTO  object_subcategory (name,ekat_id,ekat_cat_id,category_id) VALUES (subcat_name,subcat_id,sub_cat_id,@category_id);
                ELSEIF (@COUNT=1)THEN
                    SELECT name,ekat_id,ekat_cat_id,id INTO @current_name,@current_ekatid,@current_cat_id,@sub_id FROM object_subcategory WHERE name=subcat_name OR ekat_id=subcat_id;
                    IF(@current_name IS NOT NULL AND @current_name!=subcat_name)THEN
                        UPDATE object_subcategory SET name=subcat_name,ekat_cat_id=sub_cat_id WHERE id=@sub_id;
                    ELSEIF(@current_ekatid IS NOT NULL AND@current_ekatid!=subcat_id)THEN
                        UPDATE object_subcategory SET ekat_id=subcat_id,ekat_cat_id=sub_cat_id WHERE id=@sub_id;
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

CALL ADMIN_InsertSubcategories('','','');