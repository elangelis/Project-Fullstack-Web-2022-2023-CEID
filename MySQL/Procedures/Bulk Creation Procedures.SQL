

--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------CalculateMesiTimiPrevious7Days---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


DELIMITER ;
DROP PROCEDURE IF EXISTS CalculateMesiTimiPrevious7Days;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS CalculateMesiTimiPrevious7Days(IN in_product_id INT,OUT mesitimiweek DECIMAL (10,2))
BEGIN
    SET @mesitimitSUM=0;
    SET @mesitimiCount=7;


    -- CURRENT DATE -7
    SET @historycount_7=0;
    SET @product_sum_7=0;    
    SELECT COUNT(id)            INTO @historycount_7      FROM Archive_Product_History WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY) AND product_id=in_product_id;
    if (@historycount>0) THEN
        SELECT SUM(product_price)   INTO @product_sum_7       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;
    
    -- CURRENT DATE -6
    SET @historycount_6=0;
    SET @product_sum_6=0;
        
    SELECT COUNT(id)            INTO @historycount_6      FROM Archive_Product_History WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 6 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_6       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 6 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;

    -- CURRENT DATE -5
    SET @historycount_5=0;
    SET @product_sum_5=0;
        
    SELECT COUNT(id)            INTO @historycount_5      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 5 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_5       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 5 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;


    -- CURRENT DATE -4
    SET @historycount_4=0;
    SET @product_sum_4=0;
        
    SELECT COUNT(id)            INTO @historycount_4      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 4 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_4       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 4 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;


    -- CURRENT DATE -3
    SET @historycount_3=0;
    SET @product_sum_3=0;
        
    SELECT COUNT(id)            INTO @historycount_3      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 3 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_3       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 3 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;

    -- CURRENT DATE -2
    SET @historycount_2=0;
    SET @product_sum_2=0;
        
    SELECT COUNT(id)            INTO @historycount_2      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 2 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_2       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 2 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;

    -- CURRENT DATE -1
    SET @historycount_1=0;
    SET @product_sum_1=0;
        
    SELECT COUNT(id)            INTO @historycount_1      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_1       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 2 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;


    IF (@mesitimiCount IS NOT NULL OR @mesitimiCount>0)THEN
        SET @mesitimitSUM=@product_sum_1+@product_sum_2+@product_sum_3+@product_sum_4+@product_sum_5+@product_sum_6+@product_sum_7;
        SET mesitimiweek=ROUND(@mesitimitSUM / @mesitimiCount,2);
    ELSEIF(@mesitimiCount IS NULL OR @mesitimiCount=0)THEN
        SET mesitimiweek=0;
    END IF;


END$$

DELIMITER ;



--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------CalculateMesiTimiPreviousDay---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

DELIMITER ;
DROP PROCEDURE IF EXISTS CalculateMesiTimiPreviousDay;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS CalculateMesiTimiPreviousDay(IN in_product_id INT,OUT mesitimiday DECIMAL (10,2))
BEGIN

    SET @historycount=0;
    SET @product_sum=0;
        
    SELECT COUNT(id)            INTO @historycount      FROM Archive_Product_History WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY) AND product_id=in_product_id;
    SELECT SUM(product_price)   INTO @product_sum       FROM Archive_Product_History WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY) AND product_id=in_product_id;
    
    if (@historycount>0) THEN
        SET mesitimiday=ROUND(@product_sum/@historycount,2);
    ELSE
        SET mesitimiday=0;
    END IF;

END$$

DELIMITER ;

CALL CalculateMesiTimiPreviousDay(2,@k);
SELECT @k;


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------ChangeStockStatus---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//




DELIMITER ;
DROP PROCEDURE IF EXISTS ChangeStockStatus;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ChangeStockStatus(IN in_offer_id INTEGER,IN Available BOOLEAN)
BEGIN
    SET @COUNT=NULL;
    SELECT COUNT(*) INTO @COUNT FROM object_offer WHERE id=in_offer_id;
    IF(@COUNT IS NOT NULL AND @COUNT>0)THEN
        UPDATE offer SET has_stock=Available WHERE id=in_offer_id;
    END IF;
END$$
DELIMITER ;

CALL ChangeStockStatus(100,FALSE);


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------SubmitDislike---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


DELIMITER ;
DROP PROCEDURE IF EXISTS SubmitDislike;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS SubmitDislike(IN in_user_id INTEGER,IN in_offer_id INTEGER)
BEGIN

    SET @current_likes=NULL;
    SET @current_dislikes=NULL;
    SET @current_offerid=NULL;

    SET @userlike_id=NULL;


    SELECT dislikes,likes   INTO @current_dislikes, @current_likes          FROM object_offer         WHERE object_offer.id=in_offer_id;
    SELECT id,type          INTO @previousaction_id,@previousactiontype     FROM Archive_user_actions WHERE user_id=in_user_id AND offer_id=in_offer_id;


    IF(@current_likes IS NULL)THEN
        SET @current_likes=0;
    END IF;

    IF(@current_dislikes IS NULL)THEN
        SET @current_dislikes=0;
    END IF;

    
    IF(@previousaction_id IS NULL)THEN
        -- New record for User likes 
        INSERT INTO Archive_user_actions (user_id,offer_id,type,date) VALUES(in_user_id,in_offer_id,2,CURRENT_DATE);
        
        SET @current_dislikes=@current_dislikes+1;
        -- Update offer with one extra like and keep previous dislikes
        UPDATE object_offer SET likes=@current_likes,dislikes=@current_dislikes WHERE id=in_offer_id;

    ELSE
        
        IF(@previousactiontype=1)THEN
        -- Update previous Record of User Likes 
            UPDATE Archive_user_actions SET type=2 WHERE user_id=in_user_id AND offer_id=in_offer_id;
        
            SET @current_likes=@current_likes-1;
            SET @current_dislikes=@current_dislikes+1;
        
            UPDATE object_offer SET likes=@current_likes,dislikes=@current_dislikes WHERE id=in_offer_id;

        END IF;
    END IF;

END$$
DELIMITER ;


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------SubmitLike---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


DELIMITER ;
DROP PROCEDURE IF EXISTS SubmitLike;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS SubmitLike(IN in_user_id INTEGER,IN in_offer_id INTEGER)
BEGIN

     SET @current_likes=NULL;
    SET @current_dislikes=NULL;
    SET @current_offerid=NULL;

    SET @userlike_id=NULL;


    SELECT dislikes,likes   INTO @current_dislikes, @current_likes          FROM object_offer         WHERE object_offer.id=in_offer_id;
    SELECT id,type          INTO @previousaction_id,@previousactiontype     FROM Archive_user_actions WHERE user_id=in_user_id AND offer_id=in_offer_id;


    IF(@current_likes IS NULL)THEN
        SET @current_likes=0;
    END IF;

    IF(@current_dislikes IS NULL)THEN
        SET @current_dislikes=0;
    END IF;

    
    IF(@previousaction_id IS NULL)THEN
        -- New record for User likes 
        INSERT INTO Archive_user_actions (user_id,offer_id,type,date) VALUES(in_user_id,in_offer_id,1,CURRENT_DATE);
        
        SET @current_dislikes=@current_dislikes+1;
        -- Update offer with one extra like and keep previous dislikes
        UPDATE object_offer SET likes=@current_likes,dislikes=@current_dislikes WHERE id=in_offer_id;

    ELSE
        
        IF(@previousactiontype=2)THEN
        -- Update previous Record of User Likes 
            UPDATE Archive_user_actions SET type=1 WHERE user_id=in_user_id AND offer_id=in_offer_id;
        
            SET @current_likes=@current_likes+1;
            SET @current_dislikes=@current_dislikes-1;
        
            UPDATE object_offer SET likes=@current_likes,dislikes=@current_dislikes WHERE id=in_offer_id;

        END IF;
    END IF;

END$$
DELIMITER ;

--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------SubmitOffer---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL


DELIMITER ;
DROP PROCEDURE IF EXISTS SubmitOffer;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS SubmitOffer(IN in_shop_id INTEGER,IN in_product_id INTEGER, IN in_user_id INTEGER, IN in_price DECIMAL (7,2))
BEGIN
	INSERT INTO object_offer    (shop_id,
                                product_id,
                                creation_user_id,
                                product_price,
                                creation_date,
                                expiration_date,
                                has_stock,
                                likes,
                                dislikes) 

                    VALUES      (in_shop_id,
                                in_product_id,
                                in_user_id,
                                in_price,
                                CURRENT_DATE,
                                DATE_ADD(CURRENT_DATE,INTERVAL 7 DAY),
                                1,
                                0,
                                0);

END$$
DELIMITER ;

CALL SubmitOffer(1,1,1,12);




--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Update_DeleteExistingOffers---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

-- THIS PROCEDURE Updates Offer that offer's price is less than mesitimi day or mesitimi week
-- OR deletes the offers that have already expired

DELIMITER ;
DROP PROCEDURE IF EXISTS Update_DeleteExistingOffers;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Update_DeleteExistingOffers()
BEGIN

	SET @offer_max_id=0;	
	SET @offer_min_id=0;	

    SET @current_offer_productid=NULL;
    SET @current_offer_price=NULL;


    -- GET MAX id and MIN id From Offers expiring today
    SELECT MAX(id) 	INTO @offer_max_id 	FROM object_offer WHERE expiration_date<=CURRENT_DATE;
    SELECT MIN(id) 	INTO @offer_min_id 	FROM object_offer WHERE expiration_date<=CURRENT_DATE;
    
    set @offer_counter=@offer_min_id;

    WHILE (@offer_counter<=@offer_max_id) DO

        SET @current_offer_productid=NULL;
        SET @current_offer_price=NULL;
        SET @current_offer_id=NULL;

        -- GET id,productid,productprice
        SELECT product_price,product_id,offer.id INTO @current_offer_price,@current_offer_productid,@current_offer_id FROM object_offer WHERE id=@offer_counter;

        IF (@current_offer_productid IS NOT NULL)THEN
            IF (@current_offer_price IS NOT NULL)THEN
                
                SET @mesitimiweek=NULL;                
                SET @mesitimiday=NULL;
                -- Get mesitimi previous 7 days
                CALL CalculateMesiTimiPrevious7Days(@current_offer_productid,@mesitimiweek);
                -- Get mesitimi previous day
                CALL CalculateMesiTimiPreviousDay(@current_offer_productid,@mesitimiday);

                IF(@mesitimiweek IS NOT NULL)THEN
                    -- Compare to mesitimiweek
                    IF(@current_offer_price<=@mesitimiweek)THEN
                        -- Update Current offer to new expiration Date
                        UPDATE object_offer SET expiration_date=DATE_ADD(CURRENT_DATE,INTERVAL 7 DAY)WHERE id=@current_offer_id AND expiration_date<=CURRENT_DATE;
                    END IF;
                ELSEIF(@mesitimiday IS NOT NULL)THEN
                    -- Compare to mesitimiday
                    IF(@current_offer_price<=@mesitimiday)THEN
                        -- Update Current offer to new expiration Date
                        UPDATE object_offer SET expiration_date=DATE_ADD(CURRENT_DATE,INTERVAL 7 DAY)WHERE id=@current_offer_id AND expiration_date<=CURRENT_DATE;
                    END IF;    
                END IF;
            END IF;
        END IF;
        SET @offer_counter=@offer_counter+1;
    
    END WHILE;
    -- DELETE ALL OFFERS THAT DIDNT UPDATE AND ARE STILL EXPIRING TODAY 
    DELETE FROM object_offer WHERE expiration_date<=CURRENT_DATE;

END$$

DELIMITER ;

CALL Update_DeleteExistingOffers();


-- INSERT INTO offer (offer.product_id,offer.shop_id,offer.creation_user_id,offer.product_price,offer.expiration_date)
-- VALUES	(1,1,1,5,DATE_SUB(CURRENT_DATE,INTERVAL 8 DAY));

--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------StartMonth_UpdateTokenBankAvailableTokens---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

DELIMITER ;
DROP PROCEDURE IF EXISTS StartMonth_UpdateTokenBankAvailableTokens;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS StartMonth_UpdateTokenBankAvailableTokens()
BEGIN

    SELECT COUNT(*) INTO @user_count FROM object_user;
    IF (@user_count IS NULL)THEN
        SET @user_count=0;
    END IF;



    SET @tokenAVAILABLE=0;
    SET @tokenTOTAL=0;

    IF (@user_count>0)THEN
        SET @tokenTOTAL=@user_count*100;
        SET @tokenAVAILABLE=FLOOR((80/100)*100);
    END IF;

    INSERT INTO Archive_token_BANK (users_count,token_TOTAL,token_AVAILABLE,date_created,datetime_created) VALUES (@user_count,@tokenTOTAL,@tokenAVAILABLE,CURRENT_DATE,CURRENT_TIMESTAMP);

END $$

DELIMITER ;



--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------ChangeStockStatus---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------ChangeStockStatus---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------ChangeStockStatus---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------ChangeStockStatus---------------------=------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//