

-- FINAL


DELIMITER ;
DROP PROCEDURE IF EXISTS CalculateMesiTimiPreviousDay;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS CalculateMesiTimiPreviousDay(IN in_product_id INT,OUT mesitimiday DECIMAL (10,2))
BEGIN

    SET @datefilter	=	DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY);
    SELECT COUNT(*) INTO @count0 FROM Archive_Product_MesiTimi WHERE date=@datefilter AND product_id=in_product_id;

    IF(@count0 IS NOT NULL AND @count0=1) THEN 
        
        SELECT mesi_timi INTO @previousmesitimi FROM Archive_Product_MesiTimi WHERE date=@datefilter AND product_id=in_product_id;
        IF (@previousmesitimi IS NOT NULL)THEN
            SET @mesitimiday=@previousmesitimi;
        ELSEIF(@previousmesitimi IS NULL)THEN
            SET @historycount=0;
            SET @product_sum=0;
        END IF;

    ELSEIF(@count0  IS NULL OR @count0=0)THEN
        SET @historycount=0;
        SET @product_sum=0;

        SELECT COUNT(id)            INTO @historycount      FROM Archive_Product_History WHERE date=@datefilter AND product_id=in_product_id;
        SELECT SUM(product_price)   INTO @product_sum       FROM Archive_Product_History WHERE date=@datefilter AND product_id=in_product_id;
        
        IF (@historycount>0) THEN
            SET @mesitimiday=ROUND(@product_sum/@historycount,2);
            SELECT COUNT(*) INTO @count1 FROM Archive_Product_MesiTimi WHERE date=@datefilter AND product_id=in_product_id;
            
            IF (@count1 IS NOT NULL AND @count1=1)THEN
                SELECT mesi_timi INTO @previousmesitimi FROM Archive_Product_MesiTimi WHERE date=@datefilter AND product_id=in_product_id;
                IF (@previousmesitimi != @mesitimiday)THEN 
                    UPDATE Archive_Product_MesiTimi SET mesi_timi= @mesitimiday WHERE product_id=in_product_id and date=@datefilter;
                END IF;
            ELSEIF(@count1 IS NULL OR @count1=0)THEN
                INSERT INTO Archive_Product_MesiTimi (product_id,mesi_timi,date) VALUES(in_product_id, @mesitimiday,@datefilter);
            END IF;
        ELSEIF(@historycount IS NULL OR @historycount=0)THEN
            SET  @mesitimiday=NULL;
        END IF;
    END IF;
    SET mesitimiday= @mesitimiday;
END$$

DELIMITER ;

CALL CalculateMesiTimiPreviousDay(30,@k);
SELECT @k;