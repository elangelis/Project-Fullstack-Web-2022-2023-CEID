


-- FINAL


DELIMITER ;
DROP PROCEDURE IF EXISTS CalculateMesiTimiPrevious7Days;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS CalculateMesiTimiPrevious7Days(IN in_product_id INT,OUT mesitimiweek DECIMAL (10,2))
BEGIN

    SET @mesitimitSUM=0;
    SET @mesitimiCount=7;
    SET @datefilterlow=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY);
    SET @datefilterhigh=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY);
    
    SELECT SUM(mesi_timi) INTO @mesitimi_sumcase1 FROM Archive_Product_MesiTimi WHERE product_id=in_product_id and date BETWEEN @datefilterlow AND @datefilterhigh;
    SELECT COUNT(*) INTO @mesitimi_count1 FORM Archive_Product_MesiTimi WHERE product_id=in_product_id and date BETWEEN @datefilterlow AND @datefilterhigh;
    
    IF (@mesitimi_count1 IS NOT NULL AND @mesitimi_count1>0) THEN

        SET mesitimiweek=ROUND(@mesitimi_sumcase1 / @mesitimi_count1,2);
    
    ELSEIF(@mesitimi_count1 IS NULL OR @mesitimi_count1=0)THEN

        -- CURRENT DATE -7
        SET @historycount_7=0;
        SET @product_sum_7=0;    
        SELECT COUNT(id)            INTO @historycount_7      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY) AND product_id=in_product_id;

        if (@historycount_7>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_7       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;
        
        -- CURRENT DATE -6
        SET @historycount_6=0;
        SET @product_sum_6=0;
            
        SELECT COUNT(id)            INTO @historycount_6      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 6 DAY) AND product_id=in_product_id;
        
        if (@historycount_6>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_6       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 6 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;

        -- CURRENT DATE -5
        SET @historycount_5=0;
        SET @product_sum_5=0;
            
        SELECT COUNT(id)            INTO @historycount_5      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 5 DAY) AND product_id=in_product_id;
        
        if (@historycount_5>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_5       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 5 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;


        -- CURRENT DATE -4
        SET @historycount_4=0;
        SET @product_sum_4=0;
            
        SELECT COUNT(id)            INTO @historycount_4      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 4 DAY) AND product_id=in_product_id;
        
        if (@historycount_4>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_4       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 4 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;


        -- CURRENT DATE -3
        SET @historycount_3=0;
        SET @product_sum_3=0;
            
        SELECT COUNT(id)            INTO @historycount_3      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 3 DAY) AND product_id=in_product_id;
        
        if (@historycount_3>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_3       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 3 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;

        -- CURRENT DATE -2
        SET @historycount_2=0;
        SET @product_sum_2=0;
            
        SELECT COUNT(id)            INTO @historycount_2      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 2 DAY) AND product_id=in_product_id;
        
        if (@historycount_2>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_2       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 2 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;

        -- CURRENT DATE -1
        SET @historycount_1=0;
        SET @product_sum_1=0;
            
        SELECT COUNT(id)            INTO @historycount_1      FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY) AND product_id=in_product_id;
        
        if (@historycount_1>0) THEN

            SELECT SUM(product_price)   INTO @product_sum_1       FROM Archive_Product_History 
            WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY) AND product_id=in_product_id;

            SET @mesitimiCount=@mesitimiCount+1;
        END IF;


        IF (@mesitimiCount IS NOT NULL OR @mesitimiCount>0)THEN
            SET @mesitimitSUM=@product_sum_1+@product_sum_2+@product_sum_3+@product_sum_4+@product_sum_5+@product_sum_6+@product_sum_7;
            SET mesitimiweek=ROUND(@mesitimitSUM / @mesitimiCount,2);
        ELSEIF(@mesitimiCount IS NULL OR @mesitimiCount=0)THEN
            SET mesitimiweek=0;
        END IF;



    END IF;





   


END$$

DELIMITER ;



CALL CalculateMesiTimiPrevious7Days(2,@k);
SELECT @k;