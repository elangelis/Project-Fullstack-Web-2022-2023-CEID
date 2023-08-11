


-- FINAL


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
    SELECT COUNT(id)            INTO @historycount_7      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY) AND product_id=in_product_id;

    if (@historycount>0) THEN

        SELECT SUM(product_price)   INTO @product_sum_7       FROM Archive_Product_History 
        WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 7 DAY) AND product_id=in_product_id;

        SET @mesitimiCount=@mesitimiCount+1;
    END IF;
    
    -- CURRENT DATE -6
    SET @historycount_6=0;
    SET @product_sum_6=0;
        
    SELECT COUNT(id)            INTO @historycount_6      FROM Archive_Product_History 
    WHERE date=DATE_SUB(CURRENT_DATE,INTERVAL 6 DAY) AND product_id=in_product_id;
    
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



CALL CalculateMesiTimiPrevious7Days(2,@k);
SELECT @k;




-- FINAL


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



-- FINAL



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




DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllOffersDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllOffersDetails()
BEGIN



SELECT 	o.id                    as offer_id,
        o.shop_id               as shop_id,
        s.name                  as shop_name,
        s.latitude              as latitude,
        s.longitude             as longitude,
        o.product_id            as product_id,
        p.name                  as product_name,
        o.product_price         as product_price,
        o.criteria_A            as criteriaA,
        o.criteria_B            as criteriaB,
        o.creation_date         as date,
        o.likes                 as likes,
        o.dislikes              as dislikes,
        o.has_stock             as stock,
        p.category_id           as category_id,
        p.subcategory_id        as subcategory_id,
        cat.name                as category_name,
        sub.name                as subcategory_name

FROM object_offer as o
INNER JOIN object_product as p ON p.id=o.product_id
INNER JOIN object_shop as s ON s.id=o.shop_id
INNER JOIN object_category as cat ON cat.id=p.category_id
INNER JOIN object_subcategory as sub ON sub.id=p.subcategory_id
GROUP BY o.id;


END$$

DELIMITER ;



DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllProductDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllProductDetails()
BEGIN

    SELECT * FROM object_product;

END$$
DELIMITER ;







DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllShopDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllShopDetails()
BEGIN

    SELECT * FROM object_shop;
    
END$$

DELIMITER ;





DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllUserDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllUserDetails()
BEGIN

    SELECT  u.id            AS user_id,
            u.name          AS name,
            u.username      AS username,
            u.password      AS password,
            u.email         AS email,
            u.first_name    AS firstname,
            u.last_name     AS lastname,
            u.date_creation AS creationdate,
            u.address       AS address,
            u.latitude      AS latitude,
            u.longitude     AS longitude,
            s.score         AS total_score

     FROM object_user AS u
     LEFT JOIN Archive_score_TOTAL AS s ON s.user_id=u.id;
    
END$$

DELIMITER ;





DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllUserOffers;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllUserOffers(IN in_user_id INTEGER)
BEGIN

    SELECT  o.id                    AS offer_id,
            o.shop_id               AS shop_id,
            s.name                   AS shop_name,
            o.product_id            AS product_id,
            p.name                AS product_name,
            o.has_stock             AS stock,
            o.creation_date         AS creation_date,
            o.expiration_date       AS expiration_date,
            o.creation_user_id      AS user_id,
            u.username               AS user_name,
            o.likes                 AS likes,
            o.dislikes              AS dislikes,
            o.product_price         AS offer_price
            
    FROM object_offer as o

    INNER JOIN object_shop      AS s    ON s.id     =   o.shop_id
    INNER JOIN object_product   AS p    ON p.id     =   o.product_id
    INNER JOIN object_user      AS u    ON u.id     =   o.creation_user_id
    
    WHERE o.creation_user_id    =   in_user_id
    GROUP BY o.id;
    
END$$

DELIMITER ;










-- FINAL

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




-- FINAL

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






DROP EVENT IF EXISTS EndMonth_TokenBank;

CREATE EVENT IF NOT EXISTS EndMonth_TokenBank ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-31 20:00:00' 
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL EndMonth_UpdateAllUserScore();



DELIMITER ;
DROP PROCEDURE IF EXISTS EndMonth_UpdateAllUserScore;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS EndMonth_UpdateAllUserScore()
BEGIN

    SET @user_count=0;
    
    SELECT COUNT(*) INTO @user_count FROM object_user;
    
    SELECT MAX(id)  INTO @user_max_id FROM object_user;
    SELECT MIN(id)  INTO @user_min_id FROM object_user;
    
  	SET @user_pointer=0;
    IF (@user_min_id IS NOT NULL) THEN
        SET @user_pointer=@user_min_id;
    END IF;

    SET @token_avail=0;
    SELECT token_AVAILABLE INTO @token_avail from Archive_token_BANK WHERE month_start=DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY) AND month_end=LAST_DAY(CURRENT_DATE);
    
    SET @score_month_TOTAL=0;
    SELECT SUM(score) INTO @score_month_TOTAL from Archive_user_score_history WHERE date>=DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY) AND date<=LAST_DAY(CURRENT_DATE);


    IF (@token_avail>0) THEN
        IF(@score_month_TOTAL)THEN
            WHILE (@user_pointer<@user_max_id) DO
    
                SET @user_score_percentage=0;
                SET @user_score_month=0;
                SET @user_token_TOTAL=0;

                SELECT SUM(score) INTO @user_score_month from Archive_user_score_history WHERE date>=DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY) AND date<=LAST_DAY(CURRENT_DATE) AND user_id=@user_pointer;

                IF (@user_score_month IS NOT NULL AND @user_score_month>0)THEN
                    
                    SELECT @user_score_month DIV @score_month_TOTAL INTO @user_score_percentage;

                    INSERT INTO Archive_score_MONTH (user_id,score) VALUES (@user_pointer,@user_score_month);

                    IF(@user_score_percentage>0)THEN
                        SET @user_token_TOTAL=@token_avail/@user_score_percentage;

                        INSERT INTO Archive_token_MONTH(user_id,token)VALUES(@user_pointer,@user_token_TOTAL);
                    ELSE
                        INSERT INTO Archive_token_MONTH(user_id,token)VALUES(@user_pointer,@user_token_TOTAL);
                    END IF;
                
                END IF;
                SET @user_pointer=@user_pointer+1;
            END WHILE;
        END IF;


    END IF;
END $$

DELIMITER ;





DROP EVENT IF EXISTS StartMonth_TokenBank;

CREATE EVENT IF NOT EXISTS StartMonth_TokenBank ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-01 00:00:01' 
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL StartMonth_UpdateTokenBankAvailableTokens();



-- FINAL


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


-- FINAL

DROP EVENT IF EXISTS Update_and_DeleteOffers;

CREATE EVENT IF NOT EXISTS Update_and_DeleteOffers ON SCHEDULE EVERY 1 DAY STARTS '2023-07-29 00:00:00' 
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL Update_DeleteExistingOffers();



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




DROP PROCEDURE IF EXISTS M_UpdateUserLatLong;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserLatLong`(IN `in_latitude` DECIMAL(12,7), IN `in_longitude` DECIMAL(12,7), IN `in_username` CHAR(255))
BEGIN
    UPDATE object_user 
    SET latitude=in_latitude, longitude=in_longitude
    WHERE username=in_username;
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS M_UpdateUserCredentials;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserCredentials`(IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255), IN `in_session_username` VARCHAR(255))
BEGIN
    UPDATE object_user 
    SET 
        username=in_username,
        password=in_password,
        email=in_email 
    WHERE username=in_session_username;    
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS M_UserCreation;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UserCreation`(IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255))
BEGIN
    INSERT INTO User(username,password,email)
    VALUES (in_username,in_password,in_email);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS F_GetOffersProductUser;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS F_GetOffersProductUser()
SELECT 	o.id,
		o.shop_id,
        o.product_id,
        o.product_price,
        o.criteria_A,
        o.criteria_B,
        o.creation_date,
        o.likes,
        o.dislikes,
        o.has_stock,
        p.name as productname,
        p.photourl as photo_url,
        p.photo_DATA as photoBlob,
        u.name as userfullname,
        u.username as username
FROM object_offer as o
INNER JOIN object_product as p ON p.id=o.product_id
INNER JOIN object_user AS u ON o.creation_user_id=u.id$$
DELIMITER ;

CALL F_GetOffersProductUser();