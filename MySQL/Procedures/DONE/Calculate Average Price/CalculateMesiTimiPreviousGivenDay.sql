

-- NOT NEEDED NOT FINAL KEPT IN CASE WE NEED


DELIMITER ;
DROP PROCEDURE IF EXISTS CalculateMesiTimiPreviousGivenDay;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS CalculateMesiTimiPreviousGivenDay(IN in_product_id INT,IN givenday INTEGER,OUT mesitimiday DECIMAL (10,2))
BEGIN

    SET @historycount=0;
    SET @product_sum=0;
    SET @datefilter=DATE_SUB(CURRENT_DATE,INTERVAL givenday DAY);
        
    SELECT COUNT(id)            INTO @historycount      FROM Archive_Product_History WHERE date=@datefilter AND product_id=in_product_id;
    SELECT SUM(product_price)   INTO @product_sum       FROM Archive_Product_History WHERE date=@datefilter AND product_id=in_product_id;
    
    if (@historycount>0) THEN
        SET mesitimiday=ROUND(@product_sum/@historycount,2);
    ELSE
        SET mesitimiday=0;
    END IF;

END$$

DELIMITER ;

CALL CalculateMesiTimiPreviousGivenDay(2,2,@k);
SELECT @k;