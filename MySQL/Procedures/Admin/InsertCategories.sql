


DELIMITER ;
DROP PROCEDURE IF EXISTS ADMIN_InsertCategories;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ADMIN_InsertCategories(IN cat_id VARCHAR(255),IN cat_name VARCHAR(255))
BEGIN
    -- CHECK IF VARIABELS ARE NOT EMPTY OR NULL

    IF (cat_id IS NOT NULL AND cat_id !='') THEN
        IF(cat_name IS NOT NULL AND cat_name !='')THEN

            SELECT count(*) INTO @COUNT FROM object_category WHERE name=cat_name OR ekat_id=cat_id;
            IF (@COUNT IS NULL OR @COUNT=0)THEN
                INSERT INTO  object_category (name,ekat_id) VALUES (cat_name,cat_id);
            ELSEIF (@COUNT=1)THEN
                SELECT name,ekat_id INTO @current_name,@current_ekatid FROM object_category WHERE name=cat_name OR ekat_id=cat_id;
                IF(@current_name IS NOT NULL AND @current_name!=cat_name)THEN
                    UPDATE object_category SET name=cat_name WHERE ekat_id=cat_id;
                ELSEIF(@current_ekatid IS NOT NULL AND@current_ekatid!=cat_id)THEN
                    UPDATE object_category SET ekat_id=cat_id WHERE name=cat_name;
                END IF;
            END IF;
        END IF;
    END IF;
        
END$$

DELIMITER ;

CALL ADMIN_InsertCategories('','');