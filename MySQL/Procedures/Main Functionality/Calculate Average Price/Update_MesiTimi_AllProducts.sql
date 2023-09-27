DROP EVENT IF EXISTS Update_MesiTimi_AllProducts;

CREATE EVENT IF NOT EXISTS Update_MesiTimi_AllProducts ON SCHEDULE EVERY 1 DAY STARTS '2023-08-31 20:00:00' 
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL Update_MesiTimi_AllProducts_PreviousDay();



DELIMITER ;
DROP PROCEDURE IF EXISTS Update_MesiTimi_AllProducts_PreviousDay;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Update_MesiTimi_AllProducts_PreviousDay()
BEGIN

     SELECT MAX(id) INTO @max_id FROM object_product;

     SET @pointer_1=0;

     IF (@max_id IS NOT NULL) THEN
          WHILE (@pointer_1<=@max_id) DO
               SELECT COUNT(*) INTO @count FROM object_product WHERE id=@pointer_1;
               IF (@count IS NOT NULL AND @count>=1) THEN
                    CALL CalculateMesiTimiPreviousDay(@pointer_1,@mesitimi);
               END IF;
               SET  @pointer_1 =     @pointer_1     +    1;
          END WHILE;
     END IF;
END$$
DELIMITER ;

CALL Update_MesiTimi_AllProducts_PreviousDay();