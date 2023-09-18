-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Εξυπηρετητής: 127.0.0.1
-- Χρόνος δημιουργίας: 18 Σεπ 2023 στις 19:02:54
-- Έκδοση διακομιστή: 10.4.27-MariaDB
-- Έκδοση PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Βάση δεδομένων: `webproject2022`
--

DELIMITER $$
--
-- Διαδικασίες
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADMIN_InsertCategories` (IN `cat_id` VARCHAR(255), IN `cat_name` VARCHAR(255))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ADMIN_InsertProductPrices` (IN `in_product_id` VARCHAR(255), IN `in_product_name` VARCHAR(255), IN `in_price` VARCHAR(255), IN `in_date` VARCHAR(255))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ADMIN_InsertProducts` (IN `product_id` VARCHAR(255), IN `product_name` VARCHAR(255), IN `product_cat_id` VARCHAR(255), IN `product_sub_id` VARCHAR(255))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ADMIN_InsertSubcategories` (IN `subcat_id` VARCHAR(255), IN `subcat_name` VARCHAR(255), IN `sub_cat_id` VARCHAR(255))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateMesiTimiPrevious7Days` (IN `in_product_id` INT, OUT `mesitimiweek` DECIMAL(10,2))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateMesiTimiPreviousDay` (IN `in_product_id` INT, OUT `mesitimiday` DECIMAL(10,2))   BEGIN

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `ChangeOfferStockStatus` (IN `in_offer_id` INTEGER, IN `Available` BOOLEAN)   BEGIN
    SET @COUNT=NULL;
    SELECT COUNT(*) INTO @COUNT FROM object_offer WHERE id=in_offer_id;
    IF(@COUNT IS NOT NULL AND @COUNT>0)THEN
        UPDATE object_offer SET has_stock=Available WHERE id=in_offer_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllHistoryLikesUser` (IN `in_user_id` INTEGER)   BEGIN

    SELECT  
            user_likes.user_id          AS user_id,
            u1.username                 AS user_name,
            user_likes.has_Like         AS was_like,
            user_likes.has_dislike      AS was_dislike,
            user_likes.action           AS action,
            user_likes.date             AS action_date,
            offer.id                    AS offer_id,
            offer.shop_id               AS shop_id,
            shop.name                   AS shop_name,
            offer.creation_user_id      AS publisher_id,
            offer.product_id            AS product_id,
            product.name                AS product_name,
            offer.expiration_date       AS offer_expir_date,
            offer.creation_date         AS offer_create_date,
            offer.has_stock             AS stock,
            offer.likes                 AS likes,
            offer.dislikes              AS dislikes,
            offer.product_price         AS offer_price,
            u2.id                       AS publisher_id,
            u2.username                 AS publisher_name
            
    
    FROM user_likes
    INNER JOIN offer ON offer.id=user_likes.offer_id
    INNER JOIN shop ON shop.id=offer.shop_id
    INNER JOIN product ON product.id=offer.product_id
    INNER JOIN user as u1 ON u1.id=user_likes.user_id
    INNER JOIN user as u2 ON u2.id=offer.creation_user_id
    WHERE user_likes.user_id=in_user_id;    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllOffersDetails` ()   BEGIN



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

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllProductDetails` ()   BEGIN

    SELECT * FROM object_product;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllShopDetails` ()   BEGIN

    SELECT * FROM object_shop;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllUserDetails` ()   BEGIN

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
            IFNULL((SELECT score FROM archive_score_TOTAL as st WHERE st.user_id=u.id LIMIT 1),0) AS total_score

     FROM object_user AS u;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllUserLeaderboard` ()   BEGIN

    SELECT 	u.username                                              as username,
    		CONCAT( u.first_name, " ", u.last_name )                as full_name,
            u.date_creation                                         as date_created,
            IFNULL(s.score,0)                                       as total_score,
            
			IFNULL(( SELECT COUNT(*) FROM object_offer as o WHERE o.creation_user_id=u.id),0)                    as offers,
            -- COUNT(o.id)                                             as offers,
			( SELECT COUNT(*) FROM archive_user_actions as a WHERE user_id = u.id AND type = 1 )                    as likes,
			( SELECT COUNT(*) FROM archive_user_actions as a WHERE user_id = u.id AND type = 2 )                    as dislikes,
            IFNULL( (SELECT token FROM Archive_token_MONTH as tm WHERE tm.user_id = u.id AND tm.month_start<=CURRENT_DATE AND tm.month_end>=CURRENT_DATE LIMIT 1),0)    as current_tokens,
            IFNULL(( SELECT tokens FROM Archive_token_TOTAL as tt WHERE tt.user_id = u.id LIMIT 1),0)                                                                   as total_tokens
            
			      
    FROM object_user as u
    INNER JOIN archive_score_total   as s on s.user_id=u.id
	-- INNER  JOIN object_offer          	as o on o.creation_user_id=u.id
    GROUP BY u.id
    ORDER BY total_score DESC;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllUserLikes` (IN `userid` INTEGER)   BEGIN
     IF(userid IS NOT NULL AND userid!=0)THEN
          SELECT	ua.id                    as action_id,
                    ua.offer_id              as offer_id,
                    ua.date                  as date,
                    ua.type                  as action,
                    off.product_price        as product_price,
                    sh.name                  as shop_name,
                    IFNULL(sh.address,0)     as shop_address,
                    uc.username              as offer_user

          FROM object_user AS u
          INNER JOIN archive_user_actions    as ua     ON ua.user_id  =    u.id
          INNER JOIN object_offer            as off    ON off.id      =    ua.offer_id
          INNER JOIN object_shop             as sh     ON sh.id       =    off.shop_id
          INNER JOIN object_user             as uc     ON uc.id       =    off.creation_user_id
          WHERE u.id=1;
     END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllUserOffers` (IN `in_user_id` INTEGER)   BEGIN

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_UserScores` (IN `userid` INTEGER)   BEGIN
     IF(userid IS NOT NULL AND userid!=0)THEN
          SELECT    u.username               as  username,
                    u.password               as  password,
                    IFNULL(st.score,0)       as  score_total,
                    IFNULL(sm.score,0)       as  score_month,
                    IFNULL(tt.tokens,0)      as  tokens_total,
                    IFNULL(tm.token,0)       as  tokens_month

          FROM object_user as u
          LEFT JOIN archive_score_total as st ON st.user_id=userid 
          LEFT JOIN archive_score_month as sm ON sm.user_id=userid
          LEFT JOIN archive_token_total as tt ON tt.user_id=userid
          LEFT JOIN archive_token_month as tm ON tm.user_id=userid
          WHERE u.id=userid LIMIT 1;
     END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAllData` ()   BEGIN   

    DELETE FROM Archive_token_BANK;
    DELETE FROM Archive_score_MONTH;
    DELETE FROM Archive_score_TOTAL;
    DELETE FROM Archive_token_MONTH;
    DELETE FROM Archive_token_TOTAL;
    DELETE FROM object_admin;
    DELETE FROM Archive_Product_MesiTimi;
    DELETE FROM Archive_user_score_history;
    DELETE FROM Archive_Product_History;
    DELETE FROM Archive_user_actions;
    DELETE FROM object_offer;
    DELETE FROM object_product;
    DELETE FROM object_shop;
    DELETE FROM object_subcategory;
    DELETE FROM object_category;
    DELETE FROM object_user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAllPOIS` ()   BEGIN

    DELETE FROM object_shop;
    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EndMonth_UpdateAllUserScore` ()   BEGIN

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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `F_GetOffersProductUser` ()   BEGIN

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
          IFNULL(p.photo_DATA,"empty") as photoBlob,
          u.name as userfullname,
          u.username as username,
          IFNULL((SELECT score FROM archive_score_TOTAL as st WHERE st.user_id=u.id LIMIT 1),0) AS  userscore

     FROM object_offer as o
     INNER JOIN object_product as p ON p.id=o.product_id
     INNER JOIN object_user AS u ON o.creation_user_id=u.id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPOIS` (IN `shop_name` VARCHAR(255), IN `shop_description` VARCHAR(255), IN `shop_latitude` VARCHAR(255), IN `shop_longitude` VARCHAR(255), IN `shop_address` VARCHAR(255))   BEGIN

    IF(shop_name IS NOT NULL AND shop_name!='')THEN
        IF(shop_latitude IS NOT NULL AND shop_latitude!='')THEN
            IF(shop_longitude IS NOT NULL AND shop_longitude!='')THEN

                SELECT CONVERT(shop_latitude,DECIMAL(10,7)) INTO @latitude;
                SELECT CONVERT(shop_longitude,DECIMAL(10,7)) INTO @longitude;
                
                SELECT COUNT(*) INTO @shop_count FROM object_shop WHERE latitude=@latitude AND longitude=@longitude;

                SELECT @shop_count;
                IF(@shop_count IS NOT NULL AND @shop_count=1)THEN 
                    SELECT id,name,address,description INTO @current_id,@current_name,@current_address,@current_description FROM object_shop WHERE latitude=@latitude AND longitude=@longitude;
                    IF(shop_address IS NOT NULL AND shop_address!='')THEN
                        UPDATE object_shop SET address=shop_address WHERE shop_id=@current_id;
                    END IF;
                    IF(shop_description IS NOT NULL AND shop_description!='')THEN
                        UPDATE object_shop SET description=shop_description WHERE shop_id=@current_id;
                    END IF;
                ELSE
                    INSERT INTO object_shop (name,description,latitude,longitude,address) VALUES (shop_name,shop_description,@latitude,@longitude,shop_address);
                END IF;
            END IF;
        END IF;
    END IF;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserCredentials` (IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255), IN `in_session_username` VARCHAR(255))   BEGIN
    UPDATE object_user 
    SET 
        username=in_username,
        password=in_password,
        email=in_email 
    WHERE username=in_session_username;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserLatLong` (IN `in_latitude` DECIMAL(12,7), IN `in_longitude` DECIMAL(12,7), IN `in_username` CHAR(255))   BEGIN
    UPDATE object_user 
    SET latitude=in_latitude, longitude=in_longitude
    WHERE username=in_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UserCreation` (IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255))   BEGIN
    INSERT INTO object_user(username,password,email)
    VALUES (in_username,in_password,in_email);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `StartMonth_UpdateTokenBankAvailableTokens` ()   BEGIN

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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SubmitDislike` (IN `in_user_id` INTEGER, IN `in_offer_id` INTEGER)   BEGIN

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SubmitLike` (IN `in_user_id` INTEGER, IN `in_offer_id` INTEGER)   BEGIN

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SubmitOffer` (IN `in_shop_id` INTEGER, IN `in_product_id` INTEGER, IN `in_user_id` INTEGER, IN `in_price` DECIMAL(7,2))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_DeleteExistingOffers` ()   BEGIN

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
        SELECT product_price,product_id,id INTO @current_offer_price,@current_offer_productid,@current_offer_id FROM object_offer WHERE id=@offer_counter;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `UserScoreAndTokens` (IN `userid` INTEGER)   BEGIN
     IF(userid IS NOT NULL AND userid!=0)THEN
          SELECT    u.username  as  username,
                    u.password  as  password,
                    st.score    as  score_total,
                    sm.score    as  score_month,
                    tt.tokens   as  tokens_total,
                    tm.token    as  tokens_month

          FROM object_user as u
          LEFT JOIN archive_score_total as st ON st.user_id=userid 
          LEFT JOIN archive_score_month as sm ON sm.user_id=userid
          LEFT JOIN archive_token_total as tt ON tt.user_id=userid
          LEFT JOIN archive_token_month as tm ON tm.user_id=userid
          WHERE u.id=userid;
     END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_product_history`
--

CREATE TABLE `archive_product_history` (
  `id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_product_history`
--

INSERT INTO `archive_product_history` (`id`, `shop_id`, `product_id`, `product_price`, `date`) VALUES
(1, 1, 1, '4.75', '2023-09-13'),
(2, 1, 2, '4.75', '2023-09-13'),
(3, 1, 3, '4.75', '2023-09-13'),
(4, 1, 4, '4.75', '2023-09-13'),
(5, 1, 5, '4.75', '2023-09-13'),
(6, 1, 6, '4.75', '2023-09-13'),
(7, 3, 1, '4.75', '2023-09-13'),
(8, 3, 2, '4.75', '2023-09-13'),
(9, 4, 11, '4.75', '2023-09-13'),
(10, 4, 13, '4.75', '2023-09-13'),
(11, 4, 12, '4.75', '2023-09-13'),
(12, 4, 5, '4.75', '2023-09-13'),
(13, 4, 6, '4.75', '2023-09-13'),
(14, 4, 7, '4.75', '2023-09-13'),
(15, 5, 8, '4.75', '2023-09-13'),
(16, 5, 7, '4.75', '2023-09-13'),
(17, 5, 6, '4.75', '2023-09-13'),
(18, 5, 5, '4.75', '2023-09-13'),
(19, 5, 4, '4.75', '2023-09-13'),
(20, 5, 3, '4.75', '2023-09-13'),
(21, 5, 2, '4.75', '2023-09-13'),
(22, 8, 1, '4.75', '2023-09-13'),
(23, 9, 1, '4.75', '2023-09-13'),
(24, 10, 1, '4.75', '2023-09-13'),
(25, 11, 1, '4.75', '2023-09-13'),
(26, 12, 1, '4.75', '2023-09-13'),
(27, 13, 1, '4.75', '2023-09-13'),
(28, 14, 1, '4.75', '2023-09-13'),
(31, 17, 1, '4.75', '2023-09-13'),
(32, 18, 1, '4.75', '2023-09-13'),
(33, 19, 1, '4.75', '2023-09-13'),
(34, 20, 1, '4.75', '2023-09-13'),
(36, 22, 1, '4.75', '2023-09-13'),
(37, 23, 1, '4.75', '2023-09-13'),
(50, 16, 1, '4.75', '2023-09-13'),
(57, 24, 1, '4.75', '2023-09-13'),
(60, 369, 39, '121.00', '2023-09-13'),
(69, 15, 1, '4.75', '2023-09-13'),
(70, 25, 36, '123.00', '2023-09-13'),
(71, 21, 1, '4.75', '2023-09-13'),
(72, 1274, 1123, '1552.00', '2023-09-14'),
(73, 23, 1, '4.75', '2023-09-14');

--
-- Δείκτες `archive_product_history`
--
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord` BEFORE INSERT ON `archive_product_history` FOR EACH ROW BEGIN

    SET new.date=CURRENT_DATE;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_product_mesitimi`
--

CREATE TABLE `archive_product_mesitimi` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `mesi_timi` decimal(10,2) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_product_mesitimi`
--

INSERT INTO `archive_product_mesitimi` (`id`, `product_id`, `mesi_timi`, `date`) VALUES
(1, 796, '1.04', '2022-11-15'),
(2, 796, '1.01', '2022-11-16'),
(3, 796, '1.02', '2022-11-17'),
(4, 796, '1.00', '2022-11-18'),
(5, 796, '0.99', '2022-11-19'),
(6, 797, '2.08', '2022-11-15'),
(7, 797, '1.91', '2022-11-16'),
(8, 797, '2.12', '2022-11-17'),
(9, 797, '2.11', '2022-11-18'),
(10, 797, '2.11', '2022-11-19'),
(11, 799, '2.03', '2022-11-15'),
(12, 799, '1.95', '2022-11-16'),
(13, 799, '1.93', '2022-11-17'),
(14, 799, '1.94', '2022-11-18'),
(15, 799, '1.85', '2022-11-19');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_score_month`
--

CREATE TABLE `archive_score_month` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `score` int(10) UNSIGNED DEFAULT 0,
  `date_created` date DEFAULT curdate(),
  `month_start` date DEFAULT NULL,
  `month_end` date DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_score_month`
--

INSERT INTO `archive_score_month` (`id`, `user_id`, `score`, `date_created`, `month_start`, `month_end`, `month`, `year`) VALUES
(1, 1, 20000, '2023-09-13', '2023-09-01', '2023-09-30', 9, 2023);

--
-- Δείκτες `archive_score_month`
--
DELIMITER $$
CREATE TRIGGER `OnAfterInsertArchiveScoreMonth_InsertUpdateScoreTotal` AFTER INSERT ON `archive_score_month` FOR EACH ROW BEGIN

    SET @count=0;
    SELECT COUNT(*) INTO @count FROM Archive_score_TOTAL WHERE user_id=new.user_id;
    -- check if record exists
    IF (@count IS NOT NULL AND @count>0) THEN
        -- modify previous one
        SELECT SUM(score) INTO @prev_score FROM Archive_score_TOTAL WHERE user_id=new.user_id;
        SET @new_score=@prev_score+new.score;
        UPDATE Archive_score_TOTAL SET score=@new_score WHERE user_id=new.user_id;
    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_score_TOTAL (user_id,score)VALUES(new.user_id,new.score);
    END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertArchiveScoreMonth_ModifyDatesCurrentRecord` BEFORE INSERT ON `archive_score_month` FOR EACH ROW BEGIN

    SET @month_start =   DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY);
    SET @month_end   =   LAST_DAY(CURRENT_DATE);
    SET @month       =   MONTH(CURRENT_DATE);
    SET @year        =   YEAR(CURRENT_DATE);

    SET new.month_start=@month_start;
    SET new.month_end=@month_end;
    SET new.month=@month;
    SET new.year=@year;
    SET new.date_created=CURRENT_DATE;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_score_total`
--

CREATE TABLE `archive_score_total` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `score` int(10) UNSIGNED DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_score_total`
--

INSERT INTO `archive_score_total` (`id`, `user_id`, `score`) VALUES
(1, 1, 20000),
(2, 2, 0),
(3, 3, 0),
(4, 4, 0),
(5, 1, 25000);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_token_bank`
--

CREATE TABLE `archive_token_bank` (
  `id` int(11) NOT NULL,
  `users_count` int(11) DEFAULT 0,
  `token_TOTAL` int(11) DEFAULT 0,
  `token_AVAILABLE` int(11) DEFAULT 0,
  `date_created` date NOT NULL DEFAULT curdate(),
  `datetime_created` datetime DEFAULT current_timestamp(),
  `month_start` date DEFAULT NULL,
  `month_end` date DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Δείκτες `archive_token_bank`
--
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertArchiveTokenBANK_ModifyDatesCurrentRecord` BEFORE INSERT ON `archive_token_bank` FOR EACH ROW BEGIN

    SET @month_start =   DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY);
    SET @month_end   =   LAST_DAY(CURRENT_DATE);
    SET @month       =   MONTH(CURRENT_DATE);
    SET @year        =   YEAR(CURRENT_DATE);

    SET new.month_start=@month_start;
    SET new.month_end=@month_end;
    SET new.month=@month;
    SET new.year=@year;
    SET new.date_created=CURRENT_DATE;
    SET new.datetime_created=CURRENT_TIMESTAMP;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_token_month`
--

CREATE TABLE `archive_token_month` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` int(10) UNSIGNED DEFAULT 0,
  `date_created` date DEFAULT curdate(),
  `month_start` date DEFAULT NULL,
  `month_end` date DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_token_month`
--

INSERT INTO `archive_token_month` (`id`, `user_id`, `token`, `date_created`, `month_start`, `month_end`, `month`, `year`) VALUES
(1, 1, 200, '2023-09-13', '2023-09-01', '2023-09-30', 9, 2023);

--
-- Δείκτες `archive_token_month`
--
DELIMITER $$
CREATE TRIGGER `OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal` AFTER INSERT ON `archive_token_month` FOR EACH ROW BEGIN

    SET @count=0;
    SELECT COUNT(*) INTO @count FROM Archive_token_TOTAL WHERE user_id=new.user_id;
    -- check if record exists
    IF (@count IS NOT NULL AND @count>0) THEN
        -- modify previous one
        SELECT SUM(tokens) INTO @prev_tokens FROM Archive_token_TOTAL WHERE user_id=new.user_id;
        
        SET @new_tokens=@prev_tokens+new.token;
        
        UPDATE Archive_token_TOTAL SET tokens=@new_score WHERE user_id=new.user_id;

    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_token_TOTAL (user_id,tokens)VALUES(new.user_id,new.token);
    
    END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertArchivetokenMONTH_ModifyDatesCurrentRecord` BEFORE INSERT ON `archive_token_month` FOR EACH ROW BEGIN

    SET @month_start =   DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY);
    SET @month_end   =   LAST_DAY(CURRENT_DATE);
    SET @month       =   MONTH(CURRENT_DATE);
    SET @year        =   YEAR(CURRENT_DATE);

    SET new.month_start=@month_start;
    SET new.month_end=@month_end;
    SET new.month=@month;
    SET new.year=@year;
    SET new.date_created=CURRENT_DATE;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_token_total`
--

CREATE TABLE `archive_token_total` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tokens` int(10) UNSIGNED DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_token_total`
--

INSERT INTO `archive_token_total` (`id`, `user_id`, `tokens`) VALUES
(1, 1, 200),
(2, 1, 800);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_user_actions`
--

CREATE TABLE `archive_user_actions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `date` date DEFAULT current_timestamp(),
  `type` enum('like','dislike') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_user_actions`
--

INSERT INTO `archive_user_actions` (`id`, `user_id`, `offer_id`, `date`, `type`) VALUES
(10, 1, 30, '2023-09-13', 'dislike'),
(13, 1, 38, '2023-09-13', 'like'),
(14, 1, 39, '2023-09-13', 'like'),
(17, 1, 29, '2023-09-13', 'like'),
(18, 1, 35, '2023-09-13', 'like'),
(19, 1, 37, '2023-09-14', 'like');

--
-- Δείκτες `archive_user_actions`
--
DELIMITER $$
CREATE TRIGGER `OnAfterInsertUserActions_InsertIntoUserScoreHistory` AFTER INSERT ON `archive_user_actions` FOR EACH ROW BEGIN
    IF (new.type=1) THEN
        INSERT INTO Archive_user_score_history (user_id,offer_id,user_likes_id,date,score) 
            VALUES(new.user_id,new.offer_id,new.id,CURRENT_TIMESTAMP,5);
    ELSEIF (new.type=2) THEN
        INSERT INTO Archive_user_score_history (user_id,offer_id,user_likes_id,date,score) 
            VALUES(new.user_id,new.offer_id,new.id,CURRENT_TIMESTAMP,-1);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterInsertUserActions_UpdateLikeDislikeOffer` AFTER INSERT ON `archive_user_actions` FOR EACH ROW BEGIN
    IF (new.type=1) THEN
        SELECT likes INTO @oldlikes FROM object_offer where object_offer.id = new.offer_id;
        SET @newlikes=@oldlikes+1;
        UPDATE object_offer SET likes=@newlikes WHERE id = new.offer_id;

    ELSEIF (new.type=2) THEN
        SELECT dislikes INTO @olddislikes FROM object_offer where object_offer.id = new.offer_id;
        SET @newdislikes=@olddislikes+1;
        UPDATE object_offer SET dislikes=@newdislikes WHERE id = new.offer_id;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterUpdateUserActions_UpdateIntoUserScoreHistory` BEFORE DELETE ON `archive_user_actions` FOR EACH ROW BEGIN
    
    SELECT id,score INTO @oldlikeid,@score FROM Archive_user_score_history where user_id=old.user_id AND user_likes_id=old.id;

    IF (@oldlikeid IS NOT NULL)THEN
        SET @newscore=0-@score;
        INSERT INTO Archive_user_score_history (user_id,score,date,offer_id,user_likes_id) VALUES (old.user_id,@newscore,CURRENT_DATE,old.offer_id,old.id);
    END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnBeforeDeleteUserActions_UpdateLikeDislikeOffer` BEFORE DELETE ON `archive_user_actions` FOR EACH ROW BEGIN
    IF (old.type=1) THEN
        SELECT likes INTO @oldlikes FROM object_offer where object_offer.id = old.offer_id;
        SET @newlikes=@oldlikes-1;
        UPDATE object_offer SET likes=@newlikes WHERE id = old.offer_id;

    ELSEIF (old.type=2) THEN
        SELECT dislikes INTO @olddislikes FROM object_offer where object_offer.id = old.offer_id;
        SET @newdislikes=@olddislikes-1;
        UPDATE object_offer SET dislikes=@newdislikes WHERE id = old.offer_id;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertUserActions_ModifyDateCurrentRecord` BEFORE INSERT ON `archive_user_actions` FOR EACH ROW BEGIN
    SET new.date=CURRENT_TIMESTAMP;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_user_score_history`
--

CREATE TABLE `archive_user_score_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `user_likes_id` int(11) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `score` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `archive_user_score_history`
--

INSERT INTO `archive_user_score_history` (`id`, `user_id`, `offer_id`, `user_likes_id`, `date`, `score`) VALUES
(1, 1, 30, 2, '2023-09-13 02:21:52', -1),
(2, 1, 30, 2, '2023-09-13 00:00:00', 1),
(3, 1, 30, 3, '2023-09-13 02:21:56', 5),
(4, 1, 30, 3, '2023-09-13 00:00:00', -5),
(5, 1, 30, 4, '2023-09-13 02:21:59', -1),
(6, 1, 30, NULL, '2023-09-13 02:22:19', 50),
(7, 1, 30, NULL, '2023-09-13 02:22:27', 50),
(8, 1, 30, 4, '2023-09-13 00:00:00', 1),
(9, 1, 30, 5, '2023-09-13 02:22:29', 5),
(10, 1, 30, NULL, '2023-09-13 02:22:45', 50),
(11, 1, 30, NULL, '2023-09-13 02:22:51', 50),
(12, 1, 30, 5, '2023-09-13 00:00:00', -5),
(13, 1, 30, 6, '2023-09-13 02:22:55', -1),
(14, 1, 30, 6, '2023-09-13 00:00:00', 1),
(15, 1, 30, NULL, '2023-09-13 02:29:52', 50),
(16, 1, 30, 7, '2023-09-13 02:29:52', 5),
(17, 1, 30, NULL, '2023-09-13 02:29:52', 50),
(18, 1, 30, 7, '2023-09-13 00:00:00', -5),
(19, 1, 30, NULL, '2023-09-13 02:30:00', 50),
(20, 1, 30, 8, '2023-09-13 02:30:00', -1),
(21, 1, 30, NULL, '2023-09-13 02:30:00', 50),
(22, 1, 30, 8, '2023-09-13 00:00:00', 1),
(23, 1, 30, NULL, '2023-09-13 02:30:08', 50),
(24, 1, 30, 9, '2023-09-13 02:30:08', 5),
(25, 1, 30, NULL, '2023-09-13 02:30:08', 50),
(26, 1, 30, 9, '2023-09-13 00:00:00', -5),
(27, 1, 30, NULL, '2023-09-13 02:30:17', 50),
(28, 1, 30, 10, '2023-09-13 02:30:17', -1),
(29, 1, 30, NULL, '2023-09-13 02:30:17', 50),
(30, 1, 38, NULL, '2023-09-13 02:32:40', 50),
(31, 1, 38, NULL, '2023-09-13 02:32:44', 50),
(32, 1, 38, 11, '2023-09-13 02:32:45', 5),
(33, 1, 38, NULL, '2023-09-13 02:32:45', 50),
(34, 1, 38, 11, '2023-09-13 00:00:00', -5),
(35, 1, 38, NULL, '2023-09-13 02:32:51', 50),
(36, 1, 38, 12, '2023-09-13 02:32:51', -1),
(37, 1, 38, NULL, '2023-09-13 02:32:51', 50),
(38, 1, 38, 12, '2023-09-13 00:00:00', 1),
(39, 1, 38, NULL, '2023-09-13 02:32:54', 50),
(40, 1, 38, 13, '2023-09-13 02:32:54', 5),
(41, 1, 38, NULL, '2023-09-13 02:32:54', 50),
(42, 1, 39, NULL, '2023-09-13 02:33:31', 50),
(43, 1, 39, NULL, '2023-09-13 02:33:37', 50),
(44, 1, 39, 14, '2023-09-13 02:34:11', 5),
(45, 1, 39, NULL, '2023-09-13 02:34:11', 50),
(46, 1, 29, 15, '2023-09-13 20:58:53', 5),
(47, 1, 29, NULL, '2023-09-13 20:58:53', 50),
(48, 1, 29, 15, '2023-09-13 00:00:00', -5),
(49, 1, 29, NULL, '2023-09-13 20:59:05', 50),
(50, 1, 29, 16, '2023-09-13 20:59:05', -1),
(51, 1, 29, NULL, '2023-09-13 20:59:05', 50),
(52, 1, 29, 16, '2023-09-13 00:00:00', 1),
(53, 1, 29, NULL, '2023-09-13 20:59:13', 50),
(54, 1, 29, 17, '2023-09-13 20:59:13', 5),
(55, 1, 29, NULL, '2023-09-13 20:59:13', 50),
(56, 1, 29, NULL, '2023-09-13 20:59:22', 50),
(57, 1, 29, NULL, '2023-09-13 20:59:30', 50),
(58, 1, 29, NULL, '2023-09-13 20:59:36', 50),
(59, 1, 29, NULL, '2023-09-13 20:59:38', 50),
(60, 1, 40, NULL, '2023-09-13 21:00:30', 50),
(61, 1, 35, 18, '2023-09-13 21:05:35', 5),
(62, 1, 35, NULL, '2023-09-13 21:05:35', 50),
(63, 1, 41, NULL, '2023-09-14 21:57:31', 50),
(64, 1, 37, 19, '2023-09-14 23:00:48', 5);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_admin`
--

CREATE TABLE `object_admin` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) DEFAULT '',
  `password` varchar(255) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `first_name` varchar(255) DEFAULT '',
  `last_name` varchar(255) DEFAULT '',
  `isAdmin` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_admin`
--

INSERT INTO `object_admin` (`id`, `username`, `password`, `email`, `name`, `first_name`, `last_name`, `isAdmin`) VALUES
('', 'admin', 'admin', 'admin@admin', '', '', '', 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_category`
--

CREATE TABLE `object_category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `ekat_id` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_category`
--

INSERT INTO `object_category` (`id`, `name`, `description`, `ekat_id`) VALUES
(1, 'Βρεφικά Είδη', '', '8016e637b54241f8ad242ed1699bf2da'),
(2, 'Ποτά - Αναψυκτικά', '', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(3, 'Καθαριότητα', '', 'd41744460283406a86f8e4bd5010a66d'),
(4, 'Προσωπική φροντίδα', '', '8e8117f7d9d64cf1a931a351eb15bd69'),
(5, 'Τρόφιμα', '', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(6, 'Αντισηπτικά', '', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6'),
(7, 'Προστασία Υγείας', '', '2d5f74de114747fd824ca8a6a9d687fa'),
(8, 'Για κατοικίδια', '', '662418cbd02e435280148dbb8892782a');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_offer`
--

CREATE TABLE `object_offer` (
  `id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `has_stock` tinyint(1) DEFAULT 1,
  `creation_date` date DEFAULT curdate(),
  `expiration_date` date DEFAULT NULL,
  `criteria_A` tinyint(1) DEFAULT 0,
  `criteria_B` tinyint(1) DEFAULT 0,
  `creation_user_id` int(11) DEFAULT NULL,
  `likes` int(11) DEFAULT 0,
  `dislikes` int(11) DEFAULT 0,
  `product_price` decimal(7,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_offer`
--

INSERT INTO `object_offer` (`id`, `shop_id`, `product_id`, `has_stock`, `creation_date`, `expiration_date`, `criteria_A`, `criteria_B`, `creation_user_id`, `likes`, `dislikes`, `product_price`) VALUES
(1, 1, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(2, 1, 2, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(3, 1, 3, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(4, 1, 4, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(5, 1, 5, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(6, 1, 6, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(7, 3, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(8, 3, 2, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(9, 4, 11, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(10, 4, 13, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(11, 4, 12, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(12, 4, 5, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(13, 4, 6, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(14, 4, 7, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(15, 5, 8, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(16, 5, 7, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(17, 5, 6, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(18, 5, 5, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(19, 5, 4, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(20, 5, 3, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(21, 5, 2, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(22, 8, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(23, 9, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(24, 10, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(25, 11, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(26, 12, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(27, 13, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(28, 14, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(29, 15, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 16, 3, '4.75'),
(30, 16, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(31, 17, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(32, 18, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(33, 19, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(34, 20, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(35, 21, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 16, 3, '4.75'),
(36, 22, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 15, 3, '4.75'),
(37, 23, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 16, 3, '4.75'),
(38, 24, 1, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 16, 3, '4.75'),
(39, 369, 39, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 1, 0, '121.00'),
(40, 25, 36, 1, '2023-09-13', '2023-09-20', 0, 0, 1, 0, 0, '123.00'),
(41, 1274, 1123, 1, '2023-09-14', '2023-09-21', 0, 0, 1, 0, 0, '1552.00');

--
-- Δείκτες `object_offer`
--
DELIMITER $$
CREATE TRIGGER `OnAfterDeleteOffer_UpdateShopHasOffer` AFTER DELETE ON `object_offer` FOR EACH ROW BEGIN

        SET @count_offers=0;
        
        SELECT COUNT(*) INTO @count_offers FROM object_offer WHERE shop_id=old.shop_id;
        
        IF(@count_offers IS NULL OR @count_offers=0)THEN
            UPDATE object_shop SET active_offer=FALSE WHERE id=old.shop_id;
        ELSEIF(@count_offers IS NOT NULL AND @count_offers>0)THEN
            UPDATE object_shop SET active_offer=TRUE WHERE id=old.shop_id;
        END IF;

    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterInsertOffer_InsertIntoProductHistory` AFTER INSERT ON `object_offer` FOR EACH ROW BEGIN

        SET @historyexists=0;

        SELECT COUNT(*) INTO @historyexists
        FROM Archive_Product_History as ph
        WHERE ph.date=CURRENT_DATE
        AND	ph.product_id= new.product_id
        AND ph.shop_id= new.shop_id;

        IF (@historyexists=0 or @historyexists IS NULL)THEN
            INSERT INTO Archive_Product_History (shop_id,product_id,date,product_price)
                VALUES(new.shop_id,new.product_id,CURRENT_DATE,new.product_price);

        ELSEIF(@historyexists>0)THEN
                DELETE FROM Archive_Product_History WHERE date=CURRENT_DATE AND shop_id=new.shop_id AND product_id=new.product_id;
                
                INSERT INTO Archive_Product_History (shop_id,product_id,date,product_price)
                    VALUES(new.shop_id,new.product_id,CURRENT_DATE,new.product_price); 
        END IF;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterInsertOffer_InsertIntoUserScoreHistory` AFTER INSERT ON `object_offer` FOR EACH ROW BEGIN

          SET @mesitimi_day=0;
          SET @mesitimi_day_perc=0;

          SET @mesitimi_week=0;
          SET @mesitimi_week_perc=0;

          SET @Compare_Day=0;
          SET @Compare_Week=0;

          SET @ScoreForInsert=0;

          CALL CalculateMesiTimiPreviousDay(new.product_id,@mesitimi_day);
          CALL CalculateMesiTimiPrevious7Days(new.product_id,@mesitimi_week);


          SET @mesitimi_day_perc=(20/100)*@mesitimi_day;
          SET @mesitimi_week_perc=(20/100)*@mesitimi_week;

          SET @Compare_Day=@mesitimi_day-@mesitimi_day_perc;
          SET @Compare_Week=@mesitimi_week-@mesitimi_week_perc;

          
          IF(@Compare_Day>0 OR @Compare_Week>0)THEN

               IF (new.product_price<=@Compare_Day)THEN
               SET @ScoreForInsert=50;
               ELSEIF (new.product_price<=@Compare_Week>0)THEN
               SET @ScoreForInsert=20;
               END IF;
          
          ELSE
               SET @ScoreForInsert=50;
          END IF;

          IF (@ScoreForInsert!=0)THEN
               INSERT INTO Archive_user_score_history (user_id,offer_id,date,score) VALUES(new.creation_user_id,new.id,CURRENT_TIMESTAMP,@ScoreForInsert);
          END IF;

        
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterInsertOffer_UpdateShopHasOffer` AFTER INSERT ON `object_offer` FOR EACH ROW BEGIN

    UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;

    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterUpdateOffer_InsertIntoProductHistory` AFTER UPDATE ON `object_offer` FOR EACH ROW BEGIN

        SET @historyexists=0;

        SELECT COUNT(*) INTO @historyexists
        FROM Archive_Product_History as ph
        WHERE ph.date=CURRENT_DATE
        AND	ph.product_id= new.product_id
        AND ph.shop_id= new.shop_id;

        IF (@historyexists=0 or @historyexists IS NULL)THEN
            INSERT INTO Archive_Product_History (shop_id,product_id,date,product_price)
                VALUES(new.shop_id,new.product_id,CURRENT_DATE,new.product_price);

        ELSEIF(@historyexists>0)THEN
                DELETE FROM Archive_Product_History WHERE date=CURRENT_DATE AND shop_id=new.shop_id AND product_id=new.product_id;
                
                INSERT INTO Archive_Product_History (shop_id,product_id,date,product_price)
                    VALUES(new.shop_id,new.product_id,CURRENT_DATE,new.product_price); 
        END IF;

    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterUpdateOffer_InsertIntoUserScoreHistory` AFTER UPDATE ON `object_offer` FOR EACH ROW BEGIN

        
            SET @mesitimi_day=0;
            SET @mesitimi_day_perc=0;

            SET @mesitimi_week=0;
            SET @mesitimi_week_perc=0;

            SET @Compare_Day=0;
            SET @Compare_Week=0;

            SET @ScoreForInsert=0;

            CALL CalculateMesiTimiPreviousDay(new.product_id,@mesitimi_day);
            CALL CalculateMesiTimiPrevious7Days(new.product_id,@mesitimi_week);


            SET @mesitimi_day_perc=(20/100)*@mesitimi_day;
            SET @mesitimi_week_perc=(20/100)*@mesitimi_week;

            SET @Compare_Day=@mesitimi_day-@mesitimi_day_perc;
            SET @Compare_Week=@mesitimi_week-@mesitimi_week_perc;


            IF(@Compare_Day>0 OR @Compare_Week>0)THEN

                IF (new.product_price<=@Compare_Day)THEN
                    SET @ScoreForInsert=50;
                ELSEIF (new.product_price<=@Compare_Week>0)THEN
                    SET @ScoreForInsert=20;
                END IF;
            
            ELSE
                SET @ScoreForInsert=50;
            END IF;

            IF (@ScoreForInsert!=0)THEN
                INSERT INTO Archive_user_score_history (user_id,offer_id,date,score) VALUES(new.creation_user_id,new.id,CURRENT_TIMESTAMP,@ScoreForInsert);

            END IF;

        
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnAfterUpdateOffer_UpdateShopHasOffer` AFTER UPDATE ON `object_offer` FOR EACH ROW BEGIN

        UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;

    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertOffer_ModifyExpiratioDate` BEFORE INSERT ON `object_offer` FOR EACH ROW BEGIN
        SET new.expiration_date=DATE_ADD(new.creation_date,INTERVAL 7 DAY);

    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertOffer_ModifyExpirationDate` BEFORE INSERT ON `object_offer` FOR EACH ROW BEGIN
        SET new.expiration_date=DATE_ADD(new.creation_date,INTERVAL 7 DAY);

    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_product`
--

CREATE TABLE `object_product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text DEFAULT '',
  `photourl` text DEFAULT '',
  `photo_DATA` longblob DEFAULT NULL,
  `category_id` int(11) NOT NULL DEFAULT 0,
  `subcategory_id` int(11) NOT NULL DEFAULT 0,
  `ekat_id` varchar(255) DEFAULT '',
  `ekat_cat_id` varchar(255) DEFAULT '',
  `ekat_sub_id` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_product`
--

INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(1, 'Pantene Μάσκα Μαλ Αναδόμησης 2λεπτ 300ml', '', '', NULL, 4, 8, '267', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(2, 'Le Petit Marseillais Μάσκα Μαλλ Ξηρ 300ml', '', '', NULL, 4, 8, '362', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(3, 'Elvive Color Vive Μάσκα Μαλ 300ml', '', '', NULL, 4, 8, '368', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(4, 'Syoss Cond Βαμμένα Μαλ 500ml', '', '', NULL, 4, 8, '587', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(5, 'Gliss Condition Ultimate Color 200ml', '', '', NULL, 4, 8, '837', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(6, 'Axe Αποσμητικό Σπρέυ Africa 150ml', '', '', NULL, 4, 7, '45', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(7, 'Nivea Black/White Invisible 48h Rollon 50ml', '', '', NULL, 4, 7, '60', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(8, 'Noxzema Αποσμ Rollon Classic 50ml', '', '', NULL, 4, 7, '387', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(9, 'Dove Deodorant Κρέμα Rollon 50ml', '', '', NULL, 4, 7, '475', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(10, 'Dove Αποσμ Σπρέυ 150ml', '', '', NULL, 4, 7, '885', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(11, 'Softex Χαρτοπετσέτες Λευκές 30x30 56τεμ', '', '', NULL, 3, 6, '183', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(12, 'Delica Χαρτομάντηλα Αυτοκινήτου Λευκά Big 150τεμ', '', '', NULL, 3, 6, '274', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(13, 'Zewa Χαρτί Κουζίνας Με Σχέδια 2τεμ', '', '', NULL, 3, 6, '328', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(14, 'Softex Χαρτί Υγείας Super Giga 2 Φύλλα 12τεμ', '', '', NULL, 3, 6, '674', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(15, 'Zewa Deluxe Χαρτί Υγείας 3 Φύλλα 8τεμ', '', '', NULL, 3, 6, '769', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(16, 'Viakal Υγρό Καθαρισμού Κατά Των Αλάτων 500ml', '', '', NULL, 3, 5, '770', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(17, 'Klinex Καθ Πατώματος Λεμόνι 1λιτ', '', '', NULL, 3, 5, '788', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(18, 'Ajax Καθαριστικό Ultra 7 Φυσ Σαπούνι 1λιτ', '', '', NULL, 3, 5, '792', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(19, 'Lenor Μαλακτικό Gold Orchid 26πλ', '', '', NULL, 3, 5, '793', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(20, 'Quanto Μαλακτ Μη Συμπ Μπλε 2λιτ', '', '', NULL, 3, 5, '870', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(21, 'Λουξ Πορτοκαλάδα Ανθρ 330ml', '', '', NULL, 2, 4, '876', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(22, 'Coca Cola Πλαστ 4Χ500ml', '', '', NULL, 2, 4, '934', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(23, 'Coca Cola 500ml', '', '', NULL, 2, 4, '1013', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(24, 'Coca Cola 2Χ1,5λιτ', '', '', NULL, 2, 4, '1152', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(25, 'Fanta Πορτοκαλάδα 1,5λιτ', '', '', NULL, 2, 4, '1322', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(26, 'Heineken Μπύρα 330ml', '', '', NULL, 2, 3, '1340', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(27, 'Stella Artois Μπύρα 330ml', '', '', NULL, 2, 3, '426', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(28, 'Fix Hellas Μπύρα 6X330ml', '', '', NULL, 2, 3, '602', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(29, 'Μηλοκλέφτης Μηλίτης 330ml', '', '', NULL, 2, 3, '830', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(30, 'Βεργίνα Μπύρα 500ml', '', '', NULL, 2, 3, '1042', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(31, 'Γιώτης Κρέμα Παιδικη Φαρίν Λακτέ Μπισκότο 300γρ', '', '', NULL, 1, 2, '852', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(32, 'Nestle Φαρίν Λακτέ 350γρ', '', '', NULL, 1, 2, '27', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(33, 'Γιώτης Μπισκοτόκρεμα 300γρ', '', '', NULL, 1, 2, '67', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(34, 'Γιώτης Φρουτόκρεμα 5 Φρούτα 300γρ', '', '', NULL, 1, 2, '126', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(35, 'Γιώτης Κρέμα Παιδική Φαρίν Λακτέ 300γρ', '', '', NULL, 1, 2, '308', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(36, 'Pampers Premium Care No 5 11-18κιλ 44τεμ', '', '', NULL, 1, 1, '315', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(37, 'Libero Swimpants Πάνες Midi 10-16κιλ 6τεμ', '', '', NULL, 1, 1, '420', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(38, 'Babylino Sensitive No6 Econ 15-30κιλ 40τεμ', '', '', NULL, 1, 1, '444', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(39, 'Babylino Πάνες Μωρού Sensitive 3-6κιλ Nο 2 26τεμ', '', '', NULL, 1, 1, '510', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(40, 'Pampers Πάνες Μωρού Premium Care Newborn 2-5κιλ 26τεμ', '', '', NULL, 1, 1, '565', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(41, 'Κύκνος Τομάτες Αποφλ Ολoκλ 400γρ', '', '', NULL, 5, 75, '0', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(42, 'Elite Φρυγανιές Ολικής Άλεσης 180γρ', '', '', NULL, 5, 90, '1', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(43, 'Trata Σαρδέλα Λαδιού 100γρ', '', '', NULL, 5, 54, '2', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(44, 'Μεβγάλ Τυρί Ημισκλ Μακεδ 420γρ', '', '', NULL, 5, 72, '3', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(45, 'Μινέρβα Χωριό Μαργαρίνη Με Ελαιόλαδο 250γρ', '', '', NULL, 5, 44, '4', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(46, 'Εύρηκα Λευκαντικό 60γρ', '', '', NULL, 3, 5, '5', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(47, 'Sprite 330ml', '', '', NULL, 2, 4, '7', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(48, 'Μετέωρα Ξύδι Λευκού Κρασιού 400ml', '', '', NULL, 5, 61, '8', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(49, 'Μέλισσα Τορτελίνια Γεμ Τυρίων 250γρ', '', '', NULL, 5, 49, '9', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(50, 'Klinex Χλωρίνη Ultra Lemon 750ml', '', '', NULL, 3, 5, '10', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(51, 'Στεργίου Τσουρέκι 380γρ', '', '', NULL, 5, 73, '11', 'ee0022e7b1b34eb2b834ea334cda52e7', '0e1982336d8e4bdc867f1620a2bce3be'),
(52, 'Sani Πάνα Ακρατ Sensitive N4 Xlarge 10τεμ', '', '', NULL, 4, 28, '12', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(53, '3 Άλφα Ρεβύθια Χονδρά Εισαγωγής 500γρ', '', '', NULL, 5, 58, '13', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(54, 'Soupline Mistral Μαλακτικό Συμπ 28πλ', '', '', NULL, 3, 5, '14', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(55, 'Knorr Κύβοι Ζωμού Λαχανικών Extra Γεύση 147γρ', '', '', NULL, 5, 62, '15', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(56, 'Ζαγόρι Νερό 500ml', '', '', NULL, 2, 18, '16', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(57, 'Hansaplast Universal Αδιάβροχα 20τεμ', '', '', NULL, 4, 34, '17', '8e8117f7d9d64cf1a931a351eb15bd69', '1b59d5b58fb04816b8f6a74a4866580a'),
(58, 'Friskies Άμμος Υγιεινής 5κιλ', '', '', NULL, 8, 103, '18', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(59, 'Everyday Σερβ Super/Ultra Plus Sens 10τεμ', '', '', NULL, 4, 38, '20', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(60, 'Έψα Λεμοναδα 232ml', '', '', NULL, 2, 4, '21', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(61, 'Pyrox Εντομ/Κο Σπιράλ 10τεμ', '', '', NULL, 3, 16, '22', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(62, 'Fairy Υγρό Πιάτων Ultra Λεμόνι 900ml', '', '', NULL, 3, 9, '23', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(63, 'Δέλτα Γάλα Πλήρες 2λιτ', '', '', NULL, 5, 10, '24', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(64, 'Elite Φρυγανιές Σταριού Κουτί 250γρ', '', '', NULL, 5, 90, '25', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(65, 'Μπριζόλες Καρέ/Κόντρα Χοιρ Νωπές Εισ Μ/Ο ', '', '', NULL, 5, 97, '28', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(66, 'Fissan Baby Κρέμα 50γρ', '', '', NULL, 1, 11, '29', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(67, 'Νουνού Γάλα Family Υψ Θερ Επ Light 1,5% 1,5λιτ', '', '', NULL, 5, 10, '30', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(68, 'Everyday Σερβ Extr Long/Ultra Plus Hyp 10τεμ', '', '', NULL, 4, 38, '31', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(69, 'Bailey\'s Irish Cream Λικέρ 700ml', '', '', NULL, 2, 20, '32', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(70, 'Nivea Γαλάκτ Καθαρ Ξηρ/ Ευαίσθ Επιδ 200ml', '', '', NULL, 4, 29, '33', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(71, 'Dr Beckmann Καθαρ Πλυν Ρούχ 250γρ', '', '', NULL, 3, 5, '34', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(72, 'Klinex Σπρέυ 4σε1 750ml', '', '', NULL, 3, 5, '35', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(73, 'Τεντούρα Κάστρο Λικέρ 500ml', '', '', NULL, 2, 20, '36', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(74, 'Ήλιος Πιπέρι Μαύρο Τριμμένο 40gr', '', '', NULL, 5, 76, '37', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(75, 'Agrino Φασόλια Μέτρια 500γρ', '', '', NULL, 5, 58, '38', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(76, 'Αχλάδια Κρυσταλία Εισ Εξτρα', '', '', NULL, 5, 100, '39', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(77, 'Αρνιά Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ Συσκ/Νο', '', '', NULL, 5, 95, '40', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(78, 'Overlay Κρέμα Επίπλων 250ml', '', '', NULL, 3, 5, '41', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(79, 'Μεταξά 3 Μπράντυ 350ml', '', '', NULL, 2, 20, '42', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(80, 'Fornet Καθαρ Φούρνου 300ml', '', '', NULL, 3, 5, '43', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(81, 'Pyrox Εντομ/Ko Σπιράλ 20τεμ', '', '', NULL, 3, 16, '44', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(82, 'Roli Καθαριστικό Σκόνη Για Όλες Τις Επιφάνειες Λεμονί 500γρ', '', '', NULL, 3, 5, '46', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(83, 'Λακωνία Φυσικός Χυμός Πορτοκάλι 1λιτ', '', '', NULL, 2, 21, '47', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(84, 'Axe Αφροντούς Africa 400ml', '', '', NULL, 4, 12, '48', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(85, 'Red Bull Ενεργειακό Ποτό 250ml', '', '', NULL, 2, 4, '49', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(86, 'Becel Pro Activ Μαργαρίνη Σκαφ 250γρ', '', '', NULL, 5, 44, '50', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(87, 'Μπριζόλες Καρέ/Κόντρα Χοιρ Νωπές Ελλ Μ/Ο ', '', '', NULL, 5, 97, '52', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(88, 'Κανάκι Σφολιατ Χωρ Στρ Κουρού 450γρ', '', '', NULL, 5, 52, '53', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(89, 'Fissan Baby Ενυδατική κρέμα 150 ml', '', '', NULL, 1, 11, '54', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(90, 'Regilait Γάλα Αποβ/Νο Σε Σκόνη 250γρ', '', '', NULL, 1, 11, '55', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(91, 'Pescanova Μπακαλιαράκια 600γρ', '', '', NULL, 5, 83, '57', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(92, 'Maggi Κύβοι Ζωμού Λαχανικών 6λιτ 12τεμ', '', '', NULL, 5, 62, '58', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(93, 'Pampers Πάνες Μωρού Premium Pants Nο 4 9-15κιλ 38τεμ', '', '', NULL, 1, 1, '59', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(94, 'Moscato D\'Αsti Casarito Κρασί 750ml', '', '', NULL, 2, 19, '61', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(95, 'Calliga Demi Sec Ροζέ Οίνος 750ml', '', '', NULL, 2, 19, '63', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(96, 'Monster Energy Drink 500ml', '', '', NULL, 2, 4, '64', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(97, 'Fissan Baby Bagnetto Υποαλ Σαμπουάν/Αφρόλ 500ml', '', '', NULL, 1, 4, '65', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(98, 'Dove Αφροντούς Deep Nour 500ml', '', '', NULL, 4, 12, '66', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(99, 'Pampers Πάνες Premium Care Nο 3 5-9 κιλ 20τεμ', '', '', NULL, 1, 1, '68', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(100, 'Neomat Total Eco Απορ Σκον 14πλ 700γρ', '', '', NULL, 3, 9, '69', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(101, 'Γιώτης Κορν Φλάουρ 200γρ', '', '', NULL, 5, 45, '70', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(102, 'Φάγε Γιαούρτι Αγελαδίτσα 4% 3χ200γρ', '', '', NULL, 5, 13, '71', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(103, 'Maggi Πουρές Χ Γλουτ 250γρ', '', '', NULL, 5, 78, '72', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(104, 'Finish Αποσκλ/Κο Αλάτι Πλυν 2,5κιλ', '', '', NULL, 3, 5, '73', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(105, 'Svelto Gel Υγρό Πιάτων Λεμόνι 500ml', '', '', NULL, 3, 9, '74', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(106, 'Del Monte Κομπόστα Ανανά Φέτες 565γρ', '', '', NULL, 5, 54, '75', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(107, 'Κολοκυθάκια Εγχ', '', '', NULL, 5, 99, '76', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(108, 'Μακβελ Μακαρόνια Σπαγγέτι No 10 500γρ', '', '', NULL, 5, 49, '77', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(109, 'Quaker Τραγανές Μπουκ Σοκολ Υγείας 375γρ', '', '', NULL, 5, 80, '78', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(110, 'Ferrero Kinder Αυγό Εκπλ Χ Γλουτ 3τ 60γρ', '', '', NULL, 5, 78, '79', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(111, 'Ίον Σοκοφρέτα Μίνι Σακουλάκι 210γρ', '', '', NULL, 5, 46, '80', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(112, 'Kellogg\'s Δημητριακά Choco Pops Chocos 500γρ', '', '', NULL, 5, 80, '81', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(113, 'Παλίρροια Ντολμαδάκια Γιαλαντζί 280γρ', '', '', NULL, 5, 54, '82', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(114, 'Φάγε Total Γιαούρτι 5% Φάγε 3Χ200γρ', '', '', NULL, 5, 13, '83', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(115, 'Johnson\'s Baby Λοσιόν Bedtime 300ml', '', '', NULL, 1, 11, '84', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(116, 'Κανάκι Pizza Special 3 Χ 460γρ', '', '', NULL, 5, 51, '85', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa'),
(117, 'Κύκνος Τοματοπολτός 410γρ', '', '', NULL, 5, 63, '86', 'ee0022e7b1b34eb2b834ea334cda52e7', '5aba290bf919489da5810c6122f0bc9b'),
(118, 'Κρασί Της Παρέας Ροζέ Κοκκινέλι 1λιτ', '', '', NULL, 2, 19, '87', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(119, 'Quaker Τραγ Μπουκ 4 Ξηροί Καρποί 375γρ', '', '', NULL, 5, 80, '88', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(120, 'Μεβγάλ Φέτα Vacuum 400γρ', '', '', NULL, 5, 72, '89', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(121, 'Pedigree Rodeo Σκυλ/Φή Μοσχ 70γρ', '', '', NULL, 8, 104, '90', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(122, 'Μινέρβα Ελαιόλαδο 1λιτ', '', '', NULL, 5, 57, '91', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(123, 'Γιώτης Αλεύρι Για Όλες Τις Χρήσεις 1κιλ', '', '', NULL, 5, 41, '92', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(124, 'Babylino Πάνες Μωρού Sensitive 16+ κιλ No 6 15τεμ', '', '', NULL, 1, 1, '93', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(125, 'Orzene Σαμπουάν Μπύρας Κανον 400ml', '', '', NULL, 4, 12, '94', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(126, 'Dettol Κρεμ Sensitive Αντ/κο 750ml', '', '', NULL, 6, 101, '95', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(127, 'Everyday Σερβ Maxi Nig/Ultra Plus Sens 18τεμ', '', '', NULL, 4, 38, '96', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(128, 'Dettol Κρεμοσάπουνο 250ml', '', '', NULL, 4, 36, '97', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(129, 'Εβόλ Γάλα Παστερ Διαλεχτο 3,7% Λ 1λιτ', '', '', NULL, 5, 10, '98', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(130, 'Νουνού Frisogrow Γάλα 800γρ', '', '', NULL, 1, 10, '99', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(131, 'La Vache Qui Rit Τυροβουτιές 4Χ35γρ', '', '', NULL, 5, 72, '100', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(132, 'Πορτοκ Βαλέντσια Εγ Χυμ Συσκ/Να', '', '', NULL, 5, 100, '101', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(133, 'Αττική Μέλι 250γρ', '', '', NULL, 5, 79, '102', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(134, 'Klinex Καθαριστικό Τουαλέτας Block Ροζ Μανόλια 55γρ', '', '', NULL, 3, 5, '103', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(135, 'Libero Swimpants Πάνες Small 7-12κιλ 6τεμ', '', '', NULL, 1, 1, '104', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(136, 'Scotch Brite Σφουγγ Κουζ Γίγας Αντιβ', '', '', NULL, 3, 17, '105', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(137, 'Άριστον Αλάτι Ιμαλαΐων Φιάλη 400γρ', '', '', NULL, 5, 76, '106', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(138, 'Εύρηκα Σκόνη Antikalk 54γρ', '', '', NULL, 3, 9, '107', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(139, 'Όλυμπος Γιαούρτι Στραγγιστό 10% 1κιλ', '', '', NULL, 5, 13, '108', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(140, 'Nestle Fitness Dark Chocolate 375γρ', '', '', NULL, 5, 80, '109', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(141, 'Όλυμπος Γάλα Επιλεγμ. 3,7% Λ 1,5λιτ', '', '', NULL, 5, 10, '110', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(142, 'Μάσκες Προστασ Προσώπου 50τεμ', '', '', NULL, 7, 102, '200', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(143, 'Μπανάνες Chiquita Εισ', '', '', NULL, 5, 100, '112', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(144, 'Pampers Prem Care No5 11-18κιλ 30τεμ', '', '', NULL, 1, 1, '113', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(145, 'Jacobs Καφές Φίλτρου Εκλεκτός 250γρ', '', '', NULL, 5, 53, '114', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(146, 'Ροδόπη Γιαούρτι Πρόβειο 240γρ', '', '', NULL, 5, 13, '115', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(147, 'Καλλιμάνης Γλώσσα Φιλέτο 595γρ', '', '', NULL, 5, 83, '118', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(148, 'Μελιτζάνες Φλάσκες Εισ', '', '', NULL, 5, 99, '119', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(149, 'Παπαδοπούλου Caprice Ν6 400γρ', '', '', NULL, 5, 87, '120', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(150, 'Gillette Fusion 5 Proglide Ξυρ Μηχ+Ανταλ', '', '', NULL, 4, 26, '121', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(151, 'Pampers Πάνες Premium Care Νο 2 4-8κιλ 23τεμ', '', '', NULL, 1, 1, '122', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(152, 'Tuboflo Αποφρακτικό Σκόνη Φάκελ 100g', '', '', NULL, 3, 5, '123', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(153, 'Αλλατίνη Κέικ Βανίλια Με Κακάο 400γρ', '', '', NULL, 5, 50, '124', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(154, 'Baby Care Μωρόμαντηλα Sensitive 63τεμ', '', '', NULL, 1, 14, '125', '8016e637b54241f8ad242ed1699bf2da', '92680b33561c4a7e94b7e7a96b5bb153'),
(155, 'Πατάτες  Εισ Κατ Α Ε/Ζ ', '', '', NULL, 5, 99, '127', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(156, 'Neomat Υγρό Απορρυπαντικό Ρούχων Τριαντάφυλλο 62μεζ', '', '', NULL, 3, 9, '128', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(157, 'Μέλισσα Μακαρόνια Σπαγγετίνη Νο 10 500γρ', '', '', NULL, 5, 49, '129', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(158, 'Gelita Ζελατίνη Φύλλα 20γρ', '', '', NULL, 5, 45, '130', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(159, 'Barilla Μακαρόνια Ν5 500γρ', '', '', NULL, 5, 49, '131', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(160, 'Ω3 Αυγά Αμερικ Γεωργ Σχολής 6τ Large 63-73γρ', '', '', NULL, 5, 43, '132', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(161, 'Philadelphia Τυρί 200γρ', '', '', NULL, 5, 72, '133', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(162, 'Γιώτης Σοκολάτα Sweet/Balance Χ Γλουτ 100γρ', '', '', NULL, 5, 78, '134', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(163, 'Σαρδέλλες Νωπές Καθαρ Απεντ/νες Ελλην Μεσογ Συσκ/Νες', '', '', NULL, 5, 92, '135', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(164, 'Pampers Πάνες Μωρού 31τεμ', '', '', NULL, 1, 1, '136', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(165, 'Ferrero Kinder Pingui Σοκ/Γκοφρ 4X124γρ', '', '', NULL, 5, 46, '137', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(166, 'Rilken Gel Χτεν Clubber 150ml', '', '', NULL, 4, 33, '138', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(167, 'Alpro Ρόφημα Αμύγδαλο Χ Γλουτ 1λιτ', '', '', NULL, 5, 78, '139', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(168, 'Maggi Barilla Spaghettoni No7 500γρ', '', '', NULL, 5, 49, '140', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(169, 'Johnson\'s Baby Μπατονέτες Βαμβ 100τεμ', '', '', NULL, 1, 11, '141', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(170, 'Chupa Chups Melody Γλυφιτζ 12γρ', '', '', NULL, 5, 60, '142', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(171, 'Elnett Λακ Βαμμένα Μαλλ Satin 200ml', '', '', NULL, 4, 30, '144', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(172, 'Bic Ξυρ Μηχ Classic 10τεμ', '', '', NULL, 4, 26, '145', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(173, 'Kellogg\'s Special Κ 375γρ', '', '', NULL, 5, 80, '146', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(174, 'Flokos Καλαμάρια Φυσ Χυμού 370γρ', '', '', NULL, 5, 54, '147', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(175, 'Δέλτα Mmmilk Γάλα Οικογεν Χαρτ 1,5% 1,5λιτ', '', '', NULL, 5, 10, '148', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(176, 'Babylino Sensitive No1 2-5κιλ 28τεμ', '', '', NULL, 1, 1, '149', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(177, 'Γιώτης Κουβερτούρα Γαλακ Σταγ 100γρ', '', '', NULL, 5, 45, '150', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(178, 'Tsakiris Πατατάκια Αλάτι 72γρ', '', '', NULL, 5, 70, '151', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(179, 'Λεβέτι Κασέρι Ποπ Φέτες 175γρ', '', '', NULL, 5, 72, '152', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(180, 'Χρυσή Ζύμη Στριφταρi Τυρί Μυζ Μακεδον 850γρ', '', '', NULL, 5, 85, '153', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(181, 'Ντομάτες Εγχ Υδροπ Α ', '', '', NULL, 5, 99, '154', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(182, 'Creta Farms Λουκαν Χωριατ Μυρ Χ Γλουτ 400γρ', '', '', NULL, 5, 78, '155', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(183, 'Frulite Φρουτοπ Καροτ/Πορτ/Μαγκ 1λιτ', '', '', NULL, 2, 21, '156', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(184, 'Finish Υγρό Απορρυπαντικό Πλυντηρίου Πιάτων Lemon 1λιτ', '', '', NULL, 3, 9, '157', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(185, 'Iglo Κροκέτες Ψαριών Κατεψυγμένες 300γρ', '', '', NULL, 5, 83, '159', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(186, 'Pummaro Χυμός Τομάτα 500γρ', '', '', NULL, 5, 75, '160', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(187, 'Φλώρινα Ξυνό Νερό 1λιτ', '', '', NULL, 2, 18, '161', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(188, 'Life Φρουτοποτό Πορτ/Μηλ/Καρ 400ml', '', '', NULL, 2, 21, '162', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(189, 'Δέλτα Φυσικ Χυμός Smart Ροδ Βερ200ml', '', '', NULL, 2, 21, '163', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(190, 'Δέλτα Milko Κακάο 450ml', '', '', NULL, 5, 10, '165', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(191, 'Overlay Ultra Spray Λιποκαθαριστής Λεμόνι 650ml', '', '', NULL, 3, 5, '166', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(192, 'Δέλτα Advance Επιδ Μπαν/Μηλο 2Χ150γρ', '', '', NULL, 5, 13, '167', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(193, 'Κατσίκια Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ  Συσκ/Νο', '', '', NULL, 5, 96, '168', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(194, 'Όλυμπος Γάλα Επιλεγμ 1,5% Λ 1,5λιτ', '', '', NULL, 5, 10, '169', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(195, 'Βεμ Ρώσικη Σαλάτα 250γρ', '', '', NULL, 5, 81, '170', 'ee0022e7b1b34eb2b834ea334cda52e7', '4f205aaec31746b89f40f4d5d845b13e'),
(196, 'Κύκνος Τοματά Τριμμενη 500γρ', '', '', NULL, 5, 75, '171', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(197, 'Κύκνος Τομάτα Ψιλ 400γρ', '', '', NULL, 5, 75, '173', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(198, 'Alfa Τριγωνάρια Με Τυρί Ανεβατο Κατεψυγμένα 750γρ', '', '', NULL, 5, 85, '174', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(199, 'Μεβγάλ Γάλα Αγελ Λευκό Πλήρες 3,5% 500ml', '', '', NULL, 5, 10, '175', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(200, 'Μεβγάλ Στραγγιστό Γιαούρτι 2% 1κιλ', '', '', NULL, 5, 13, '176', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(201, 'Εν Ελλάδι Γαλοπούλα Καπνιστή Φέτες 160γρ', '', '', NULL, 5, 42, '177', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(202, 'Μεβγάλ Ζελέ Φράουλα 3Χ150γρ', '', '', NULL, 5, 47, '178', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(203, 'Μεβγάλ High Protein Choc Drink 242ml', '', '', NULL, 5, 10, '179', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(204, 'Μινέρβα Χωριό Φέτα Ποπ Βιολ Άλμη 350γρ', '', '', NULL, 5, 72, '180', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(205, 'Παπουτσάνη Σαπούνι Πρασ Παραδ 125γρ', '', '', NULL, 4, 36, '181', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(206, 'Εύρηκα Υγρό Απορρυπαντικό Ρούχων Μασσαλίας 30μεζ', '', '', NULL, 3, 9, '182', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(207, 'Lipton Ice Tea Green No Sugar 500ml', '', '', NULL, 2, 21, '184', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(208, 'Asti Martini Αφρώδης Οίνος 0,75λιτ', '', '', NULL, 2, 19, '186', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(209, 'Fego Καμφορά Πλακέτα 6τεμ', '', '', NULL, 3, 16, '187', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(210, 'Όλυμπος Ταχίνι Χ Γλουτ 300γρ', '', '', NULL, 5, 78, '188', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(211, 'Χρυσή Ζύμη Σπιτικά Τριγων Φέτα Κατικ 750γρ', '', '', NULL, 5, 85, '189', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(212, 'Χρυσή Ζύμη Μπουγάτσα Θεσσαλονίκης Με Πραλίνα 450γρ', '', '', NULL, 5, 85, '190', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(213, 'Χρυσή Ζύμη Λουκανικοπιτάκια Κατεψυγμένα Κουρού 800γρ', '', '', NULL, 5, 85, '191', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(214, 'Swiffer Πανάκια Αντ/Κα 16τεμ', '', '', NULL, 3, 5, '192', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(215, 'Coca Cola 1,5λιτ', '', '', NULL, 2, 4, '193', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(216, 'Heineken Μπύρα 6X330ml', '', '', NULL, 2, 3, '194', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(217, 'Coca Cola 6Χ330ml', '', '', NULL, 2, 4, '195', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(218, 'Μπάρμπα Στάθης Αρακάς 450γρ', '', '', NULL, 5, 84, '196', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(219, 'Vanish Σαμπουάν Χαλιών 500ml', '', '', NULL, 3, 5, '197', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(220, 'OralB Οδ/Mα 1/2/3 75ml', '', '', NULL, 4, 40, '198', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(221, 'Everyday Σερβ/Κια XL All Cotton 24τεμ', '', '', NULL, 4, 38, '199', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(222, 'EveryDay Natural Fresh Υγρό Ευαίσθ Περιοχ 200ml', '', '', NULL, 4, 38, '201', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(223, 'Χρυσή Ζύμη Χωριάτικο Φυλλο Κατεψυγμένο 700γρ', '', '', NULL, 5, 52, '203', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(224, 'Nescafe Cappuccino 10φακ 140γρ', '', '', NULL, 5, 53, '204', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(225, 'Σουρωτή Ανθρακούχο Φυσικό Νερό 250ml', '', '', NULL, 2, 18, '205', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(226, 'Skip Υγρό Απορρυπαντικό Ρούχων Spring Fresh 42μεζ', '', '', NULL, 3, 9, '206', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(227, 'Υφαντής Λουκάνικα Βιέννα Αποφλ Χ Γλουτ 250γρ', '', '', NULL, 5, 78, '207', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(228, 'Fissan Baby Σαπούνι 90γρ', '', '', NULL, 1, 78, '208', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(229, 'Nutricia Biskotti 180γρ', '', '', NULL, 1, 2, '209', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(230, 'Canderel Υποκατάστατο Ζάχαρης 120 Δισκία', '', '', NULL, 5, 88, '210', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(231, 'Ava Υγρό Πιάτων Perle Classic 900ml', '', '', NULL, 3, 9, '211', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(232, 'Ava Υγρό Πιάτων Action Λευκο Ξυδι Αντλια 650ml', '', '', NULL, 3, 9, '213', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(233, 'Gilette Ξυρ Μ/Χ Blue II Slalom 5τεμ', '', '', NULL, 4, 26, '214', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(234, 'Ferrero Kinder Αυγό Εκπλ Χ Γλουτ 20γρ', '', '', NULL, 5, 78, '215', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(235, 'Garnier Νερό Ντεμακιγιάζ Micellaire 100ml', '', '', NULL, 4, 29, '216', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(236, 'Friskies Active Σκυλ/Φή Ξηρά Vital 1,5κιλ', '', '', NULL, 8, 104, '217', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(237, 'Νίκας Λουκάν Φρανκ Γαλοπ Χ Γλ 280γρ', '', '', NULL, 5, 78, '218', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(238, 'Palette Λακ Πολύ Δυνατή 300ml', '', '', NULL, 4, 30, '219', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(239, 'Johnson\'s Baby Oil Ενυδατικό Λάδι, 300ml', '', '', NULL, 1, 11, '220', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(240, '3 Άλφα Φασόλια Μέτρια 500γρ', '', '', NULL, 5, 58, '221', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(241, 'Pampers Πάνες Βρακάκι Νο 5 11-18κιλ 15τεμ', '', '', NULL, 1, 1, '222', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(242, 'Knorr Ζωμός Κότας Σε Κόκκους Extra Γεύση 88γρ', '', '', NULL, 5, 62, '223', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(243, 'Nivea Μάσκα Μέλι για Ξηρ/Ευαίσθ Επιδ 2x7,5ml', '', '', NULL, 4, 29, '224', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(244, 'Nivea Αφρόλουτρο Cream Care 750ml', '', '', NULL, 4, 12, '225', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(245, 'Lux Σαπούνι Soft/Creamy 125γρ', '', '', NULL, 4, 36, '226', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(246, 'Κατσίκια Νωπά Ελλην Γαλ Ολοκλ Μ/Κ Μ/Σ', '', '', NULL, 5, 96, '227', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(247, 'Zest Familia Λουκανικοπιτάκια 800γρ', '', '', NULL, 5, 52, '228', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(248, 'Agrino Ρύζι Φάνσυ Ελλάδας 1κιλ', '', '', NULL, 5, 66, '229', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(249, 'Syoss Hairspray Max Ultra Strong 400ml', '', '', NULL, 4, 30, '230', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(250, 'Κοντοβερός Σολωμός Φιλέτο Chum 595γρ', '', '', NULL, 5, 83, '231', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(251, 'Υφαντής Πίτσα Rock N Roll 3Χ460γρ', '', '', NULL, 5, 51, '232', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa'),
(252, 'Nan Optipro 4 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 1, 51, '234', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(253, 'Γιώτης Κρέμα Ζαχαροπλ Βανίλια 117γρ', '', '', NULL, 5, 45, '235', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(254, 'Pescanova Μπακαλιάρος Φιλέτο 400γρ', '', '', NULL, 5, 83, '236', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(255, 'Ήπειρος Φέτα Ποπ Σε Άλμη 400γρ', '', '', NULL, 5, 72, '237', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(256, 'Tena Lady Maxi 12τεμ', '', '', NULL, 4, 38, '238', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(257, 'Νουνού Gouda Φέτες 200γρ', '', '', NULL, 5, 72, '239', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(258, 'Καλλιμάνης Γαρίδες Αποφλ Μικρές 425γρ', '', '', NULL, 5, 83, '240', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(259, 'Aim Οδοντόβ Μέτρια Antiplaque', '', '', NULL, 4, 27, '241', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(260, 'Εβόλ Γάλα Παστερ Κατσικ Βιολ 590ml', '', '', NULL, 5, 10, '242', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(261, 'Παπαδοπούλου Τριμμα Φρυγανιας Τριμμα 180γρ', '', '', NULL, 5, 90, '243', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(262, 'Μινέρβα Χωριό Ορεινές Περιοχές Ελαιόλαδο Παρθένο 2λιτ', '', '', NULL, 5, 57, '244', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(263, 'Μέλισσα Σπαγγέτι Ν6 500γρ', '', '', NULL, 5, 49, '245', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(264, 'Pescanova Μύδια Ψίχα 450γρ', '', '', NULL, 5, 83, '246', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(265, 'Όλυμπος Γάλα Κατσικίσιο Hπ 3,5% 1λιτ', '', '', NULL, 5, 10, '247', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(266, 'Misko Μακαρόνια Σπαγγέτι Ν3 500γρ', '', '', NULL, 5, 49, '248', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(267, 'Atrix Κρέμα Χερ Intens Χαμομήλι 150ml', '', '', NULL, 4, 35, '249', '8e8117f7d9d64cf1a931a351eb15bd69', 'fefa136c714945a3b6bcdcb4ee9e8921'),
(268, 'Ροδόπη Γάλα Χ Λακτόζη 1λιτ', '', '', NULL, 5, 78, '250', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(269, 'Μεβγάλ Harmony 1% Ροδακινο 3Χ200γρ', '', '', NULL, 5, 13, '251', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(270, 'Τράτα Γαύρος Φιλέτο Κατεψυγμένος 400γρ', '', '', NULL, 5, 83, '252', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(271, 'Sprite Αναψυκτικό 1,5λιτ', '', '', NULL, 2, 4, '253', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(272, 'Klinex Χλωρίνη Ultra Lemon 1250ml', '', '', NULL, 3, 5, '254', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(273, 'Afroso Wc Block Τριαντ 2Χ40ΓΡ', '', '', NULL, 3, 5, '257', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(274, 'Fytro Ζάχαρη Καστανή Ακατέργαστη 500γρ', '', '', NULL, 5, 88, '258', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(275, 'Pillsbury Ζύμη Φρέσκια Σφολιάτας 700γρ', '', '', NULL, 5, 52, '259', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(276, 'Friskies Adult Ξηρά Γατ/Φή Βοδ/Συκ/Κοτ 400γρ', '', '', NULL, 8, 103, '260', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(277, 'Libresse Σερβ Goodnight Clip 10τεμ', '', '', NULL, 4, 38, '261', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(278, 'Παυλίδης Μέρεντα Με Φουντούκι 570γρ', '', '', NULL, 5, 79, '263', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(279, 'Τσίχλες Trident Δυόσμος 8γρ', '', '', NULL, 5, 60, '264', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(280, 'Lipton Ice Tea Instant Λεμονι 125γρ', '', '', NULL, 2, 21, '265', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(281, 'Lenor Gold Orchid 56μεζ 1,4λιτ', '', '', NULL, 3, 5, '266', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(282, 'Pampers Πάνες Βρακάκι Νο 6 15+κιλ 14τεμ', '', '', NULL, 1, 1, '268', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(283, 'Παυλίδης Σοκολάτα Υγείας Αμύγδ 100γρ', '', '', NULL, 5, 46, '269', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(284, 'Ace Gentile Ενισχυτικό Πλύσης 2lt', '', '', NULL, 3, 5, '270', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(285, 'Barilla Πένες Rigate Νο 73 500γρ', '', '', NULL, 5, 49, '271', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(286, 'Omino Bianco Υγρό Blacκ Wash 25πλ 1,5λιτ', '', '', NULL, 3, 9, '272', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(287, 'Sanitas Αντικολλητικό Χαρτί 8μετ', '', '', NULL, 3, 17, '273', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(288, 'Cif Άσπρο Creαm 500ml', '', '', NULL, 3, 5, '275', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(289, 'Cif Λεμόνι Creαm 500ml', '', '', NULL, 3, 5, '276', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(290, 'Colgate Οδ/Μα Sensation Whiten.75ml', '', '', NULL, 4, 40, '277', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(291, 'Klinex Υγρό Καθαρισμού Μπάνιου Spray 750ml', '', '', NULL, 3, 5, '278', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(292, 'Όλυμπος Γιαούρτι Στραγγιστό 2% Λιπ 1κιλ', '', '', NULL, 5, 13, '279', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(293, 'Κορπή Φυσικό Μεταλλικό Νερό 500ml', '', '', NULL, 2, 18, '281', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(294, 'Nescafe Classic Στιγμιαίος Καφές 100γρ', '', '', NULL, 5, 53, '282', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(295, 'Χρυσή Ζύμη Τυροπιτάκια Κουρου 920γρ', '', '', NULL, 5, 85, '283', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(296, 'Babylino Πάνες Μωρού Sensitive Nο7 17+ κιλ 14τεμ', '', '', NULL, 1, 1, '284', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(297, 'Calgon Αποσκ/Κο Νερού Σκόνη 950γρ', '', '', NULL, 3, 5, '285', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(298, 'Ferrero Kinder Bueno Σοκ/Τα 43γρ', '', '', NULL, 5, 46, '286', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(299, 'Nesquik Δημητριακά Extra Choco Waves 375γρ', '', '', NULL, 5, 80, '287', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(300, 'Κιχί Πίτα Με Πράσο Ταψί Κατεψυγμένο 800γρ', '', '', NULL, 5, 85, '288', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(301, 'Soflan Υγρό Απορ Ρούχ Μαλλ/Ευαισθ 950ml', '', '', NULL, 3, 5, '289', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(302, 'Sanitas Αλουμινόχαρτο 10μετ', '', '', NULL, 3, 17, '290', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(303, 'Creta Farm Λουκάνικα Τρικάλων Με Πράσο 400γρ', '', '', NULL, 5, 42, '291', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(304, 'Εν Ελλάδι Μπέικον Καπνιστό Σε Φέτες 100γρ', '', '', NULL, 5, 42, '292', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(305, 'Donna Οινόπνευμα Καθαρό 245ml', '', '', NULL, 6, 101, '293', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(306, 'Biofarma Παστέλι Βιολ Με Σουσάμι 30gr', '', '', NULL, 5, 47, '294', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(307, 'Λουξ Πορτοκαλάδα Μπλε 330ml', '', '', NULL, 2, 4, '295', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(308, 'Neomat Total Eco Απορ Τριαν 14πλ 700γρ', '', '', NULL, 3, 9, '296', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(309, '3 Αλφα Ρύζι Καρολίνα 500γρ', '', '', NULL, 5, 66, '297', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(310, 'Nestle Cookie Crispies 375γρ', '', '', NULL, 5, 80, '298', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(311, 'Nescafe Dolce Gusto Cappuccino 16 Καψ', '', '', NULL, 5, 53, '299', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(312, 'Pampers Active Baby No5 11-16κιλ 51τεμ', '', '', NULL, 1, 1, '300', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(313, 'Agrino Ρύζι Λαΐς Καρολίνα 500γρ', '', '', NULL, 5, 66, '301', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(314, 'Νέα Φυτίνη Φυτικό Μαγειρικό Λίπος 400γρ', '', '', NULL, 5, 44, '303', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(315, 'Ρούσσος Νάμα Κρασί Ερυθρό Γλυκο 375ml', '', '', NULL, 2, 19, '304', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(316, 'OralB Οδ/Μα Pro Exp Prof Prot 75m', '', '', NULL, 4, 40, '305', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(317, 'Babylino Πάνες Μωρού Sensitive 11 - 25κιλ No 5 18τεμ', '', '', NULL, 1, 1, '306', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(318, 'Μεβγάλ Harmony Gourm ΑλατΚαραμ /Dark Choc 165γρ', '', '', NULL, 5, 13, '307', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(319, 'Αύρα Φυσικό Μεταλλικό Νερό 500ml', '', '', NULL, 2, 18, '309', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(320, 'Μάσκες Προστ Προσώπου 50τεμ Non-Woven', '', '', NULL, 7, 102, '310', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(321, 'Zewa Χαρτί Υγείας Deluxe Χαμομήλι 3 Φύλλα 8τεμ 768γρ', '', '', NULL, 3, 6, '311', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(322, 'Λουξ Λεμονάδα 330ml', '', '', NULL, 2, 4, '312', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(323, 'Nutricia Biskotti Ζωάκια 180γρ', '', '', NULL, 1, 2, '313', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(324, 'Dewar\'s Ουίσκι 0,7λιτ', '', '', NULL, 2, 20, '314', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(325, 'Omo Bianco Υγρό Αφρ Μασ Παραδοσ 30πλ', '', '', NULL, 3, 9, '316', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(326, 'Ίον Κακάο 125γρ', '', '', NULL, 5, 65, '317', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(327, 'Μακεδονικό Ταχίνι Σε Βάζο 300γρ', '', '', NULL, 5, 79, '318', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(328, 'Hellmann\'s Μαγιονέζα 225ml', '', '', NULL, 5, 86, '319', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(329, 'Becel Μαργαρίνη Light 40% Λιπ 250γρ', '', '', NULL, 5, 44, '320', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(330, 'Colgate Οδ/Μα Total Original 75ml', '', '', NULL, 4, 40, '321', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(331, 'Pillsbury Σάλτσα Για Πίτσα 200γρ', '', '', NULL, 5, 86, '322', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(332, 'Δομοκού Τυρί Κατίκι Ποπ 200g', '', '', NULL, 5, 72, '323', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(333, 'Νουνού Γάλα Family 3,6% 1,5λιτ', '', '', NULL, 5, 10, '324', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(334, 'Βιτάμ Μαργαρίνη Soft Σκαφ 500γρ', '', '', NULL, 5, 44, '325', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(335, 'Coca Cola 1λιτ', '', '', NULL, 2, 4, '326', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(336, 'Coca Cola Zero 1λιτ', '', '', NULL, 2, 4, '327', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(337, 'Μεβγάλ Only 0% Et Συρτ 3Χ200γρ', '', '', NULL, 5, 13, '329', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(338, 'Amita Motion Φυσικός Χυμός 330ml', '', '', NULL, 2, 21, '330', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(339, 'Klinex Χλωρίνη Lemon 2λιτ', '', '', NULL, 3, 5, '331', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(340, 'Άλτις Ελαιόλαδο Δοχείο 4λιτ', '', '', NULL, 5, 57, '332', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(341, 'Overlay Επίπλων Σπρέυ 250ml', '', '', NULL, 3, 5, '333', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(342, 'Cesar Clasicos Σκυλ/Φή Μοσχ 150γρ', '', '', NULL, 8, 104, '334', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(343, 'Δέλτα Milko Γάλα Παστερ 250ml', '', '', NULL, 5, 10, '335', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(344, 'Δέλτα Milko Κακάο 500ml', '', '', NULL, 5, 10, '336', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(345, 'Δέλτα Vitaline 0% Τρ Φρουτ/Δημ 380γρ', '', '', NULL, 5, 13, '337', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(346, 'Jacobs Καφές Φίλτρου Εκλεκτός 500γρ', '', '', NULL, 5, 53, '338', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(347, 'Becel Pro Activ Ρόφημα Γιαουρ Φράουλα 4Χ100γρ', '', '', NULL, 5, 13, '339', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(348, 'Ζαναέ Ντολμαδάκια 280γρ', '', '', NULL, 5, 54, '340', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(349, 'Omo Υγρό Απορ Τροπ Λουλ 30πλ 1,95l', '', '', NULL, 3, 9, '341', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(350, 'Knorr Quick Soup Μανιτ Με Κρουτόν 36γρ', '', '', NULL, 5, 48, '342', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eef696c0f874603a59aed909e1b4ce2'),
(351, 'Lactacyd Intimate Lotion Ευαίσθ Περιοχ 200ml', '', '', NULL, 4, 12, '343', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027');
INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(352, 'Daκor Corned Beef Μοσχάρι 200γρ', '', '', NULL, 5, 54, '344', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(353, 'Αρνιά Νωπά Ελλην Γαλ Ολοκλ Χ/Κ Χ/Σ ', '', '', NULL, 5, 95, '345', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(354, 'Μπούτι Χοιρινό Α/Ο Νωπό Εισ Χ/Δ ', '', '', NULL, 5, 97, '346', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(355, 'Λάπα Βόειου Α/Ο Νωπή Εισ', '', '', NULL, 5, 98, '347', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(356, 'Μελιτζάνες Φλάσκες Εγχ', '', '', NULL, 5, 99, '348', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(357, 'Πατάτες  Ελλ Κατ Α Ε/Ζ', '', '', NULL, 5, 99, '349', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(358, 'Friskies Adult Ξηρά Γατ/Φή Κουν/Κοτ/Λαχ 400γρ', '', '', NULL, 8, 103, '351', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(359, 'Κρι Κρι Σπιτικό Επιδόρπιο Γιαουρτιού 2% 1κιλ', '', '', NULL, 5, 13, '352', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(360, 'Bonne Maman Μαρμελάδα Φρα Χ Γλ.370γρ', '', '', NULL, 5, 78, '353', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(361, 'Wella Flex Σπρέυ Ultra Strong 250ml', '', '', NULL, 4, 30, '354', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(362, 'Γιώτης Μαγιά 3φακ 8γρ', '', '', NULL, 5, 45, '355', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(363, 'Friskies Σκυλ/Φή Βοδ/Κοτ/Λαχ 400γρ', '', '', NULL, 8, 104, '356', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(364, 'La Vache Qui Rit Τυρί 8τμχ 140γρ', '', '', NULL, 5, 72, '357', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(365, 'Pedigree Σκυλ/Φή Πατέ Κοτοπ/Μοσχ 300γρ', '', '', NULL, 8, 104, '358', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(366, 'Purina Gold Gourmet Γατ/Φή Βοδ/Κοτ 85γρ', '', '', NULL, 8, 103, '359', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(367, 'Μεβγάλ Μανούρι 200γρ', '', '', NULL, 5, 72, '360', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(368, 'Johnson Βρέφικη Πουδρα Σωματος 200γρ', '', '', NULL, 1, 11, '361', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(369, 'Nestle Fitness Bars Σοκολάτα 6Χ23,5γρ', '', '', NULL, 5, 80, '363', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(370, 'Johnson\'s 24η Κρ Ημ Essentials Hydr SPF15 50ml', '', '', NULL, 4, 29, '364', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(371, 'Μεβγάλ Παραδοσιακό Γιαούρτι Αγελαδ 220γρ', '', '', NULL, 5, 13, '365', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(372, 'Johnson\'s Baby Σαμπουάν 750ml', '', '', NULL, 1, 13, '366', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(373, 'L\'Oreal Σαμπ Elvive Color Vive Βαμμένα 400ml', '', '', NULL, 4, 12, '367', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(374, 'Nivea Κρέμα 150ml', '', '', NULL, 4, 29, '369', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(375, 'Φάγε Τυρί Τριμμένο Gouda 200γρ', '', '', NULL, 5, 72, '370', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(376, 'Βέρμιον Νάουσα Κομπόστα Ροδάκινο 1κιλ', '', '', NULL, 5, 54, '371', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(377, 'Maltesers Κουφετάκια Σοκολ 37gr', '', '', NULL, 5, 46, '372', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(378, 'Νουνού Κρέμα Γάλακτος Πλήρης 330ml', '', '', NULL, 5, 56, '373', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(379, 'Pantene Σαμπουάν Αναδόμησης 360ml', '', '', NULL, 4, 12, '374', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(380, 'Snickers Σοκολάτα 50γρ', '', '', NULL, 5, 46, '375', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(381, 'Μεβγάλ Harmony 1% Λεμ 3Χ200γρ', '', '', NULL, 5, 13, '376', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(382, 'Whiskas Γατ/Φή Κοτόπουλο 400γρ', '', '', NULL, 8, 103, '377', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(383, 'Champion Κρουασ Πραλίνα Φουντουκ 4X70γρ', '', '', NULL, 5, 69, '378', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(384, 'Aim Οδ/Μα Παιδ 2/6ετων 50ml', '', '', NULL, 4, 40, '379', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(385, 'Κριθαράκι Μίσκο Χονδρό 500γρ', '', '', NULL, 5, 49, '380', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(386, 'Becel Pro Activ Ρόφημα Με Γαλ 1,8% Λ 1λιτ', '', '', NULL, 5, 10, '381', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(387, 'Heineken Μπύρα Premium Lager 500ml', '', '', NULL, 2, 3, '383', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(388, 'Αγγούρια Εγχ', '', '', NULL, 5, 99, '384', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(389, 'Υφαντής Σαλάμι Αέρος Χ Γλουτ 100γρ', '', '', NULL, 5, 78, '385', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(390, 'Agrino Ρύζι Σουπέ Γλασέ 500γρ', '', '', NULL, 5, 66, '386', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(391, 'Καραμολέγκος Ψωμί Τοστ Σταρένιο 680γρ', '', '', NULL, 5, 74, '388', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(392, 'Agrino Φασόλια Γίγαντες Ελέφαντες Καστοριάς Π.Γ.Ε. 500γρ', '', '', NULL, 5, 58, '389', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(393, 'Λάβδας Καραμέλες Βούτυρου 0% Ζαχαρ 32γρ', '', '', NULL, 5, 60, '390', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(394, 'Παυλίδης Σοκολατα Υγειας Πορτοκ 100γρ', '', '', NULL, 5, 46, '391', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(395, 'Ροδάκινα Εγχ', '', '', NULL, 5, 100, '392', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(396, 'Barilla Σάλτσα Βασιλικος 400γρ', '', '', NULL, 5, 86, '393', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(397, 'Proderm Σαμπουάν/Αφρόλουτρο 1-3 400ml', '', '', NULL, 1, 86, '394', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(398, 'Philadelphia Τυρί 300γρ', '', '', NULL, 5, 72, '395', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(399, 'Quaker Νιφ Βρώμης Ολ Άλεσης 500γρ', '', '', NULL, 5, 80, '396', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(400, 'Νουνού Γάλα Εβαπορέ 170γρ', '', '', NULL, 5, 10, '397', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(401, 'Στήθος Φιλέτο Κοτ Ελλην. Νωπό Συσκ/Νο', '', '', NULL, 5, 94, '398', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(402, 'Pantene Κρέμα Μαλλ Αναδόμησης 270ml', '', '', NULL, 4, 30, '399', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(403, 'Ίον Σοκολάτες Γάλακτος 70γρ', '', '', NULL, 5, 46, '400', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(404, 'EggPro Ροφ Πρωτεΐνης Φράουλα Χ Γλουτ 250ml', '', '', NULL, 5, 78, '401', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(405, 'Lay\'s Πατατάκια Ρίγανη150γρ', '', '', NULL, 5, 70, '402', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(406, 'Pummaro Ψιλοκ Τοματ Κλασ 400γρ', '', '', NULL, 5, 75, '403', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(407, 'Κάλας Αλάτι Θαλασσινό Κλασικό 400γρ', '', '', NULL, 5, 76, '404', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(408, 'Lipton Χαμομήλι Φακ 10τεμΧ1γρ', '', '', NULL, 5, 65, '405', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(409, 'Μεβγάλ Τριμμένο Κεφαλοτύρι 200γρ', '', '', NULL, 5, 72, '406', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(410, 'Everyday Σερβ Norm/Ultra Plus Sens 10τεμ', '', '', NULL, 4, 38, '407', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(411, 'Μεβγάλ Πολίτικο 2Χ150γρ', '', '', NULL, 5, 47, '408', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(412, 'Klinex Advance Απορρυπαντικό Ρούχων Πλυντηρίου Με Χλώριο 2λιτ', '', '', NULL, 3, 9, '409', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(413, 'Τράτα Τόνος Φιλέτο 240γρ', '', '', NULL, 5, 83, '410', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(414, 'Πλωμάρι Ούζο 0,7λιτ', '', '', NULL, 2, 20, '411', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(415, 'Melissa Σιμιγδάλι Χονδρό 500γρ', '', '', NULL, 5, 41, '412', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(416, 'Scotch Brite Σφουγγαράκι Πράσ Κλασ 1τεμ', '', '', NULL, 3, 5, '413', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(417, 'Aim Οδ/μα White System 75ml', '', '', NULL, 4, 40, '414', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(418, 'Μεβγάλ Harmony Gourmet Πορτοκ Νιφ Σοκ 165γρ', '', '', NULL, 5, 13, '416', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(419, 'Dettol Κρεμοσάπουνο Soothe 250ml', '', '', NULL, 4, 36, '418', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(420, 'Φάγε Τρικαλινό Τυρί Ζαρί Light Φάγε 380γρ', '', '', NULL, 5, 72, '419', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(421, 'Λουμίδης Καφές Ελληνικός 194γρ', '', '', NULL, 5, 53, '421', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(422, 'Χρυσή Ζύμη Τυροπίτα Σπιτική 850γρ', '', '', NULL, 5, 85, '422', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(423, 'Libresse Σερβιέτες Ultra Thin Long Wings 8τεμ', '', '', NULL, 4, 38, '424', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(424, 'Φάγε Total Γιαούρτι Στραγγιστό 2% 1κιλ', '', '', NULL, 5, 13, '425', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(425, 'Βιτάμ Μαργαρίνη Soft Light 39% Λιπ 250γρ', '', '', NULL, 5, 44, '427', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(426, 'Πέρκα Φιλέτο Κτψ Εισ Συσκ/Νη', '', '', NULL, 5, 83, '428', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(427, 'Ariel Υγρό Πλυντηρίου Ρούχων Mountain Spring 54μεζ', '', '', NULL, 3, 9, '429', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(428, 'Airwick Αντ/Κο Αποσμ Χώρου Βαν/Ορχιδ', '', '', NULL, 3, 15, '430', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(429, 'Αλλατίνη Φαρίνα Κέικ Φλάουρ 500γρ', '', '', NULL, 5, 41, '431', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(430, 'Nan Optipro 2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 1, 41, '432', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(431, 'Νουνού Γάλα Family 1,5% 1λιτ', '', '', NULL, 5, 10, '433', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(432, 'Ελιά Βόειου Α/Ο Νωπή Ελλ Εκτρ Άνω Των 5 Μην ', '', '', NULL, 5, 98, '434', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(433, 'Μπάρμπα Στάθης Σπανάκι Φύλλα 1κιλ', '', '', NULL, 5, 84, '435', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(434, 'Everyday Σερβ Maxi Nig/Ultra Plus Hyp 18τεμ', '', '', NULL, 4, 38, '436', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(435, 'Kellogg\'s Coco Pops Chocos 375γρ', '', '', NULL, 5, 80, '437', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(436, 'Amita Motion Φυσικός Χυμός 1λιτ', '', '', NULL, 2, 21, '438', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(437, 'Μεβγάλ Ξινόγαλο 500ml', '', '', NULL, 5, 10, '439', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(438, 'Pampers Prem Care No4 8-14κιλ 34τεμ', '', '', NULL, 1, 1, '440', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(439, 'Crunch Σοκολάτα Γάλακτος 100γρ', '', '', NULL, 5, 46, '441', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(440, 'Barilla Σάλτσα Pesto Alla Genovese 190γρ', '', '', NULL, 5, 86, '442', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(441, 'Babylino Πάνες Μωρού Sensitive No 5+ Εως 27 κιλ 16τεμ', '', '', NULL, 1, 1, '443', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(442, 'Αχλάδια Κρυσταλία Εγχ Εξτρα ', '', '', NULL, 5, 100, '445', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(443, 'Μεβγάλ Harmony 1% Φράουλα 3Χ200γρ', '', '', NULL, 5, 13, '446', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(444, 'Klinex Υγρό Απορρυπαντικό Ρούχων Fresh Clean 25μεζ', '', '', NULL, 3, 9, '447', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(445, 'Proderm Ενυδατική Κρέμα 150ml', '', '', NULL, 1, 11, '448', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(446, 'Duck Στερεό Block Aqua Blue 40ml', '', '', NULL, 3, 5, '449', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(447, 'Ζαγόρι Νερό Athletic 750ml', '', '', NULL, 2, 18, '450', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(448, 'Χρυσά Αυγά Εξαίρετα Φρέσκα Large 6τ Χ 63γρ Πλαστ Θήκη', '', '', NULL, 5, 43, '451', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(449, 'Κρίς Κρίς Τόστιμο Ψωμί Τόστ Ολικής Άλεσης 400γρ', '', '', NULL, 5, 74, '452', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(450, 'Μήλα Στάρκιν Κατ Έξτρα Εγχ', '', '', NULL, 5, 100, '453', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(451, '3 Άλφα Φασόλια Γίγαντες Εισαγωγής 500γρ', '', '', NULL, 5, 58, '454', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(452, 'Pescanova Μπακαλιάρος Ρολό Φιλeto 480γρ', '', '', NULL, 5, 83, '455', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(453, 'Κανάκι Βάση Πίτσας Κατεψυγμένη 660γρ', '', '', NULL, 5, 52, '456', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(454, 'Κρασί Της Παρέας Ερυθρό 1λιτ', '', '', NULL, 2, 19, '457', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(455, 'Μέγα Βαμβάκι 100γρ', '', '', NULL, 4, 22, '458', '8e8117f7d9d64cf1a931a351eb15bd69', 'af538008f3ab40989d67f971e407a85c'),
(456, 'La Vache Qui Rit Τυρί Cheddar Φέτες 200γρ', '', '', NULL, 5, 72, '459', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(457, 'Όλυμπος Γιαούρτι Στραγγιστό 2% 3Χ200γρ', '', '', NULL, 5, 13, '460', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(458, 'Τοματίνια Βελανίδι Ε/Ζ', '', '', NULL, 5, 99, '461', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(459, 'Λαυράκια Υδατ  Ελλην 400/600 Μεσογ', '', '', NULL, 5, 93, '462', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(460, '7 Days Κρουασάν Κακάο 70γρ', '', '', NULL, 5, 69, '463', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(461, 'Tena Lady Extra 20τεμ', '', '', NULL, 4, 28, '464', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(462, 'Palmolive Κρεμ Μέλι Γάλα Αντ/κο 750ml', '', '', NULL, 4, 36, '465', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(463, 'Τράτα Σαρδέλες Φιλέτο Κατεψυγμένες 400γρ', '', '', NULL, 5, 83, '466', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(464, 'Neslac Επιδόρπιο Γάλακτος Μπισκότο 4Χ100γρ', '', '', NULL, 1, 83, '467', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(465, 'Μεβγάλ Στραγγιστό Γιαούρτι 3Χ200γρ', '', '', NULL, 5, 13, '469', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(466, 'Sanitas Σακ Απορ Ultra 52Χ75cm 10τεμ', '', '', NULL, 3, 17, '470', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(467, 'Vaseline Petroleum Jelly 100% Καθαρή Βαζελίνη 100 ml', '', '', NULL, 4, 35, '471', '8e8117f7d9d64cf1a931a351eb15bd69', 'fefa136c714945a3b6bcdcb4ee9e8921'),
(468, 'Amstel Μπύρα Premium Quality 0,5λιτ', '', '', NULL, 2, 3, '472', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(469, 'Gillette Venus Close&Clean+2 Ανταλ', '', '', NULL, 4, 26, '473', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(470, 'Χρυσή Ζύμη Κασερόπιτα Σπιτική 850γρ', '', '', NULL, 5, 85, '474', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(471, 'Klinex Υγρά Πανάκια 30τεμ', '', '', NULL, 3, 17, '476', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(472, 'Γιώτης Σιρόπι Σοκολάτα 350γρ', '', '', NULL, 5, 45, '477', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(473, 'OralB Χειρ Οδοντoβ 1/2/3 Clas Care 40 Med 2 τεμ', '', '', NULL, 4, 27, '478', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(474, 'Κιλότο Νεαρού Μοσχ Α/Ο Νωπό Εισ', '', '', NULL, 5, 98, '479', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(475, 'Halls Καραμ Cool Menthol 28γρ', '', '', NULL, 5, 60, '480', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(476, 'Pedigree Υγ Σκυλ/Φή 3 Ποικ Πουλερικών 400γρ', '', '', NULL, 8, 104, '481', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(477, 'Μεβγάλ Ζελέ Κεράσι 3Χ150γρ', '', '', NULL, 5, 47, '482', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(478, 'Μεβγάλ High Protein Vanilla Drink 242ml', '', '', NULL, 5, 10, '483', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(479, 'Sanitas Παγοκυψέλες 2 Σε 1', '', '', NULL, 3, 17, '484', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(480, 'Βιτάμ Soft Μαργαρίνη 3/4 250γρ', '', '', NULL, 5, 44, '485', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(481, 'Ferrero Kinder Σοκολ Bars Χ Γλουτ 8τ 100γρ', '', '', NULL, 5, 78, '487', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(482, 'Εδέμ Φασόλια Κόκκινα Σε Νερό 240γρ.', '', '', NULL, 5, 58, '488', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(483, 'Omo Σκόνη Πλυντ Τροπ Λουλούδια 45πλ', '', '', NULL, 3, 9, '489', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(484, 'Flokos Σκουμπρί Φιλέτο Καπνιστό 160gr', '', '', NULL, 5, 83, '490', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(485, 'Fissan Baby Σαπούνι 30% Eνυδ Kρέμα 100gr', '', '', NULL, 1, 83, '491', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(486, 'Μίνι Ούζο Γλυκάνισο 200ml', '', '', NULL, 2, 20, '492', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(487, 'Πατάτες  Κύπρου  Κατ Α Συσκ/Νες', '', '', NULL, 5, 99, '493', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(488, 'Quanto Μαλακτ Ρουχ Ελλ Νησ 2λιτ', '', '', NULL, 3, 5, '495', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(489, 'Vanish Oxi Action Ενισχυτικό Πλεύσης 1γρ', '', '', NULL, 3, 9, '496', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(490, 'Μπανάνες Υπολ Μάρκες ', '', '', NULL, 5, 100, '497', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(491, 'Molto Κρουασάν Πραλίνα 80γρ', '', '', NULL, 5, 69, '498', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(492, 'Ajax Υγρό Κατά Των Αλάτων Spray Expert 500ml', '', '', NULL, 3, 5, '499', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(493, 'Νίκας Γαλοπούλα Καπνιστή Φέτες 160γρ', '', '', NULL, 5, 42, '500', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(494, 'Παπαδοπούλου Αρτοσκεύασμα Πολύσπορο 540γρ', '', '', NULL, 5, 74, '501', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(495, 'Μεταξά 3 Μπράντυ 700ml', '', '', NULL, 2, 20, '502', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(496, 'Persil Black Essenzia Απορ Υγρ 25πλ 1,5λιτ', '', '', NULL, 3, 9, '503', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(497, 'Akis Ρυζάλευρο 500γρ', '', '', NULL, 5, 41, '504', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(498, 'Μεβγάλ Τριμμένο Σκλήρο Τυρί 80γρ', '', '', NULL, 5, 72, '505', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(499, 'Μπούτι Χοιρινό Α/Ο Νωπό Ελλ Χ/Δ ', '', '', NULL, 5, 97, '506', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(500, 'Πατάτες  Κύπρου  Κατ Α Ε/Ζ', '', '', NULL, 5, 99, '507', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(501, 'Dixan Gel 30πλ', '', '', NULL, 3, 9, '508', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(502, 'Dixan Υγρό Απορρυπαντικό Ρούχων 42μεζ', '', '', NULL, 3, 9, '509', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(503, 'Νουνού Ρόφημα Γάλακτος Calciplus 1λιτ', '', '', NULL, 5, 10, '511', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(504, '3 Άλφα Ρύζι Νυχάκι 1κιλ', '', '', NULL, 5, 66, '512', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(505, 'Όλυμπος Γάλα Επιλεγμ 3,7% Λ 1λιτ', '', '', NULL, 5, 10, '513', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(506, 'Fairy Υγρό Πιάτων Ultra Κανονικό 900ml', '', '', NULL, 3, 9, '514', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(507, 'Elite Φρυγανιά Τρίμμα 180γρ', '', '', NULL, 5, 90, '515', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(508, 'Sensodyne Οδ/μα Complete Protection 75ml', '', '', NULL, 4, 40, '516', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(509, 'Barilla Ζυμαρικά Capellini No1 500γρ', '', '', NULL, 5, 49, '517', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(510, 'Αρκάδι Υγρό Πλυντ Baby Με Σαπούνι 26πλυς', '', '', NULL, 1, 49, '518', '8016e637b54241f8ad242ed1699bf2da', '991276688c8c4a91b5524b1115122ec1'),
(511, 'Elite Φρυγανιές Σίκαλης 180γρ', '', '', NULL, 5, 90, '520', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(512, 'Sanitas Μεμβράνη Διάφανη 30μετ', '', '', NULL, 3, 17, '521', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(513, 'Μήλα Στάρκιν Ζαγορ Πηλίου ΠΟΠ Κατ Έξτρα', '', '', NULL, 5, 100, '522', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(514, 'Οίνος Ερ Γλυκ Μαυροδάφνη Αχαΐα 375ml', '', '', NULL, 2, 19, '523', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(515, 'Agrino Ρύζι Bella Parboiled Χ Γλουτ 1κιλ', '', '', NULL, 5, 66, '524', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(516, 'Absolut Βότκα 0,7λιτ', '', '', NULL, 2, 20, '525', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(517, 'Αλλοτινό Οίνος Ερυθρ Ημιγλυκ 0,5ml', '', '', NULL, 2, 19, '526', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(518, 'Agrino Φακές Ψιλές Εισαγωγής 500γρ', '', '', NULL, 5, 58, '527', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(519, 'Bravo Καφές Κλασικός 95γρ', '', '', NULL, 5, 53, '528', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(520, 'Zewa Χαρτι Κουζίνας Wisch And Weg Economy 3τεμ', '', '', NULL, 3, 6, '529', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(521, 'Κοτοπουλα Ολοκληρα Νωπα Τ.65% Νιτσιακος Π.Α.Ελλην Συσκ/Να', '', '', NULL, 5, 94, '530', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(522, 'Johnson\'s Baby Κρέμα Μαλλ Χωρ Κομπ 500ml', '', '', NULL, 1, 94, '531', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(523, 'Garnier Express Ντεμακιγιάζ Ματιών 2σε1 125ml', '', '', NULL, 4, 29, '532', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(524, 'Κατσέλης Κριτσίνια Μακεδονικά Ολικής Άλεσης 200γρ', '', '', NULL, 5, 89, '533', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(525, 'Δωδώνη Γιαούρτι Στραγγιστό 2% 1Kg', '', '', NULL, 5, 13, '536', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(526, 'Όλυμπος Γάλα Ζωής Πλήρες Υψ Παστ 1,5λιτ', '', '', NULL, 5, 10, '537', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(527, 'Bacardi Ρούμι 700ml', '', '', NULL, 2, 20, '538', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(528, 'Ava Υγρό Πιάτων Perle Σύμπλεγμα Βιταμινών 430ml', '', '', NULL, 3, 9, '539', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(529, 'Μεβγάλ Τριμμένο Τυρί Light 10% Λ 200γρ', '', '', NULL, 5, 72, '541', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(530, 'Creta Farms Εν Ελλάδi Λουκάν Παραδ Χ Γλουτ 340γρ', '', '', NULL, 5, 78, '542', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(531, 'Creta Farms Εν Ελλάδι Κεφτεδάκια Κτψ 420γρ', '', '', NULL, 5, 91, '543', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(532, 'Barilla Maccheroncini Μακαρόνια Για Παστίτσιο 500γρ', '', '', NULL, 5, 49, '544', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(533, 'Klinex Χλωρίνη Classic 1λιτ', '', '', NULL, 3, 5, '545', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(534, 'Μπάρμπα Στάθης Ρύζι Με Καλαμπόκι 600γρ', '', '', NULL, 5, 84, '546', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(535, 'Elvive Extraordinary Oil Universal 100ml', '', '', NULL, 4, 30, '547', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(536, 'Activel Plus Αντισηπτικό Gel Χεριών 500ml', '', '', NULL, 6, 101, '548', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(537, 'Ζαγόρι Φυσικό Μεταλλικό Νερό 1.5λιτ', '', '', NULL, 2, 18, '549', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(538, 'Παπαδοπούλου Krispies Σουσάμι 200γρ', '', '', NULL, 5, 89, '550', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(539, 'Γιαννιώτη Φύλλο Κρουσ Νωπό 450γρ', '', '', NULL, 5, 52, '551', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(540, 'Ροδόπη Γιαούρτι Κατσικίσιο 240γρ', '', '', NULL, 5, 13, '552', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(541, 'Pillsbury Αφρατ Ζυμ Για Πίτσα 400γρ', '', '', NULL, 5, 52, '553', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(542, 'Γλώσσες Φιλέτο Κτψ Εισ Συσκ/Νες', '', '', NULL, 5, 83, '554', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(543, 'Coca Cola Zero 2Χ1,5λιτ', '', '', NULL, 2, 4, '555', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(544, 'Jumbo Σνακ Γαριδάρες 85gr', '', '', NULL, 5, 68, '556', 'ee0022e7b1b34eb2b834ea334cda52e7', 'f87bed0b4b8e44c3b532f2c03197aff9'),
(545, 'Διβάνη Βούτυρο Αγνό Γάλακτ Λιωμ 500γρ', '', '', NULL, 5, 44, '559', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(546, 'Gouda Τυρί Φάγε Φέτες 200γρ', '', '', NULL, 5, 72, '560', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(547, 'Flora Μαργαρίνη Πλακ 70% Λιπ 25% 250γρ', '', '', NULL, 5, 44, '561', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(548, 'Uncle Bens Ρύζι Basmati 500γρ', '', '', NULL, 5, 66, '562', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(549, 'St Clemens Μπλέ Τυρί Δανίας 100γρ', '', '', NULL, 5, 72, '563', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(550, 'Quanto Μαλακτικό Ρούχων Ελληνικά Νησιά 18μεζ', '', '', NULL, 3, 9, '564', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(551, 'Παπαδημητρίου Κρέμα Balsamico Λευκή 250ml', '', '', NULL, 5, 61, '566', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(552, 'Gillette Αφρός Ξυρ Sens Classic 200ml', '', '', NULL, 4, 33, '567', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(553, 'Airwick Αποσμ Χώρου Stick Up 120γρ 2τεμ', '', '', NULL, 3, 15, '568', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(554, 'Lipton Τσάι Ρόφημα 10 Φακ 1,5γρ', '', '', NULL, 5, 65, '569', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(555, 'Knorr Κύβοι Ζωμού Λαχανικών 12λιτ 24τεμάχια', '', '', NULL, 5, 62, '570', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(556, 'Fairy Original All in One Καψ Πλυντ Πιάτ Λεμόνι 22τεμ', '', '', NULL, 3, 9, '571', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(557, 'Μινέρβα Χωριό Βούτυρο 41% Επαλ Σκαφ 225γρ', '', '', NULL, 5, 44, '572', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(558, 'Always Σερβ Ultra Platinum Night 6τεμ', '', '', NULL, 4, 38, '573', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(559, 'Ελιά Νεαρού Μοσχ Α/Ο Νωπή Εισ', '', '', NULL, 5, 98, '574', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(560, 'Pom Pon Μαντ Καθαρ Argan Oil 20τεμ', '', '', NULL, 4, 29, '575', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(561, 'Lenor Υγρό Απορρυπαντικό Ρούχων Gold Orchid 19μεζ', '', '', NULL, 3, 9, '576', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(562, 'Φράουλες Εγχ', '', '', NULL, 5, 100, '577', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(563, 'Life Χυμός Φυσικός Πορτοκάλι 1λιτ', '', '', NULL, 2, 21, '578', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(564, 'Φάγε Τρικαλινό Τυρί Ζάρι Φάγε 380γρ', '', '', NULL, 5, 72, '580', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(565, 'Fissan Baby Πούδρα 100gr', '', '', NULL, 1, 11, '581', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(566, 'Barilla Cannelloni 250γρ', '', '', NULL, 5, 49, '582', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(567, 'McCain Πατάτες Mediterannean 750γρ', '', '', NULL, 5, 82, '583', 'ee0022e7b1b34eb2b834ea334cda52e7', '5c5e625b739b4f19a117198efae8df21'),
(568, 'Λαυράκια Υδατ  Καθαρ Ελλην400/600 Μεσογ Συσκ/Να', '', '', NULL, 5, 93, '584', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(569, 'Skip Υγρό Regular 30πλ', '', '', NULL, 3, 9, '585', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(570, 'Cajoline Συμπυκνωμένο Μαλακτικό Blue Fresh 30μεζ', '', '', NULL, 3, 9, '586', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(571, 'Knorr Μανιταρόσουπα 90γρ', '', '', NULL, 5, 48, '588', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eef696c0f874603a59aed909e1b4ce2'),
(572, 'Ajax Antistatic Καθαριστικό Για Τζάμια Αντλία 750ml', '', '', NULL, 3, 5, '590', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(573, 'Palmolive Αφρόλ Natural Αμυγδ 650ml', '', '', NULL, 4, 12, '591', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(574, 'Soupline Mistral Μαλακτικό Συμπ 82πλ', '', '', NULL, 3, 5, '592', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(575, 'Όλυμπος Κεφαλοτύρι Προβ 250γρ', '', '', NULL, 5, 72, '593', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(576, 'Joya Ρόφημα Σογιας Bio Χ Ζαχ 1λιτ', '', '', NULL, 5, 78, '594', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(577, 'Κρεμμύδια Κόκκινα Ξερά Εισ ', '', '', NULL, 5, 99, '596', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(578, 'Forno Bonomi Μπισκ Σφολιατ 200γρ', '', '', NULL, 5, 45, '597', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(579, 'Κρεμμύδια Ξανθά Ξερά Εγχ', '', '', NULL, 5, 99, '598', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(580, 'Gillette Sensor Excel Ανταλ Ξυρ 5 τεμ', '', '', NULL, 4, 26, '599', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(581, 'Johnson Baby Βρεφικό Σαμπουάν Χαμομήλι Αντλιά 500ml', '', '', NULL, 1, 26, '601', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(582, 'Mini Babybel Τυρί Classic 10τεμ 200γρ', '', '', NULL, 5, 72, '603', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(583, 'Hansaplast Universal Αδιάβροχα 40τεμ', '', '', NULL, 4, 34, '604', '8e8117f7d9d64cf1a931a351eb15bd69', '1b59d5b58fb04816b8f6a74a4866580a'),
(584, 'Nivea After Shave Balsam 100ml', '', '', NULL, 4, 33, '605', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(585, 'Nivea Baby Φυσιολογικός Ορός 24Χ5ml', '', '', NULL, 4, 29, '606', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(586, 'Nivea After Shave Balsam Sens 100ml', '', '', NULL, 4, 33, '607', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(587, 'Nivea Κρ Νύχτας Cellular Anti-Age 50ml', '', '', NULL, 4, 29, '608', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(588, 'Wella New Wave Πηλός Γλυπτικής 75ml', '', '', NULL, 4, 30, '609', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(589, 'Nestle Nesquik 375γρ', '', '', NULL, 5, 80, '610', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(590, 'Brasso Γυαλιστικό Μετάλλων 150ml', '', '', NULL, 3, 5, '611', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(591, 'Johnnie Walker Ουίσκι Black Label 12ετών', '', '', NULL, 2, 20, '613', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(592, 'Κανάκι Ζύμη Κατεψυγμένη Κουρού 700γρ', '', '', NULL, 5, 52, '614', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(593, 'Finish Εκθαμβωτικό Υγρο Πλυν Πιάτ 400ml', '', '', NULL, 3, 5, '615', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(594, 'Ίον Σοκολ Αμυγδ Υγείας 100γρ', '', '', NULL, 5, 46, '616', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(595, 'Texas Νιφάδες Βρώμης 500γρ', '', '', NULL, 5, 80, '617', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(596, 'Ribena Φρουτοποτό Φραγκοστάφυλλο 250ml', '', '', NULL, 2, 21, '618', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(597, 'Ήπειρος Φέτα Μαλακή 400γρ', '', '', NULL, 5, 72, '619', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(598, 'Υφαντής Παριζάκι 330γρ', '', '', NULL, 5, 42, '620', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(599, 'Γιώτης Φρουιζελέ Κεράσι Σε Σκ 200γρ', '', '', NULL, 5, 45, '623', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(600, 'Dirollo Τυρί Ημισκλ 14% Λιπ Φετ 175γρ', '', '', NULL, 5, 72, '624', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(601, 'Παπαδοπούλου Πτι Μπερ Ολικ Αλ 225γρ', '', '', NULL, 5, 87, '625', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(602, 'Παπαδοπούλου Φρυγανιές Χωριάτικες Ολικής Άλεσης 240γρ', '', '', NULL, 5, 90, '626', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(603, 'Amita Φυσικός Χυμός Πορτοκάλι 100% 1λιτ', '', '', NULL, 2, 21, '627', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(604, 'Δέλτα Γάλα Daily Υψ Παστ Χ Λακτ 1λιτ', '', '', NULL, 5, 10, '628', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(605, 'Dixan Υγρό Απορρυπαντικό Ρούχων Άνοιξης 30μεζ', '', '', NULL, 3, 9, '629', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(606, 'Gillette Fusion Proglide Power Ανταλ 3 τεμ', '', '', NULL, 4, 26, '630', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(607, 'Jannis Παστέλι Σουσάμι Χ Γλ 70γρ', '', '', NULL, 5, 78, '631', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(608, 'Cair Αφρώδης Λευκός Ημίξηρος Οίνος 750ml', '', '', NULL, 2, 19, '632', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(609, 'Σπάλα Βόειου Α/Ο Νωπή Ελλ Εκτρ Άνω Των 5 Μην', '', '', NULL, 5, 98, '633', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(610, 'Παυλίδης Σοκολάτα Υγείας Ν11 100γρ', '', '', NULL, 5, 46, '634', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(611, 'Μιμίκος Κοτόπουλο Στηθ Φιλ Νωπό Τυποπ 845γρ', '', '', NULL, 5, 55, '635', 'ee0022e7b1b34eb2b834ea334cda52e7', '463e30b829274933ab7eb8e4b349e2c5'),
(612, 'Κανάκι Λουκανικοπιτάκια Κατεψυγμένα 920γρ', '', '', NULL, 5, 85, '637', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(613, 'Κύκνος Κέτσαπ Top Down Χ Γλουτ 580γρ', '', '', NULL, 5, 78, '638', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(614, 'Κύκνος Τοματοπολτός 28% Μεταλ 70γρ', '', '', NULL, 5, 63, '639', 'ee0022e7b1b34eb2b834ea334cda52e7', '5aba290bf919489da5810c6122f0bc9b'),
(615, 'Δέλτα Γάλα 2λιτ', '', '', NULL, 5, 10, '640', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(616, 'Persil Express Σκόνη Χεριού 420γρ', '', '', NULL, 3, 9, '641', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(617, 'Καραμολέγκος Δέκα Αρτοσκεύασμα Σταρένιο Σε Φέτες 550γρ', '', '', NULL, 5, 74, '642', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(618, 'Hellmann\'s Μουστάρδα Απαλή 250γρ', '', '', NULL, 5, 86, '643', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(619, '7 Days Κρουασάν Κακάο 3Χ70γρ', '', '', NULL, 5, 69, '644', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(620, 'Μεβγάλ Γιαούρτι Πρόβειο Παραδ 300γρ', '', '', NULL, 5, 13, '645', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(621, 'Μεβγάλ Στραγγιστό Γιαούρτι 1κιλ', '', '', NULL, 5, 13, '646', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(622, 'Μεβγάλ Γάλα «Κάθε Μέρα» 1.5% 1λιτ', '', '', NULL, 5, 10, '647', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(623, 'Μεβγάλ Ζελέ Ροδάκινο 3Χ150γρ', '', '', NULL, 5, 47, '650', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(624, 'Μεβγάλ Κεφίρ Φράουλα 500ml', '', '', NULL, 5, 10, '651', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(625, 'Μινέρβα Αραβοσιτέλαιο 1λιτ', '', '', NULL, 5, 57, '652', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(626, 'Babylino Sensitive Econ Ν5+ 13-27κιλ 42τεμ', '', '', NULL, 1, 1, '653', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(627, 'Μινέρβα Αραβοσιτέλαιο 2λιτ', '', '', NULL, 5, 57, '654', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(628, 'Lacta Σοκολάτα Γάλακτος 200γρ', '', '', NULL, 5, 46, '656', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(629, 'Palette Βαφή Μαλ Ξανθό N8', '', '', NULL, 4, 23, '657', '8e8117f7d9d64cf1a931a351eb15bd69', '09f2e090f72c4487bc44e5ba4fcea466'),
(630, 'Δωδώνη Τυρί Φέτα 400γρ Σε Άλμη', '', '', NULL, 5, 72, '658', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(631, 'Nivea Μάσκα Peel Off 10ml', '', '', NULL, 4, 29, '659', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(632, 'Μήλα Στάρκιν Ψιλά Συσκ/Να ', '', '', NULL, 5, 100, '660', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(633, 'Melissa Σιμιγδάλι Ψιλό 500γρ', '', '', NULL, 5, 41, '661', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(634, 'Κορπή Φυσικό Μεταλλικό Νερό1,5λιτ', '', '', NULL, 2, 18, '662', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(635, 'Adoro Κρέμα Γάλακτος 35% Λιπαρά 200ml', '', '', NULL, 5, 56, '664', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(636, 'Baby Care Μωρομάντηλα Χαμομήλι Minipack 12τεμ', '', '', NULL, 1, 14, '665', '8016e637b54241f8ad242ed1699bf2da', '92680b33561c4a7e94b7e7a96b5bb153'),
(637, 'Knorr Ρύζι Risonatto Milanaise 220γρ', '', '', NULL, 5, 66, '666', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(638, 'Folie Κρουασάν Κρέμα Κακαο 80γρ', '', '', NULL, 5, 69, '667', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(639, 'Ωμέγα Special Ρύζι Νυχάκι 500γρ', '', '', NULL, 5, 66, '668', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(640, 'Amstel Μπύρα 6Χ330ml', '', '', NULL, 2, 3, '669', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(641, 'Μπάρμπα Στάθης Σαλάτα Καλαμπ 450γρ', '', '', NULL, 5, 84, '670', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(642, 'Κρεμμύδια Κόκκινα Ξερά Εγχ', '', '', NULL, 5, 99, '671', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(643, 'Everyday Σερβ Maxi Nig/Ultra Plus Sens 10τεμ', '', '', NULL, 4, 38, '672', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(644, 'Zwan Luncheon Meat 200γρ', '', '', NULL, 5, 54, '673', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(645, 'Alfa Μπουγάτσα Με Σπανάκι Και Τυρί Κατεψυγμένη 850γρ', '', '', NULL, 5, 85, '675', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(646, 'Knorr Κύβοι Ζωμού Κότας 6λιτ 12τεμάχια', '', '', NULL, 5, 62, '676', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(647, 'Hellmann\'s Μουστάρδα Απαλή 500γρ', '', '', NULL, 5, 86, '677', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(648, 'Μεβγάλ High Protein Φρα Drink 237ml', '', '', NULL, 5, 10, '679', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(649, 'Babylino Πάνες Μωρού Sensitive 4 - 9 κιλ No 3 22τεμ', '', '', NULL, 1, 1, '680', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(650, 'Babylino Sensitive No5 Econ 11-25κιλ 44τεμ', '', '', NULL, 1, 1, '681', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(651, 'Μίνι Ούζο Επομ 700ml', '', '', NULL, 2, 20, '682', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(652, 'Coca Cola 330ml', '', '', NULL, 2, 4, '683', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(653, 'Jose Cuervo Τεκίλα Espec Κιτρ 0,7λιτ', '', '', NULL, 2, 20, '684', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(654, 'Camel Υγρο Δερμα Παπουτσιών Μαύρο 75ml', '', '', NULL, 4, 24, '685', '8e8117f7d9d64cf1a931a351eb15bd69', 'a610ce2a98a94ee788ee5f94b4be82c2'),
(655, 'Noxzema Αφρόλ Talc 750ml', '', '', NULL, 4, 12, '686', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(656, 'Ava Υγρό Πιάτων Perle Χαμομήλι/Λεμόνι 1500ml', '', '', NULL, 3, 9, '687', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(657, 'Bioten 24η Κρέμα Ενυδ 50ml', '', '', NULL, 4, 35, '688', '8e8117f7d9d64cf1a931a351eb15bd69', 'fefa136c714945a3b6bcdcb4ee9e8921'),
(658, 'Oral B Στοματικό Διαλ Δοντ/Ουλων 500ml', '', '', NULL, 4, 39, '689', '8e8117f7d9d64cf1a931a351eb15bd69', '181add033f2d4d95b46844abf619dd30'),
(659, 'Calgon Gel 750ml', '', '', NULL, 3, 5, '690', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(660, 'Νουνού Γάλα Ζαχαρούχο 397γρ', '', '', NULL, 5, 10, '691', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(661, 'Dettol Κρεμοσάπουνο Citrus 250ml', '', '', NULL, 4, 36, '692', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(662, 'Lipton Τσάι Κίτρινο Φακ 20τεμΧ1,5γρ', '', '', NULL, 5, 65, '693', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(663, 'Nivea Νερό Διφασ Ντεμακ Ματιών 125ml', '', '', NULL, 4, 29, '694', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(664, 'Vanish Oxi Action Ενισχ Πλύσης 500γρ', '', '', NULL, 3, 5, '695', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(665, 'Vanish Pink Πολυκαθαριστικό Λεκέδων 30γρ', '', '', NULL, 3, 5, '696', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(666, 'Grants Ουίσκι 0,7λιτ', '', '', NULL, 2, 20, '697', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(667, '7 Days Κέικ Bar Κακάο 5Χ30γρ', '', '', NULL, 5, 50, '698', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(668, 'Pedigree Denta Stix Small Σκύλου 110γρ', '', '', NULL, 8, 104, '699', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(669, 'Νίκας Ωμοπλάτη Χωρίς Γλουτένη 160γρ', '', '', NULL, 5, 78, '700', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(670, 'Septona Παιδικό Σαμπουάν Κορίτσια 500ml', '', '', NULL, 1, 78, '701', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(671, 'Septona Σερβιέτες Sensitive Ultra Plus Night 8τεμ', '', '', NULL, 4, 38, '702', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(672, 'Adoro Βούτυρο 250γρ', '', '', NULL, 5, 44, '703', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(673, 'CIF Spray Κουζίνας 500ml', '', '', NULL, 3, 5, '704', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(674, 'Νουνού Γάλα Light Μερίδες Διχ 10Χ15γρ', '', '', NULL, 5, 10, '705', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(675, 'Agrino Ρύζι Basmati Χ Γλουτ 500γρ', '', '', NULL, 5, 66, '706', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(676, 'Κύκνος Τοματοπολτός 200γρ', '', '', NULL, 5, 63, '709', 'ee0022e7b1b34eb2b834ea334cda52e7', '5aba290bf919489da5810c6122f0bc9b'),
(677, 'Ruffles Barbeque 130γρ', '', '', NULL, 5, 70, '710', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(678, 'Μύλοι Αγίου Γεωργίου Easy Bake Μειγ Muffin 500γρ', '', '', NULL, 5, 45, '711', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(679, 'Philadelphia Τυρί Light 200γρ', '', '', NULL, 5, 72, '712', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(680, 'Gillette Venus Ξυρ Γυν Ανταλ 4τεμ', '', '', NULL, 4, 26, '713', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(681, 'Καραμολέγκος Ψωμί Τόστ Δέκα Χωριάτικο 500γρ', '', '', NULL, 5, 74, '714', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(682, 'Καραμολέγκος Παξαμάς Σικαλης 400γρ', '', '', NULL, 5, 89, '715', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(683, 'Akis Καλαμποκάλευρο 500γρ', '', '', NULL, 5, 41, '716', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(684, 'Λάπα Νεαρού Μοσχ Α/Ο Νωπή Εισ', '', '', NULL, 5, 98, '717', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(685, 'Nivea Γαλάκτωμα Καθαρισμού 200ml', '', '', NULL, 4, 29, '718', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(686, 'Maggi Noodles Γεύση Κοτόπουλο 60γρ', '', '', NULL, 5, 48, '719', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eef696c0f874603a59aed909e1b4ce2'),
(687, 'Όλυμπος Γιαούρτι Στραγγ 10% Λ 3Χ200γρ', '', '', NULL, 5, 13, '720', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(688, 'Μέλισσα Κριθαράκι Μέτριο 500γρ', '', '', NULL, 5, 49, '721', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(689, 'Dr Beckmann Καθαριστικο Φουρνου 375ml', '', '', NULL, 3, 5, '722', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(690, 'Παπαδοπούλου Κριτσίνια Μακεδ Ολ Αλ 200γρ', '', '', NULL, 5, 89, '723', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(691, 'Μεβγάλ Τριμμένο Σκληρό Τυρί 200γρ', '', '', NULL, 5, 72, '724', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(692, 'Alfa Κιχι Παραδοσιακή Πίτα Με Τυρί 800γρ', '', '', NULL, 5, 85, '725', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(693, '3 Άλφα Φασόλια Χονδρά Εισαγωγής 500γρ', '', '', NULL, 5, 58, '726', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(694, 'Δέλτα Ρόφημα Advance Υψ Παστ Μπουκ 1λιτ', '', '', NULL, 5, 10, '727', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(695, 'Μιμίκος Κοτόπουλο Φιλ Μπούτ Νωπό Τυποπ 650γρ', '', '', NULL, 5, 55, '728', 'ee0022e7b1b34eb2b834ea334cda52e7', '463e30b829274933ab7eb8e4b349e2c5'),
(696, '3 Άλφα Ρύζι Γλασσέ 500γρ', '', '', NULL, 5, 66, '729', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(697, 'Εύρηκα Bright Ενισχυτικό Πλύσης Πολυκαθαριστικό Λεκέδων 500g', '', '', NULL, 3, 9, '730', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(698, 'Ροδόπη Γιαούρτι Πρόβειο Βιο 240γρ', '', '', NULL, 5, 13, '731', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(699, 'Leerdammer Τόστ Light 10 φέτες 175γρ', '', '', NULL, 5, 72, '733', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb');
INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(700, 'Τσίπουρα Υδατ Ελλην Β 200/300 Μεσογ', '', '', NULL, 5, 93, '734', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(701, 'Εβόλ Γάλα Παστερ Αγελαδ Βιολ 1λιτ', '', '', NULL, 5, 10, '735', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(702, 'Χρυσή Ζύμη Κρουασάν Βουτύρου 300γρ', '', '', NULL, 5, 52, '736', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(703, 'Fa Αφρόλ Yoghurt Van Honey 750m', '', '', NULL, 4, 12, '737', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(704, 'Μήλα Στάρκιν Εισ', '', '', NULL, 5, 100, '738', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(705, 'Μύλοι Αγίου Γεωργίου Αλεύρι Για Όλες Τις Χρ 1κιλ', '', '', NULL, 5, 41, '739', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(706, 'Δωδώνη Γιαούρτι Στραγγιστό 8% 1κιλ', '', '', NULL, 5, 13, '740', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(707, 'Τσανός Μουστοκούλουρα 300γρ', '', '', NULL, 5, 67, '741', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(708, 'Calgon Αποσκληρυντικό Νερού Πλυντηρίου Ρουχων Gel 1.5λιτ', '', '', NULL, 3, 9, '742', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(709, 'Παπαδοπούλου Krispies Ολικής Χωρίς Ζάχαρη 200γρ', '', '', NULL, 5, 78, '743', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(710, 'Χυμός Ρόδι/Μηλ/Καρ Χριστοδούλου 1λιτ', '', '', NULL, 2, 21, '744', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(711, 'Νουνού Γάλα Family 3,6% 1λιτ', '', '', NULL, 5, 10, '745', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(712, 'Παπαδημητρίου Balsamico Βιολογικό Καλαμάτας 250ml', '', '', NULL, 5, 61, '746', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(713, 'Νουνού Κρέμα Γάλακτος Πλήρης 2Χ330ml', '', '', NULL, 5, 56, '747', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(714, 'Μέλισσα Κριθαράκι Χονδρό 500γρ', '', '', NULL, 5, 49, '748', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(715, 'Topine Υγρό Επιφ Red Pine 1λιτ', '', '', NULL, 3, 5, '749', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(716, 'Calgon Ταμπλέτες 15τεμ', '', '', NULL, 3, 5, '751', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(717, 'Flora Maργαρίνη Soft 60% Λιπ 225γρ', '', '', NULL, 5, 44, '752', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(718, 'Swiffer Dusters 5τεμ+Χειρολαβή', '', '', NULL, 3, 17, '753', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(719, 'Fairy Υγρό Απορρυπαντικό Πιάτων Power Spray 375ml', '', '', NULL, 3, 9, '754', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(720, 'Septona Σαμπουάν Και Αφρόλουτρο Βρεφικό Με Αλοη 500ml', '', '', NULL, 1, 9, '755', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(721, 'Coca Cola Zero 330ml', '', '', NULL, 2, 4, '756', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(722, 'Ζωγράφος Μακαρόνια Διαίτης Ν6 500γρ', '', '', NULL, 5, 78, '758', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(723, 'Ντομάτες Εγχ Υπαιθρ Τσαμπί ', '', '', NULL, 5, 99, '759', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(724, 'Κρίς Κρίς Τόστιμο Ψωμί Τόστ Σταρένιο 800γρ', '', '', NULL, 5, 74, '760', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(725, 'Lurpak Βούτυρο Ανάλατο 250γρ', '', '', NULL, 5, 44, '762', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(726, 'Στεργίου Κρουασάν Βιέννης Με Κρέμα Σοκολάτα 120γρ', '', '', NULL, 5, 69, '763', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(727, 'Παπαδοπούλου Φρυγανιές Χωριάτικες 240γρ', '', '', NULL, 5, 90, '764', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(728, 'Μάσκες Προστ Προσώπου 50τεμ', '', '', NULL, 7, 102, '765', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(729, 'Μάσκα προσώπου 10τεμ 1 χρήση', '', '', NULL, 7, 102, '766', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(730, 'Lux Aφρόλ Magical Beauty 700ml', '', '', NULL, 4, 12, '767', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(731, 'Fina Τυρί Φέτες 10% Λιπ 175γρ', '', '', NULL, 5, 72, '768', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(732, 'Αγγουράκια Κιλ Τυπ Νειλ – Τυπ Κνωσ', '', '', NULL, 5, 99, '771', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(733, 'Lavazza Καφές Rossa Espresso 250γρ', '', '', NULL, 5, 53, '772', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(734, 'Καρότα Εγχ ', '', '', NULL, 5, 99, '773', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(735, 'Purina One Γατ/Φή Ξηρά Βοδ/Σιτ 800γρ', '', '', NULL, 8, 103, '774', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(736, 'Κοτοπουλα Ολοκληρα Νωπα Χυμα Τ.65% Π.Α.Ελλην', '', '', NULL, 5, 94, '775', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(737, 'Pampers Πάνες Μωρού Premium Care Nο 6 13+κιλ 38τεμ', '', '', NULL, 1, 1, '776', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(738, 'Ντομάτες Εγχ Υδροπ Κατ  Β.  ', '', '', NULL, 5, 99, '777', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(739, 'Nan Optipro Γάλα Τρίτης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 1, 99, '778', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(740, 'Σπάλα Νεαρού Μοσχ Α/Ο Νωπή Εισ', '', '', NULL, 5, 98, '779', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(741, 'Παυλίδης Μερέντα 360γρ', '', '', NULL, 5, 79, '780', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(742, 'Παυλίδης Κουβερτούρα Κλασ 125γρ', '', '', NULL, 5, 46, '781', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(743, 'Παυλίδης Γκοφρέτα Υγείας 34γρ', '', '', NULL, 5, 46, '782', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(744, 'Δέλτα Γάλα Ελαφρύ 1λιτ', '', '', NULL, 5, 10, '783', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(745, 'Intermed Reval Plus Gel Χεριών Lollipop 75ml', '', '', NULL, 6, 101, '784', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(746, 'Veet Κρύο Κερι Ταινίες Προσώπου 20τεμ', '', '', NULL, 4, 26, '785', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(747, 'Campari Bitter Aπεριτίφ 700ml', '', '', NULL, 2, 20, '786', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(748, 'Ferrero Kinder Σοκολ 2πλη 16τεμ Χ Γλουτ 200γρ', '', '', NULL, 5, 78, '787', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(749, 'Πορτοκάλια Βαλέντσια Εισ Ε/Ζ', '', '', NULL, 5, 100, '789', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(750, 'Ρεπάνη Μοσχοφίλερο Λευκός Οίνος 750ml', '', '', NULL, 2, 19, '790', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(751, 'Ντομάτες Εγχ Υπαιθρ Α ', '', '', NULL, 5, 99, '791', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(752, 'Ίον Σοκοφρέτα Σοκολ Υγείας 38γρ', '', '', NULL, 5, 46, '794', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(753, 'Orzene Condit Μπύρας Κανον Μαλλ 250ml', '', '', NULL, 4, 12, '795', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(754, 'Rio Mare Τόνος Νερόυ 2Χ160γρ', '', '', NULL, 5, 54, '796', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(755, 'Life Φρουτοπ Κρανμπ/Ρασμπ/Μπλουμπ 1lt', '', '', NULL, 2, 21, '797', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(756, 'Παπαδοπούλου Παξιμαδάκια Σίτου 200γρ', '', '', NULL, 5, 89, '798', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(757, 'Δέλτα Γιαούρτι Μικ Οικ Φαρμ 2% 2Χ200γρ', '', '', NULL, 5, 13, '799', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(758, 'Hellmann\'s Σαλάτα Φάρμα Κηπ 250γρ', '', '', NULL, 5, 81, '800', 'ee0022e7b1b34eb2b834ea334cda52e7', '4f205aaec31746b89f40f4d5d845b13e'),
(759, 'Skip Duo Καψ Πλυντ Ρούχ Active Clean 578γρ', '', '', NULL, 3, 9, '801', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(760, 'Υφαντής Γαλοπούλα Καπνιστή 160γρ', '', '', NULL, 5, 42, '802', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(761, 'Ντομάτες Τσαμπί Υδροπ Εγχ  Α', '', '', NULL, 5, 99, '803', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(762, 'Autan Family Care Spray 100ml', '', '', NULL, 3, 16, '804', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(763, 'Αύρα Νερό Μεταλ Μπλουμ 330ml', '', '', NULL, 2, 18, '805', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(764, 'Τσίπουρα Υδατ Καθαρ Ελλην  Α 300/400 Μεσογ Συσκ/Νη', '', '', NULL, 5, 93, '806', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(765, 'Trata Σαρδέλα Πικάντικη 100γρ', '', '', NULL, 5, 54, '807', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(766, 'Tsakiris Πατατάκια Ρίγανη 72γρ', '', '', NULL, 5, 70, '808', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(767, 'Ajax Άσπρος Σίφουνας Λεμόνι 1000ml', '', '', NULL, 3, 5, '809', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(768, 'Νουνού Γάλα Σκόνη Frisolac 1ης Βρεφ Ηλικίας 800γρ', '', '', NULL, 1, 5, '810', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(769, 'Kleenex Χαρτί Υγείας 2 Φύλλα 12τεμ', '', '', NULL, 3, 6, '811', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(770, 'Παπαδοπούλου Μπισκότα Μιράντα Ν16 250γρ 12τεμ', '', '', NULL, 5, 87, '812', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(771, 'Martini Bianco Απεριτίφ 1λιτ', '', '', NULL, 2, 20, '813', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(772, 'Axe Αποσμ Σπρέυ Dark Temptation 150ml', '', '', NULL, 4, 7, '814', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(773, 'Hellmann\'s Μαγιονέζα 450ml', '', '', NULL, 5, 86, '815', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(774, 'Υφαντής Ζαμπόν Μπούτι Βραστό Σε Φέτες 160γρ', '', '', NULL, 5, 42, '816', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(775, 'Agrino Ρύζι Parboiled Bella Χ Γλουτ 500γρ', '', '', NULL, 5, 66, '817', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(776, 'Νίκας Σαλαμι Αέρος Συκευασμενο 100γρ', '', '', NULL, 5, 42, '818', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(777, 'Ferrero Rocher Πραλίνες 16τεμ 200γρ', '', '', NULL, 5, 46, '819', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(778, 'Elvive Color Vive Γαλακτ Μαλ 200ml', '', '', NULL, 4, 8, '820', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(779, 'Αλλατίνη Κέικ Κακάο Με Κομμάτια Σοκολάτας 400γρ', '', '', NULL, 5, 50, '821', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(780, 'Σολομός Νωπός Φιλετ/νος Με Δέρμα Υδ Νορβ/Εισαγ  Β.Α Ατλ Ε/Ζ', '', '', NULL, 5, 93, '822', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(781, 'Μύλοι Αγίου Γεωργίου Καλαμποκάλευρο 500γρ', '', '', NULL, 5, 41, '823', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(782, 'Knorr Ζωμός Κότας Σπιτικός 112γρ', '', '', NULL, 5, 62, '824', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(783, 'Proderm Ενυδατική Κρέμα Sleep Easy 150ml', '', '', NULL, 1, 11, '825', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(784, 'Palmolive Υγρό Πιάτων Regular 500ml', '', '', NULL, 3, 9, '826', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(785, 'Palmolive Υγρό Πιάτων Λεμόνι 500ml', '', '', NULL, 3, 9, '827', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(786, 'Scotch Brite Σύρμα Πράσινο Κουζίνας', '', '', NULL, 3, 17, '828', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(787, 'Dettol Υγρό Καθαριστικό Αντιβακτηριδιακό Κουζινας 500ml Με Ενεργο Οξυγονο Power & Pure', '', '', NULL, 3, 5, '829', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(788, 'Almiron-2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 1, 3, '831', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(789, 'Υφαντής Παριζακι Γαλοπούλας 330γρ', '', '', NULL, 5, 42, '832', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(790, 'Noxzema Αφρός Ξυρισ Xtr Sens 300ml', '', '', NULL, 4, 33, '833', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(791, '3 Άλφα Φακές Ψιλές Εισαγωγής 500γρ', '', '', NULL, 5, 58, '834', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(792, 'Bref Wc Power Active Αρωματικό Τουαλέτας Πεύκο 50γρ', '', '', NULL, 3, 5, '835', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(793, 'Barilla Λαζάνια Με Αυγά 500γρ', '', '', NULL, 5, 49, '836', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(794, 'Παπαδοπούλου Ψωμί Τόστ Plus Σίτου 700γρ', '', '', NULL, 5, 74, '838', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(795, 'McCain Πατάτες Tradition Σακ 1κλ', '', '', NULL, 5, 82, '839', 'ee0022e7b1b34eb2b834ea334cda52e7', '5c5e625b739b4f19a117198efae8df21'),
(796, 'Μίσκο Μακαρόνια Ν6 500γρ', '', '', NULL, 5, 49, '840', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(797, 'Misko Ταλιατέλλες Σιμιγδ 500γρ', '', '', NULL, 5, 49, '841', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(798, 'Milner Τυρί Φέτες 175γρ', '', '', NULL, 5, 72, '842', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(799, 'Aim Οδ/τσα 2-6 Παιδική', '', '', NULL, 4, 27, '843', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(800, 'Haribo Goldbaren Καραμ Ζελίνια Αρκουδ 100γρ', '', '', NULL, 5, 60, '844', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(801, 'Γιώτης Ανθός Ορύζης 150γρ', '', '', NULL, 1, 2, '845', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(802, 'Λεμόνια Εγχ', '', '', NULL, 5, 100, '846', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(803, 'Ultrex Σαμπουάν Γυναικ Κανον 360ml', '', '', NULL, 4, 12, '848', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(804, 'Φάγε Μιγμ Tριμ 4 Τυρ 200γρ', '', '', NULL, 5, 72, '849', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(805, 'Φάγε Τυρί Flair Cottage 225γρ', '', '', NULL, 5, 72, '850', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(806, 'Τσίπουρα Υδατ Ελλην Α 300/400 Μεσογ', '', '', NULL, 5, 93, '851', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(807, 'Fytro Σόγια Κιμάς 400γρ', '', '', NULL, 5, 78, '853', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(808, 'Lurpak Soft Αλατισμένο 225γρ', '', '', NULL, 5, 44, '854', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(809, 'Αττική Μέλι 1κιλ', '', '', NULL, 5, 79, '855', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(810, 'Μεβγάλ Only 2% Et Συρτ 3Χ200γρ', '', '', NULL, 5, 13, '856', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(811, 'Schar Mix B Αλεύρι Για Ψωμί 1κιλ', '', '', NULL, 5, 41, '857', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(812, 'Καρπούζια Εγχ', '', '', NULL, 5, 100, '858', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(813, 'Ροδόπη Αριάνι 1,7% 1λιτ', '', '', NULL, 5, 10, '859', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(814, 'Νίκας Γαλοπ Καπνισ + Gouda Τυρί Light Φετ 280γρ', '', '', NULL, 5, 42, '860', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(815, 'Μάννα Παξιμάδια Κριθαρένιο 800γρ', '', '', NULL, 5, 89, '861', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(816, 'Στήθος Φιλέτο Κοτ Ελλην. Νωπό Ε/Ζ Χύμα ', '', '', NULL, 5, 94, '863', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(817, 'Nan Optipro Γάλα Τρίτης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 1, 94, '864', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(818, 'Ferrero Kinder Delice Κέικ 39γρ', '', '', NULL, 5, 50, '865', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(819, 'Always Σερβ Ultra Platinum Night 12τεμ', '', '', NULL, 4, 38, '866', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(820, 'Meritο Spray Σιδερώματος 500ml', '', '', NULL, 3, 5, '867', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(821, 'Βλάχας Γάλα Εβαπορέ Πλήρες 410γρ', '', '', NULL, 5, 10, '868', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(822, 'Παπαδοπούλου Ψωμί Σίτου Φυσ Προζύμι 700γρ', '', '', NULL, 5, 74, '869', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(823, 'Λεμόνια Εισ', '', '', NULL, 5, 100, '871', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(824, 'Μεβγάλ Κεφίρ 500ml', '', '', NULL, 5, 10, '872', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(825, 'Colgate Οδ/τσα Ext Clean Med Twin Pack', '', '', NULL, 4, 27, '873', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(826, 'Silvo Γυαλιστικό Ασημικών 150ml', '', '', NULL, 3, 5, '874', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(827, 'Tsakiris Πατατάκια Αλάτι 120γρ', '', '', NULL, 5, 70, '875', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(828, 'Nivea Visage Ημερ Kρ Απαλ Ενυδ Spf15 50ml', '', '', NULL, 4, 29, '877', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(829, 'Στεργίου Κρουασάνάκια Με Γέμιση Πραλίνα 300γρ', '', '', NULL, 5, 69, '879', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(830, 'Swiffer Dusters Αντ/κα 10τεμ', '', '', NULL, 3, 5, '880', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(831, 'Sol Ηλιέλαιο 1λιτ', '', '', NULL, 5, 57, '881', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(832, 'Septona Παιδικό Αφρόλουτρο & Σαμπουάν Αγορια 750ml', '', '', NULL, 1, 57, '882', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(833, 'Φλώρα Αραβοσιτέλαιο 1λιτ', '', '', NULL, 5, 57, '883', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(834, 'Ήπειρος Τυρί Ελαφρύ Σε Άλμη 400γρ', '', '', NULL, 5, 72, '884', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(835, 'Disaronno Λικέρ 700ml', '', '', NULL, 2, 20, '886', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(836, 'Danone Activia Επιδ Γιαουρ Καρυδ/Βρώμη 2Χ200γρ', '', '', NULL, 5, 13, '887', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(837, 'Κουρτάκη Ρετσίνα 500ml', '', '', NULL, 2, 19, '888', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(838, 'Παν Κρέμα Βαλσάμικο 250ml', '', '', NULL, 5, 61, '889', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(839, 'Λουμίδης Καφές Ελληνικός 96γρ', '', '', NULL, 5, 53, '890', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(840, 'Dettol Υγρό Πολυκαθαριστικό Αντιβακτηριδιακό 500ml Sparkling Lemon & Lime Burst Power & Fresh', '', '', NULL, 3, 5, '891', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(841, 'Μύλοι Αγίου Γεωργίου Αλεύρι Για Πίτσα 1κιλ', '', '', NULL, 5, 41, '892', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(842, 'Johnson Baby Βρεφικό Σαμπουάν Αντλιά 300ml', '', '', NULL, 1, 41, '893', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(843, 'Αρνιά Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ Ε/Ζ', '', '', NULL, 5, 95, '894', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(844, 'Johnnie Walker Ουίσκι Κόκκινο 0,7λιτ', '', '', NULL, 2, 20, '895', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(845, 'Pedigree Denta Stix Med Σκύλου 180γρ', '', '', NULL, 8, 104, '896', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(846, 'Purina Gold Gourmet Γατ/Φή Μους Ψάρι 85γρ', '', '', NULL, 8, 103, '897', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(847, 'Τοπ Ξύδι Κοκκίνου Κρασιού 350ml', '', '', NULL, 5, 61, '898', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(848, 'Μάκβελ Μακαρόνια Σπαγγέτι Ν6 500γρ', '', '', NULL, 5, 49, '899', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(849, 'Δέλτα Ρόφημα Advance 80% Λιγ Λακτ 1λιτ', '', '', NULL, 5, 10, '900', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(850, 'Ήρα Αλάτι Μαγειρικό 1kg', '', '', NULL, 5, 76, '901', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(851, 'Πορτοκ Βαλέντσια  Κατ Α Εγχ Ε/Ζ', '', '', NULL, 5, 100, '902', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(852, 'Σολομός Νωπός Φέτα Μ/Δ & Μ/Ο Υδ Νορβ/Εισαγ  Β.Α Ατλ Συσκ/Νοσ', '', '', NULL, 5, 93, '903', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(853, 'Neomat Σκόνη Πλυντηρίου Ρούχων Άγριο Τριαντάφυλλο 45μεζ', '', '', NULL, 3, 9, '904', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(854, 'Nestle Cheerios 375γρ', '', '', NULL, 5, 80, '905', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(855, 'Babylino Sensitive No4+ Econ 9-20κιλ 46τεμ', '', '', NULL, 1, 1, '906', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(856, 'Sani Pants N2 Medium 14τεμ', '', '', NULL, 4, 28, '907', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(857, 'Durex Προφυλακτικά Jeans 12τεμ', '', '', NULL, 4, 37, '908', '8e8117f7d9d64cf1a931a351eb15bd69', '7cfab59a5d9c4f0d855712290fc20c7f'),
(858, 'Vapona Σκοροκτόνα Φύλλα 20τμχ', '', '', NULL, 3, 16, '909', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(859, 'Μεβγάλ Topino Απαχο Γάλα Κακάο 310ml', '', '', NULL, 5, 10, '910', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(860, 'Κρίς Κρίς Ψωμί Τόστ Μπρίος 400γρ', '', '', NULL, 5, 74, '911', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(861, 'Alfa Ζύμη Για Πίτσα 600γρ', '', '', NULL, 5, 52, '912', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(862, 'Το Μάννα Παξιμάδι Κρίθινο 400γρ', '', '', NULL, 5, 89, '914', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(863, 'Όλυμπος Φυσ Χυμός Μηλ Πορτ Kaρότο 1λιτ', '', '', NULL, 2, 21, '915', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(864, 'Κεραμάρη Μάννα Αλεύρι Για Πίτες 1κιλ', '', '', NULL, 5, 41, '916', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(865, 'Όλυμπος Γιαούρτι Στρ 2% Freelact 2Χ170γρ', '', '', NULL, 5, 78, '917', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(866, 'Knorr Κυβοι Λαχανικών 120γρ', '', '', NULL, 5, 62, '918', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(867, 'Όλυμπος Φυσικός Χυμός Πορτ 500ml', '', '', NULL, 2, 21, '919', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(868, 'Alfa Κασερόπιτα Πηλίου Κατεψυγμένη 850γρ', '', '', NULL, 5, 85, '920', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(869, 'Γιαννιώτη Φύλλο Χωριατ Νωπό 500γρ', '', '', NULL, 5, 52, '921', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(870, 'Τσίπουρα Υδατ Ελλην G 400/600 Μεσογ', '', '', NULL, 5, 93, '922', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(871, 'Ίον Σοκοφρέτα Γάλακτος 38γρ', '', '', NULL, 5, 46, '923', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(872, 'Κύκνος Τοματοχυμός 390ml', '', '', NULL, 5, 75, '924', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(873, 'Neslac Επιδόρπιο Γάλακτος Βανίλια 4Χ100γρ', '', '', NULL, 1, 75, '925', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(874, 'Βλάχας Γάλα Εβαπορέ Ελαφρύ 410γρ', '', '', NULL, 5, 10, '926', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(875, 'Υφαντής Μπουκιές Κοτόπουλο Κτψ 500γρ', '', '', NULL, 5, 91, '927', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(876, 'Pillsbury Φυλλο Ζύμης Για Τάρτα 600γρ', '', '', NULL, 5, 52, '928', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(877, '7 Days Παξιμαδάκια Mini Κλασική Γεύση Bake Rolls 160γρ', '', '', NULL, 5, 89, '929', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(878, 'Friskies Γατ/Φή Πατέ Κοτ/Λαχ 400γρ', '', '', NULL, 8, 103, '930', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(879, 'Johnson Baby Βρεφικό Σαμπουάν Χαμομήλι 300ml', '', '', NULL, 1, 103, '931', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(880, 'Uncle Bens Ρύζι 10 λεπτά 4Χ125γρ', '', '', NULL, 5, 66, '932', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(881, 'Tide Alpine Απορ Χεριού Σκόνη 450γρ', '', '', NULL, 3, 9, '933', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(882, 'Zewa Χαρτομάντηλα Soft/Strong 90τμχ', '', '', NULL, 3, 6, '935', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(883, 'Dettol Αντιβ/κό Σπρέι 500ml', '', '', NULL, 6, 101, '936', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(884, 'Coca Cola Light 330ml', '', '', NULL, 2, 4, '937', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(885, 'Ίον Σοκοφρέτα Γάλακτ Με Φουντούκ 38γρ', '', '', NULL, 5, 46, '938', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(886, 'Nestle Fitness Μπαρες Δημητριακών Crunchy Caramel 6X23.5γρ', '', '', NULL, 5, 57, '939', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(887, 'Παπαδοπούλου Μπισκότα Πτι Μπερ Ν16 225γ 16τεμ', '', '', NULL, 5, 87, '940', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(888, 'Danone Activia Επιδ Γιαουρ Τραγ Απόλ 3Χ200γρ', '', '', NULL, 5, 13, '941', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(889, 'Μεβγάλ Topino Απαχο Γάλα Κακάο 450ml', '', '', NULL, 5, 10, '942', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(890, 'Παυλίδης Kiss Σοκολάτα Γάλ Φράουλα 27,5γρ', '', '', NULL, 5, 46, '943', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(891, 'Στάμου Γιαούρτι Πρόβειο Παραδ 240γρ', '', '', NULL, 5, 13, '944', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(892, 'Pampers Πάνες Μωρού Premium Pants Nο 5 12-17κιλ 34τεμ', '', '', NULL, 1, 1, '945', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(893, 'Head & Shoulders Σαμπουάν Total Care 300ml', '', '', NULL, 4, 12, '946', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(894, 'Kellogg\'s Corn Flakes 375γρ', '', '', NULL, 5, 80, '947', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(895, 'Χρυσή Ζύμη Χορτοπίτα Σπιτική 850γρ', '', '', NULL, 5, 85, '948', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(896, 'Airwick Αντ/Κο Freshmatic Βαν/Ορχιδ 250ml', '', '', NULL, 3, 15, '949', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(897, 'Don Simon Kρασί Sangria Χαρτ 1λιτ', '', '', NULL, 2, 19, '950', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(898, 'Tasty Poppers Classic Ποπ Κορν 81γρ', '', '', NULL, 5, 71, '951', 'ee0022e7b1b34eb2b834ea334cda52e7', '8851b315e2f0486180be07facbc3b21f'),
(899, 'COVER 50τεμ Μάσκ Με Λάστιχο 1 Χρήση', '', '', NULL, 7, 102, '952', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(900, 'Skip Σκόνη Spring Fresh 45μεζ', '', '', NULL, 3, 9, '953', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(901, 'Μπρόκολα Πράσινα Εισ', '', '', NULL, 5, 99, '955', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(902, '7 Days Bake Rolls Pizza 160γρ', '', '', NULL, 5, 67, '956', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(903, '3 Άλφα Ρύζι Γλασέ 1κιλ', '', '', NULL, 5, 66, '957', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(904, 'Ready2U Μάσκες Προστ Προσώπου 50τεμ', '', '', NULL, 7, 102, '958', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(905, 'COVER 10τεμ Μάσκ Με Λάστιχο 1 Χρήση', '', '', NULL, 7, 102, '959', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(906, 'Τρικαλινό Τυρί Φάγε Ελαφ.Φετ.200γρ', '', '', NULL, 5, 72, '960', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(907, 'Dettol Κρεμ Relax Αντ/κο 750ml', '', '', NULL, 6, 101, '961', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(908, 'Κορπή Νερό 6χ0,5ml', '', '', NULL, 2, 18, '963', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(909, 'Σπάλα Βόειου/Ο Νωπή Εισ', '', '', NULL, 5, 98, '964', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(910, 'Klinex Υγρό Απορρυπαντικό Ρούχων Fresh Clean 40μεζ', '', '', NULL, 3, 9, '965', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(911, 'Μινέρβα Χωριό Eλαιόλαδο Εξαιρ Παρθ 4λιτ', '', '', NULL, 5, 57, '967', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(912, 'Παπαδοπούλου Κριτσίνια Σουσάμι 130γρ', '', '', NULL, 5, 89, '968', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(913, 'Νίκας Σαλάμι Αέρος 72 Πικάντ Χ Γλ 165γρ', '', '', NULL, 5, 42, '969', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(914, 'Cutty Sark Ουίσκι 0,7λιτ', '', '', NULL, 2, 20, '970', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(915, 'Σολομός Νωπός Φέτα Μ/Δ & Μ/Ο  Υδ Νορβ/Εισαγ  Β.Α Ατλ Ε/Ζ', '', '', NULL, 5, 93, '971', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(916, 'Μεβγάλ Creme Καραμελέ 150γρ', '', '', NULL, 5, 47, '972', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(917, 'Γιώτης Αλεύρι Φαρίνα Ολικής Άλεσης 500γρ', '', '', NULL, 5, 41, '973', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(918, 'Ελιά Βόειου Α/Ο Νωπή Εισ', '', '', NULL, 5, 98, '974', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(919, 'Pemα Ψωμί Σικ Ολ Άλεσης 500γρ', '', '', NULL, 5, 74, '975', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(920, 'Μπανάνες Dole Εισ', '', '', NULL, 5, 100, '976', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(921, 'Νεκταρίνια Εγχ', '', '', NULL, 5, 100, '977', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(922, 'Μήλα Φουτζι Εγχ ', '', '', NULL, 5, 100, '978', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(923, 'Bonne Maman Μαρμελάδα Βερικ Χ Γλ 370γρ', '', '', NULL, 5, 78, '979', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(924, 'Πορτοκ Μερλίν - Λανε Λειτ- Ναβελ Λειτ Εγχ Χυμ Συσκ/Να', '', '', NULL, 5, 100, '980', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(925, 'Pampers Πάνες Premium Care Nο 4 8-14 κιλ 52τεμ', '', '', NULL, 1, 1, '981', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(926, 'O.B. Ταμπόν Original Normal 16τμχ', '', '', NULL, 4, 38, '982', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(927, 'Νίκας Μπέικον Καπνιστό Συσκευασμένο 100γρ', '', '', NULL, 5, 42, '983', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(928, 'Dixan Σκόνη Πλυντ 42πλ 2,31γρ', '', '', NULL, 3, 9, '984', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(929, 'Ρεπάνη Αγιωργίτικος Ερυθρός Οίνος 750ml', '', '', NULL, 2, 19, '985', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(930, 'Lurpak Soft Μειωμέν Λιπαρ Ανάλ 225γρ', '', '', NULL, 5, 44, '986', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(931, 'Libresse Σερβιέτες Invisible Normal 10τεμ', '', '', NULL, 4, 38, '987', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(932, 'Haig Ουίσκι 0,7λιτ', '', '', NULL, 2, 20, '988', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(933, 'Ariel Υγρές Καψ 3σε1 Κανονικό 24πλ', '', '', NULL, 3, 9, '989', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(934, 'Ούζο 12 0,7λιτ', '', '', NULL, 2, 20, '990', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(935, 'Life Φρουτοποτό Πορτοκ/Μηλ/Καροτ 1λιτ', '', '', NULL, 2, 21, '991', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(936, 'Φάγε Total Γιαούρτι Στραγγιστό 1κιλ', '', '', NULL, 5, 13, '992', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(937, 'Dove Σαπούνι 100γρ', '', '', NULL, 4, 36, '993', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(938, 'Peppa Pig Φρουτοποτό Τροπ Φτούτα 250ml', '', '', NULL, 2, 21, '994', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(939, 'Κρασί Της Παρέας Λευκό 1λιτ', '', '', NULL, 2, 19, '995', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(940, 'Μεβγάλ Κρεμα Σοκολάτα 150γρ', '', '', NULL, 5, 47, '996', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(941, 'Μεβγάλ Ανθότυρο Τυποπ 300γρ', '', '', NULL, 5, 72, '997', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(942, 'Καλλιμάνης Πέρκα Φιλέτο 595γρ', '', '', NULL, 5, 83, '998', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(943, 'Ίον Σοκολάτα Γάλακτος 100γρ', '', '', NULL, 5, 46, '999', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(944, 'Creta Farms Εν Ελλάδι Κοτομπουκιές Κτψ 400γρ', '', '', NULL, 5, 91, '1000', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(945, 'Soupline Mistral Μαλακτικό 13πλ', '', '', NULL, 3, 5, '1001', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(946, 'Glade Αντ/Κο Αποσμ Χώρου Λεβάντα', '', '', NULL, 3, 15, '1002', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(947, 'Κανάκι Tυροπιτάκια Κουρού 800γρ', '', '', NULL, 5, 85, '1003', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(948, 'Χρυσή Ζύμη Σφολιάτα 850γρ', '', '', NULL, 5, 52, '1004', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(949, 'Sanitas Αλουμινόχαρτο 30μ', '', '', NULL, 3, 17, '1006', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(950, 'Λουμίδης Καφές Ελληνικός 490γρ', '', '', NULL, 5, 53, '1007', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(951, 'Everyday Σερβ Extr Long/Ultra Plus Sens 10τεμ', '', '', NULL, 4, 38, '1008', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(952, 'Everyday Σερβ Super/Ultra Plus Hyp 18 τεμ', '', '', NULL, 4, 38, '1009', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(953, 'Όλυμπος Γάλα Freelact 1λιτ Χ.Λακτ', '', '', NULL, 5, 10, '1010', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(954, 'Everyday Σερβ/Κια Norm All Cotton 24τεμ', '', '', NULL, 4, 38, '1011', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(955, 'Λακώνια Φυσ Χυμός Πορτοκάλι 250ml', '', '', NULL, 2, 21, '1012', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(956, 'Κατσίκια Νωπά Ελλην Γαλ Ολοκλ Χ/Κ Χ/Σ ', '', '', NULL, 5, 96, '1015', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(957, 'Gillette Fusion Proglide 5+1 Ανταλ', '', '', NULL, 4, 26, '1016', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(958, 'Υφαντής Χάμπουργκερ Top Burger 70γρ', '', '', NULL, 5, 91, '1017', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(959, 'Friskies Γατ/Φή Πατέ Μοσχάρι 400γρ', '', '', NULL, 8, 103, '1018', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(960, 'Twix Σοκολάτα Μπισκότο 50γρ', '', '', NULL, 5, 46, '1019', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(961, 'Γιώτης Sanilac 2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 1, 46, '1020', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(962, 'Υφαντής Μπέικον Καπνιστό Χ Γλουτ 100γρ', '', '', NULL, 5, 78, '1021', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(963, 'Everyday Σερβ Norm/Ultra Plus Hyp 18τεμ', '', '', NULL, 4, 38, '1022', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(964, 'Gillette Blue Ii Plus Slalom Sensit 5τεμ', '', '', NULL, 4, 26, '1023', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(965, 'Nivea Κρ Ημέρας Ξηρ/Ευαίσθ Επιδ SPF15 50ml', '', '', NULL, 4, 29, '1024', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(966, 'Το Μάννα Παξιμάδια Λαδ Κυθήρων 500γρ', '', '', NULL, 5, 89, '1025', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(967, 'Όλυμπος Γάλα Ζωής Λευκό Υψ Παστ 1,5% Λ 1,5λιτ', '', '', NULL, 5, 10, '1026', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(968, 'Gillette Ξυρ Μηχ Mach 3 Turbo+Ανταλ', '', '', NULL, 4, 26, '1027', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(969, 'Ajax Kloron 2σε1 Λεμόνι 1λιτ', '', '', NULL, 3, 5, '1028', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(970, 'Φάγε Κεφαλοτύρι Τριμμένο 200γρ', '', '', NULL, 5, 72, '1029', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(971, 'Αρνιά Νωπά Ελλην Γαλ Ολοκλ Μ/Κ Μ/Σ ', '', '', NULL, 5, 95, '1031', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(972, 'Μάσκα Προσ 10τεμ 1 Χρήση', '', '', NULL, 7, 102, '1032', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(973, 'Ζωγράφος Μαρμελ Φράουλ Φρουκτ 415γρ', '', '', NULL, 5, 79, '1034', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(974, 'Σαβόϊ Βούτυρο Τύπου Κερκύρας 250gr', '', '', NULL, 5, 44, '1035', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(975, 'Vidal Αφρόλ White Musk 750ml', '', '', NULL, 4, 12, '1036', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(976, 'Misko Παραδ Χυλοπίτες Με Αυγά Μετσόβου 500γρ', '', '', NULL, 5, 49, '1037', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(977, 'Κατσέλης Κριτσίνια Μακεδονικά 200γρ', '', '', NULL, 5, 89, '1038', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(978, 'Όλυμπος Γάλα Επιλεγμ 1,5% Λ 1λιτ', '', '', NULL, 5, 10, '1039', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(979, 'Τσιλιλή Τσίπουρο Χ Γλυκάνισο 200ml', '', '', NULL, 2, 20, '1040', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(980, 'Green Cola 330ml', '', '', NULL, 2, 4, '1041', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(981, 'Pillsbury Ζύμη Κρουασάν 230γρ', '', '', NULL, 5, 52, '1043', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(982, 'Στεργίου Κέικ Ανάμικτο 400γρ', '', '', NULL, 5, 50, '1044', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(983, 'Becel Pro Activ Ελαιόλαδο 35% Λιπ 250γρ', '', '', NULL, 5, 44, '1045', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(984, 'Zewa Χαρ Υγείας Ultra Soft 8τεμ 912γρ', '', '', NULL, 3, 6, '1047', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(985, 'Fouantre Γαλοπούλα Σε Φέτες 120γρ', '', '', NULL, 5, 42, '1048', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(986, 'Nestle Fitness 375γρ', '', '', NULL, 5, 80, '1049', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(987, 'Nescafe Azera Καφές Espresso 100% Arabica 100γρ', '', '', NULL, 5, 53, '1050', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(988, 'Ajax Υγρό Γενικού Καθαρισμού Kloron Lila 1λιτ', '', '', NULL, 3, 5, '1051', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(989, 'Nescafe Dolce Gusto Espresso Int Καψ 16x7γρ', '', '', NULL, 5, 53, '1052', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(990, 'Λουξ Σόδα 330ml', '', '', NULL, 2, 4, '1053', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(991, 'Gillette Blue Ii Fixed Head 5τεμ', '', '', NULL, 4, 26, '1054', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(992, 'Γαύρος Νωπός Ελλην Μεσόγ Ολόκλ Ε/Ζ', '', '', NULL, 5, 92, '1055', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(993, 'Green Cola 1,5λιτ', '', '', NULL, 2, 4, '1056', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(994, 'Larisa Μάσκα χειρουργική 5τεμ 1 χρήση 3ply', '', '', NULL, 7, 102, '1057', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(995, 'Nivea Κρέμα Ξυρίσματος 100ml', '', '', NULL, 4, 33, '1058', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(996, 'Μεβγάλ Harmony 1% Με Μέλι/Γκραν 164γρ', '', '', NULL, 5, 13, '1059', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(997, 'Ντομάτες Εισ Α', '', '', NULL, 5, 99, '1060', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(998, 'Kerrygold Τυρί Regato 270γρ', '', '', NULL, 5, 72, '1062', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(999, 'Ace Gentile Ενισχυτικό Πλύσης 1lt', '', '', NULL, 3, 5, '1063', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1000, 'Sensodyne Οδ/μα Repair/Protect 75ml', '', '', NULL, 4, 40, '1064', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1001, 'Λακώνια Χυμός Νέκταρ Πορ/Μηλ/Βερ 250ml', '', '', NULL, 2, 21, '1065', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1002, 'Gordon\'s Τζιν 0,7λιτ', '', '', NULL, 2, 20, '1066', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1003, 'Gordons Space Τζιν Original 275ml', '', '', NULL, 2, 20, '1068', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1004, 'Heineken Μπύρα 4X500ml', '', '', NULL, 2, 3, '1069', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1005, 'Leerdammer Τυρί Τοστ Special 125γρ', '', '', NULL, 5, 72, '1070', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1006, 'Anatoli Πιπέρι Μαύρο Μύλος 45gr', '', '', NULL, 5, 76, '1071', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(1007, 'Δέλτα Γάλα Πλήρες 1λιτ', '', '', NULL, 5, 10, '1072', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1008, 'Kellogg\'s Special K Μπάρα Δημητριακών Με Ξηρούς Καρπούς Καρύδα Και Κασioυς 4Χ28γρ', '', '', NULL, 5, 80, '1073', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1009, 'Tuborg Club Σόδα 500ml', '', '', NULL, 2, 4, '1074', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1010, 'Proderm Kids Αφρόλουτρο Χαμομήλι 700ml', '', '', NULL, 1, 4, '1075', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1011, 'Μεβγάλ Τριμμενη Μυζήθρα Ξηρή 200γρ', '', '', NULL, 5, 72, '1076', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1012, 'Coca Cola 250ml', '', '', NULL, 2, 4, '1077', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1013, 'Corona Μπύρα Extra 355ml', '', '', NULL, 2, 3, '1078', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1014, 'La Vache Qui Rit Τυρί Φέτες Light 200γρ', '', '', NULL, 5, 72, '1079', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1015, 'Ζωγράφος Φρουκτόζη 400γρ', '', '', NULL, 5, 88, '1080', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(1016, 'Ίον Σοκολάτα Γάλακτος Αμυγδάλου 100γρ', '', '', NULL, 5, 46, '1081', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1017, 'Ίον Σοκολάτα Αμυγδάλου 70γρ', '', '', NULL, 5, 46, '1082', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1018, 'Morfat Κρέμα Σαντιγύ Μετ 250γρ', '', '', NULL, 5, 45, '1083', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1019, 'Χρυσή Ζύμη Τυροπιτάκια 1κιλ', '', '', NULL, 5, 52, '1084', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1020, 'Friskies Σκυλ/Φή Ξηρ Κοτ/Λαχ 1,5κιλ', '', '', NULL, 8, 104, '1085', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1021, 'Pampers Πάνες Premium Care Nο 3 5-9 κιλ 60τεμ', '', '', NULL, 1, 1, '1086', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1022, 'Στεργίου Μηλόπιτα Ατομική 105γρ', '', '', NULL, 5, 67, '1087', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(1023, 'Lurpak Βούτυρο Αναλ Αλουμ 125γρ', '', '', NULL, 5, 78, '1088', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1024, 'Ajax Τζαμ Crystal Clean Αντ/Κο 750ml', '', '', NULL, 3, 5, '1089', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1025, 'Φάγε Total Γιαούρτι 5% 200γρ', '', '', NULL, 5, 13, '1090', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1026, 'Φάγε Total Γιαούρτι 2% 3x200γρ', '', '', NULL, 5, 13, '1091', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1027, 'L\'Oreal Studio Line Fx Gel Extra Fix 150ml', '', '', NULL, 4, 33, '1093', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(1028, 'Rol Σκόνη Για Πλυσ Στο Χέρι 380γρ', '', '', NULL, 3, 9, '1094', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1029, 'Ajax Τζαμιών 450ml', '', '', NULL, 3, 5, '1095', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1030, 'Κανάκι Φύλλο Κρούστας Νωπό 450γρ', '', '', NULL, 5, 52, '1096', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1031, 'Amstel Μπύρα 4X500ml', '', '', NULL, 2, 3, '1097', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1032, 'Pom Pon Μαντηλ Ντεμακ Sensit 20τεμ', '', '', NULL, 4, 29, '1098', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1033, 'Δέλτα Advance Επιδορπιο Λευκό 2χ150γρ', '', '', NULL, 5, 13, '1099', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1034, 'ΣΟΥΡΩΤΗ Μεταλλικό Νερό Ανθρ Λεμον 330ml ', '', '', NULL, 2, 18, '1100', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1035, 'Gillette Gel Ξυρ Μοιsture 200ml', '', '', NULL, 4, 33, '1101', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(1036, 'Νουνού Γάλα Εβαπορέ 400γρ', '', '', NULL, 5, 10, '1102', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1037, 'Κύκνος Τοματάκι Ψιλοκ Χαρτ Συσκ 370γρ', '', '', NULL, 5, 75, '1103', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1038, 'Nestle Ρόφημα Γαλακτ Junior 2+ Rtd 1λιτ', '', '', NULL, 1, 75, '1105', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1039, 'Stella Artois Μπύρα 6x330ml', '', '', NULL, 2, 3, '1106', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1040, 'Ήρα Αλάτι Ψιλό 500γρ', '', '', NULL, 5, 76, '1107', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(1041, 'Μεβγάλ Παραδ Γιαούρτι Αιγοπρ Ελαφ 2Χ220γρ', '', '', NULL, 5, 13, '1108', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1042, 'Νουνού Κρέμα Γάλακτος Light 200ml', '', '', NULL, 5, 56, '1109', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(1043, 'Whiskas Γατ/Φή Πουλ Σε Σάλτσα 100γρ', '', '', NULL, 8, 103, '1110', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1044, 'Γιώτης Mείγμα Παγωτού Καιμάκι 508γρ', '', '', NULL, 5, 45, '1111', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1045, 'Κολοκυθάκια Εγχ Με Ανθό', '', '', NULL, 5, 99, '1112', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1046, 'Μεβγάλ Only Lact Free 1,5% 1λτ', '', '', NULL, 5, 10, '1113', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1047, 'Skip Σκόνη Regular 45πλ', '', '', NULL, 3, 9, '1115', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1');
INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(1048, 'Almiron-1 Γάλα Σε Σκόνη Πρώτης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 1, 9, '1116', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1049, 'Βίκος Φυσικό Μεταλλικό Νερό 500ml', '', '', NULL, 2, 18, '1117', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1050, 'Μάσκα Προσώπου Υφασμ 1τεμ', '', '', NULL, 7, 102, '1118', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(1051, 'Veet Αποτριχωτική Κρέμα Κανον Επιδερμ 100ml', '', '', NULL, 4, 26, '1119', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1052, 'Μεβγάλ Κρέμα Βανίλια 150γρ', '', '', NULL, 5, 47, '1121', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(1053, 'Κρι Κρι Σπιτικό Επιδόρπιο Γιαουρτιού 5% 1κιλ', '', '', NULL, 5, 13, '1122', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1054, 'Hellmann\'s Κέτσαπ 560γρ', '', '', NULL, 5, 86, '1124', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1055, 'Amita Φρουτοποτό Πορ/Μηλ/Βερ 1λιτ', '', '', NULL, 2, 21, '1125', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1056, 'Wella Koleston Βαφή Μαλ Ν7/77', '', '', NULL, 4, 23, '1126', '8e8117f7d9d64cf1a931a351eb15bd69', '09f2e090f72c4487bc44e5ba4fcea466'),
(1057, 'Kit Kat Σοκολάτα 41,5γρ', '', '', NULL, 5, 46, '1127', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1058, 'Tasty Φουντούνια 105γρ', '', '', NULL, 5, 68, '1128', 'ee0022e7b1b34eb2b834ea334cda52e7', 'f87bed0b4b8e44c3b532f2c03197aff9'),
(1059, 'Ζωγράφος Καστανή Ζάχαρη 500γρ', '', '', NULL, 5, 88, '1129', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(1060, 'Agrino Ρύζι Φανσύ Για Γεμιστά Χ Γλουτ 500γρ', '', '', NULL, 5, 66, '1130', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1061, 'Μαλαματίνα Ρετσίνα 500ml', '', '', NULL, 2, 19, '1131', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1062, 'Pedigree Σκυλ/Φή Μοσχάρι 400γρ', '', '', NULL, 8, 104, '1132', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1063, 'Dove Ντούς Deeply Nourisηing 750ml', '', '', NULL, 4, 12, '1133', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1064, 'Καλλιμάνης Χταπόδι Μικρό 595γρ', '', '', NULL, 5, 83, '1134', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1065, 'Κλεοπάτρα Σαπούνι 125γρ', '', '', NULL, 4, 36, '1135', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1066, 'L\'Oreal Excellence Βαφή Μαλ Ξανθό Ν7', '', '', NULL, 4, 23, '1136', '8e8117f7d9d64cf1a931a351eb15bd69', '09f2e090f72c4487bc44e5ba4fcea466'),
(1067, 'Πατάτες  Ελλ Κατ Β Ε/Ζ', '', '', NULL, 5, 99, '1137', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1068, 'Βιτάμ Μαργαρίνη Κλασικό 250γρ', '', '', NULL, 5, 44, '1138', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1069, 'Chipita Frau Lisa Bάση Τούρτας Κακάο 400γρ', '', '', NULL, 5, 45, '1139', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1070, 'Pom Pon Eyes & Face Μαντηλάκια 20τεμ', '', '', NULL, 4, 29, '1140', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1071, 'Τσιλιλή Τσίπουρο Χ Γλυκάνισο 700ml', '', '', NULL, 2, 20, '1141', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1072, 'Μήλα Στάρκιν Χύμα', '', '', NULL, 5, 100, '1142', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1073, 'Oral B Οδοντικό Νήμα Κηρωμένο 50τεμ', '', '', NULL, 4, 40, '1143', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1074, 'Μεβγάλ Παραδοσιακό Γιαούρτι Προβ 220γρ', '', '', NULL, 5, 13, '1144', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1075, 'Syoss Σαμπ Όγκο 750ml', '', '', NULL, 4, 12, '1145', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1076, 'Amstel Μπύρα 330ml', '', '', NULL, 2, 3, '1146', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1077, 'Babylino Sensitive No4 Econ 7-18κιλ 50τεμ', '', '', NULL, 1, 1, '1147', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1078, 'Κρι Κρι Γιαούρτι Στραγγιστό 2% 1κιλ', '', '', NULL, 5, 13, '1148', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1079, 'Χρυσά Αυγά Φρέσκα Αχυρώνα Medium 53-63γρ 6τεμ', '', '', NULL, 5, 43, '1149', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(1080, 'Fairy Υγρό Πιάτων Ultra Classic 400ml', '', '', NULL, 3, 9, '1150', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1081, 'Ariel Alpine Απορ Σκόνη 2,925γρ', '', '', NULL, 3, 9, '1151', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1082, 'Sprite 6X330ml', '', '', NULL, 2, 4, '1153', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1083, 'Pedigree Schmackos Μπισκότα Σκύλου 43γρ', '', '', NULL, 8, 104, '1154', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1084, 'Rio Mare Τόνος Λαδιού 2Χ160γρ', '', '', NULL, 5, 54, '1156', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1085, 'Danone Activia Επιδ Τραγαν Απολ Δημ 200γρ', '', '', NULL, 5, 13, '1157', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1086, 'Fix Hellas Mπύρα 330ml', '', '', NULL, 2, 3, '1158', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1087, 'Βλάχα Χυλοπιτάκι Με Αυγά 500γρ', '', '', NULL, 5, 49, '1159', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1088, 'Serkova Βότκα 37,5% 0,7λιτ', '', '', NULL, 2, 20, '1160', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1089, 'Alfa Λουκανικοπιτάκια Κουρού 800gr', '', '', NULL, 5, 85, '1161', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1090, 'Misko Τορτελίνι Με Τυρί 500γρ', '', '', NULL, 5, 49, '1162', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1091, 'Μίσκο Κριθαράκι Μέτριο 500γρ', '', '', NULL, 5, 49, '1163', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1092, 'Babylino Sensitive No3 Econ 4-9κιλ 56τεμ', '', '', NULL, 1, 1, '1164', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1093, 'Γιώτης Αλεύρι Φαρίνα Πορτοκαλί 500γρ', '', '', NULL, 5, 41, '1165', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1094, 'Παπαδημητρίου Κρεμά Βαλσαμ Χ Γλ 250ml', '', '', NULL, 5, 78, '1166', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1095, 'Φάγε Total Γιαούρτι Στραγγιστό 500γρ', '', '', NULL, 5, 13, '1167', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1096, 'Μεβγάλ Αριάνι 1,5% Χ Γλουτ 500ml', '', '', NULL, 5, 78, '1168', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1097, 'Μεβγάλ Γάλα «Κάθε Μέρα» 3.5% 1λιτ', '', '', NULL, 5, 10, '1169', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1098, 'Μεβγάλ Κεφίρ Lactose Free Με Ροδακ 500ml', '', '', NULL, 5, 10, '1170', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1099, 'Χωριό Ελαιόλαδο Κορωνεική Ποικ 1λιτ', '', '', NULL, 5, 57, '1171', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1100, 'Κορπή Νερό 6Χ1,5λιτ', '', '', NULL, 2, 18, '1172', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1101, 'Nescafe Classic Στιγμιαίος Καφές 50γρ', '', '', NULL, 5, 53, '1173', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1102, 'Μπάρμπα Στάθης Μπάμιες Extra 450γρ', '', '', NULL, 5, 84, '1174', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(1103, 'Everyday Σερβ Super/Ultra Plus Sens 18τεμ', '', '', NULL, 4, 38, '1175', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1104, 'Babycare Μωροπ/τες Αντ/κο 3Χ72τεμ', '', '', NULL, 1, 14, '1176', '8016e637b54241f8ad242ed1699bf2da', '92680b33561c4a7e94b7e7a96b5bb153'),
(1105, 'Mythos Μπύρα 330ml', '', '', NULL, 2, 3, '1177', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1106, 'Όλυμπος Φυσικός Χυμός Πορτοκάλι 1,5λιτ', '', '', NULL, 2, 21, '1178', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1107, 'Νουνού Γάλα Συμπ Μερίδες Διχ 10Χ15γρ', '', '', NULL, 5, 10, '1179', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1108, 'Δέλτα Advance Επιδ Αλεσμένα Δημητρ 2Χ150γρ', '', '', NULL, 5, 13, '1180', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1109, 'Κύκνος Χυμ Τομάτας Συμπ 500γρ', '', '', NULL, 5, 75, '1181', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1110, '7 Days Τσουρεκάκι Κλασικό 75γρ', '', '', NULL, 5, 73, '1182', 'ee0022e7b1b34eb2b834ea334cda52e7', '0e1982336d8e4bdc867f1620a2bce3be'),
(1111, 'Dove Κρεμοσ/νο Ανταλ Regul 500ml', '', '', NULL, 4, 36, '1183', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1112, 'Maggi Κύβοι Ζωμού Κότας 6λιτ 12τεμ', '', '', NULL, 5, 62, '1184', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1113, 'Όλυμπος Βούτυρο Αγελ Πακ 250γρ', '', '', NULL, 5, 44, '1185', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1114, 'Γιώτης Ανθός Αραβοσίτου Βανίλια 43γρ', '', '', NULL, 5, 45, '1186', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1115, 'Νουνού Τυρί Γκουντα Light 11% Φετ 175γρ', '', '', NULL, 5, 72, '1187', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1116, 'Κύκνος Κέτσαπ Χ Γλουτ 330γρ', '', '', NULL, 5, 78, '1188', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1117, 'Ωμέγα Special Ρύζι Basmati 1κιλ', '', '', NULL, 5, 66, '1189', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1118, 'Kerrygold Τυρί Regato Τριμ.400γρ', '', '', NULL, 5, 72, '1190', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1119, '7 Days Κρουασάν Mini Κακάο 107γρ', '', '', NULL, 5, 69, '1191', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1120, 'Persil Black Υγρό Απορ Πλυντ Ρούχ 12Μεζ 750ml', '', '', NULL, 3, 9, '1192', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1121, 'Νουνού Γάλα Σκόνη Frisomel 800γρ', '', '', NULL, 1, 9, '1193', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1122, 'Septona Σαμπουάν Και Αφρόλουτρο Βρεφικό Με Λεβαντα 500ml', '', '', NULL, 1, 9, '1194', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1123, 'Άλφα Μπύρα 500ml', '', '', NULL, 2, 3, '1195', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1124, 'Αρκάδι Σαπούνι Πλάκα Πρασ 4Χ150γρ', '', '', NULL, 4, 36, '1196', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1125, 'Proderm Υγρό Απορ/κο 17μεζ 1250ml', '', '', NULL, 1, 36, '1197', '8016e637b54241f8ad242ed1699bf2da', '991276688c8c4a91b5524b1115122ec1'),
(1126, 'Vileda Style Κουβάς', '', '', NULL, 3, 17, '1199', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1127, 'Όλυμπος Τυρί Χωριάτικο Σε Άλμη 400γρ', '', '', NULL, 5, 72, '1200', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1128, 'Καρπούζια Μίνι Εγχ', '', '', NULL, 5, 100, '1201', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1129, 'Frulite Φρουτοπoτό Πορτ/Βερικ 500ml', '', '', NULL, 2, 21, '1203', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1130, 'Άλτις Παραδοσιακό Ελαιόλαδο Παρθένο 1λιτ', '', '', NULL, 5, 57, '1204', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1131, 'Nescafe Classic Στιγμιαίος Καφές 200γρ', '', '', NULL, 5, 53, '1205', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1132, 'Παυλίδης Γκοφρέτα 3bit 31γρ', '', '', NULL, 5, 46, '1207', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1133, 'Finish All In 1 Καψ Πλυντ Πιάτ Max Regular 27τεμ', '', '', NULL, 3, 9, '1208', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1134, 'Gillette Fusion Αντ/κα Ξυραφ 4τεμ', '', '', NULL, 4, 26, '1209', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1135, 'Knorr Ζωμός Κότας 12 κυβ 120γρ', '', '', NULL, 5, 62, '1210', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1136, 'Νουνού Γάλα Εβαπορέ Light 170γρ', '', '', NULL, 5, 10, '1211', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1137, 'Κοτόπουλα Νωπά Ολόκλ Τ.65% Μιμίκος  Π.Α.Ελλην Συσκ/Να', '', '', NULL, 5, 94, '1212', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(1138, 'Derby Ίον 38γρ', '', '', NULL, 5, 46, '1213', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1139, 'Άλτις Κλασσικό Ελαιόλαδο 2λιτ', '', '', NULL, 5, 57, '1214', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1140, 'Dettol All In 1 Πράσινο Μήλο 500ml', '', '', NULL, 3, 5, '1215', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1141, 'Wella Flex Mousse Curles/Waves 200ml', '', '', NULL, 4, 30, '1216', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1142, 'Ajax Uλιτra Υγρό Γενικού Καθαρισμού Λεμόνι 1λιτ', '', '', NULL, 3, 5, '1217', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1143, 'Ballantines Ουίσκι 0,7λιτ', '', '', NULL, 2, 20, '1218', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1144, 'Klinex Σκόνη Πλυντηρίου Ρούχων Original 44μεζ', '', '', NULL, 3, 9, '1219', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1145, 'Svelto Gel Υγρό Πιάτων Με Ξύδι 500ml', '', '', NULL, 3, 9, '1220', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1146, 'Almiron-3 Γάλα Σε Σκόνη Τρίτης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 1, 9, '1221', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1147, 'Λαιμός Χοιρινός Μ/Ο Νωπός Εισ', '', '', NULL, 5, 97, '1222', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(1148, 'Soupline Συμπυκνωμένο Μαλακτικό Ρούχων Λεβάντα 28μεζ', '', '', NULL, 3, 9, '1223', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1149, 'Κρεμμύδια Ξανθά Ξερά Εισ', '', '', NULL, 5, 99, '1224', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1150, 'Nestle Nesquik Ρόφημα Σακούλα 400γρ', '', '', NULL, 5, 65, '1225', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(1151, 'Dettol Απολυμαντικό Για Ρούχα', '', '', NULL, 3, 5, '1226', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1152, 'Γιώτης Super Mousse Κακ 234γρ', '', '', NULL, 5, 45, '1227', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1153, 'Barilla Μακαρ Linguine Bavette Ν13 500γρ', '', '', NULL, 5, 49, '1228', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1154, 'Alfa Πίτσα Μαργαρίτα Κατεψυγμένη 730γρ', '', '', NULL, 5, 51, '1229', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa'),
(1155, 'Γιώτης Φρουιζελέ Φράουλα 2X100γρ', '', '', NULL, 5, 45, '1230', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1156, 'Ariel Alpine Υγρές Καψ 3σε1 24πλ', '', '', NULL, 3, 9, '1231', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1157, 'Pampers Active Baby No4+ 10-15κιλ 16τεμ', '', '', NULL, 1, 1, '1233', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1158, 'Pummaro Κέτσαπ 500γρ', '', '', NULL, 5, 86, '1234', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1159, 'Κιλότο Βόειου Α/Ο Νωπό Εισ', '', '', NULL, 5, 98, '1235', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1160, 'Ντομάτες Εγχ Υπαιθρ Β ', '', '', NULL, 5, 99, '1236', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1161, 'Hansaplast Φυσική Ελαφρόπετρα', '', '', NULL, 4, 24, '1237', '8e8117f7d9d64cf1a931a351eb15bd69', 'a610ce2a98a94ee788ee5f94b4be82c2'),
(1162, 'Ariel Υγρό Απορρυπαντικό Ρούχων Alpine 28μεζ', '', '', NULL, 3, 9, '1238', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1163, 'Babylino Πάνες Μωρού Sensitive 9-20 κιλ Nο 4+ 19τεμ', '', '', NULL, 1, 1, '1239', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1164, 'Κρις Κρις Ψωμί Τοστ Σταρένιο 700gr', '', '', NULL, 5, 74, '1240', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1165, 'Veet Κρέμα Για Ευαίσθ Επιδ 100ml', '', '', NULL, 4, 26, '1241', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1166, 'Maggi Μείγμα Λαχανικών Νοστιμιά Σε Σκόνη 130γρ', '', '', NULL, 5, 62, '1242', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1167, 'Dettol Spray Γενικού Καθαρισμού Υγιεινή Και Ασφάλεια Λεμόνι Μέντα 500ml', '', '', NULL, 3, 5, '1243', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1168, 'Pummaro Χυμός Τομάτα Πιο Συμπ/Νος 520γρ', '', '', NULL, 5, 75, '1244', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1169, 'Kellogg’s Δημητριακά Corn Flakes 375γρ', '', '', NULL, 5, 80, '1245', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1170, 'Γιώτης Κακάο 125γρ', '', '', NULL, 5, 65, '1246', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(1171, 'Μεβγάλ Παραδοσιακό Γιαούρτι Κατσικ 220γρ', '', '', NULL, 5, 13, '1247', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1172, 'Johnson\'s Baby Αφρόλουτρο Μπλε 750ml', '', '', NULL, 1, 13, '1248', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1173, 'Misko Μακαρόνια Σπαγγέτι Ν5 500γρ', '', '', NULL, 5, 49, '1249', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1174, 'Μπάρπα Στάθης Τομάτα Στον Τρίφτη 500γρ', '', '', NULL, 5, 75, '1250', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1175, 'Στεργίου Κέικ Ανάμεικτο 80γρ', '', '', NULL, 5, 50, '1251', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(1176, 'Κοτοπουλα Ολοκληρα Νωπα Τ.65% Πινδος Π.Α.Ελλην Συσκ/Να', '', '', NULL, 5, 94, '1252', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(1177, 'Ferrero Kinder Γάλακτοφέτες 5Χ140γρ', '', '', NULL, 5, 46, '1253', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1178, 'Bref Power Active Wc Block Ωκεαν 50γρ', '', '', NULL, 3, 5, '1254', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1179, 'Κανάκι Φύλλο Κρούστας 450γρ', '', '', NULL, 5, 52, '1255', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1180, 'Νουνού Γάλα Εβαπορέ Light 400γρ', '', '', NULL, 5, 10, '1256', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1181, 'Knorr Ζωμός Σπιτικός Φρεσκ Λαχανικ 4Χ28γρ', '', '', NULL, 5, 62, '1257', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1182, 'Φάγε Γιαούρτι Αγελάδος 2% Λ 3X200γρ', '', '', NULL, 5, 13, '1258', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1183, 'Μπρόκολα Πράσινα Εγχ', '', '', NULL, 5, 99, '1260', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1184, 'Καραμολέγκος Ψωμί Τοστ Σταρένιο Μίνι 340g', '', '', NULL, 5, 74, '1261', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1185, 'Κρι Κρι Γιαούρτι Στραγγιστό 10% 1κιλ', '', '', NULL, 5, 13, '1262', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1186, 'Κοκκινόψαρο  Κτψ Εισ Ε/Ζ', '', '', NULL, 5, 83, '1263', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1187, 'Λαιμός Χοιρινός Μ/Ο Νωπός Ελλ', '', '', NULL, 5, 97, '1264', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(1188, 'Καλλιμάνης Καλαμαράκι Κομ Καθαρ 595γρ', '', '', NULL, 5, 83, '1265', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1189, 'Cool Hellas Χυμός Πορτοκαλ Συμπ 1λιτ', '', '', NULL, 2, 21, '1266', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1190, 'Υφαντής Γαλοπούλα Βραστή 160γρ', '', '', NULL, 5, 42, '1267', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(1191, 'Χρυσά Αυγά Ελληνικά Βιολ 6τ Medium 348γρ', '', '', NULL, 5, 43, '1268', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(1192, 'Μπάρμπα Στάθης Αρακάς Λαδερός 1κιλ', '', '', NULL, 5, 84, '1269', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(1193, 'Όλυμπος Γάλα Ζωής Λευκό Ελαφρύ Παστ 1λιτ', '', '', NULL, 5, 10, '1270', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1194, 'Sani Lady Sensitive Super N5 10τεμ', '', '', NULL, 4, 28, '1271', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(1195, 'Dirollo Τυρί Cottage 2,2% Λιπ 225γρ', '', '', NULL, 5, 72, '1272', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1196, 'Ίον Σοκολάτα Γάλακτος 45γρ', '', '', NULL, 5, 46, '1273', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1197, 'Κοτόπουλα Νωπά Ολόκλ Τ.65% Π.Α.Ελλην Συσκ/Να', '', '', NULL, 5, 94, '1274', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(1198, 'Αύρα Φυσικό Μεταλλικό Νερό 1.5λιτ', '', '', NULL, 2, 18, '1275', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1199, 'Μεβγάλ Harmony 1% Ανανάς 3Χ200γρ', '', '', NULL, 5, 13, '1276', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1200, 'Μίνι Babybel Διχτάκι 6τεμ 120γρ', '', '', NULL, 5, 72, '1277', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1201, 'Γιώτης Αλεύρι Φαρίνα Κόκκινη 500γρ', '', '', NULL, 5, 41, '1278', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1202, 'Γιώτης Τούρτα Μιλφέιγ 532γρ', '', '', NULL, 5, 45, '1279', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1203, 'Γιώτης Κρέμα Ζαχαροπλ Μιλφέιγ 170γρ', '', '', NULL, 5, 45, '1280', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1204, 'Pummaro Χυμός Τομάτα Κλασικός 3Χ250γρ', '', '', NULL, 5, 75, '1281', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1205, '3 Άλφα Ρύζι Νυχάκι Ελληνικό 500γρ', '', '', NULL, 5, 66, '1282', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1206, 'Εβόλ Γιαούρτι Κατσικίσιο Βιολ 190γρ', '', '', NULL, 5, 13, '1283', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1207, 'Danone Activia Επιδ Γιαουρ Ακτιν 2Χ200γρ', '', '', NULL, 5, 13, '1284', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1208, 'Veet Ταινίες Κρύο Κερί 20τεμ', '', '', NULL, 4, 26, '1286', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1209, 'Botanic Therapy Σαμπουάν Επανόρθ 400ml', '', '', NULL, 4, 12, '1287', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1210, 'Μεβγάλ Στραγγιστό Γιαούρτι 2% 3Χ200γρ', '', '', NULL, 5, 13, '1288', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1211, 'Sani Υποσέντονα Fresh Maxi Plus 15τεμ', '', '', NULL, 4, 28, '1289', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(1212, 'Απαλαρίνα Λικέρ Μαστίχα 500ml', '', '', NULL, 2, 20, '1291', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1213, 'Quaker Νιφ Βρώμης Ολ Άλεσης Μεταλ 500γρ', '', '', NULL, 5, 80, '1292', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1214, 'Omo Σκόνη 425γρ', '', '', NULL, 3, 9, '1293', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1215, 'Skip Υγρό Πλ Παν/Μικρ 26πλ 910ml', '', '', NULL, 3, 9, '1294', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1216, 'Πέρκα Φιλέτο Κτψ Εισ Ε/Ζ ', '', '', NULL, 5, 83, '1296', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1217, 'Μεβγάλ Γάλα Αγελ Λευκό 3,5% Λιπ 2λιτ', '', '', NULL, 5, 10, '1297', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1218, 'Κατσίκια Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ Ε/Ζ', '', '', NULL, 5, 96, '1298', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(1219, 'Nan Optipro 1 Γάλα Σε Σκόνη Πρώτης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 1, 96, '1299', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1220, 'Ava Υγρό Πιάτων Ξύδι/Μήλο/Μέντα 430ml', '', '', NULL, 3, 5, '1300', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1221, 'Always Σερβ Night 9τεμ', '', '', NULL, 4, 38, '1301', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1222, 'Υφαντής Hot Dog Nuggets Κοτόπουλου 500γρ', '', '', NULL, 5, 91, '1302', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(1223, 'Υφαντής Ferano Προσούτο Χ Γλουτ 80γρ', '', '', NULL, 5, 78, '1303', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1224, 'Μέλισσα Σπαγγέτι Ολικής Άλεσης 500γρ', '', '', NULL, 5, 49, '1304', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1225, 'Frulite Σαγκουίνι/Μανταρίνι 1λιτ', '', '', NULL, 2, 21, '1305', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1226, 'Δέλτα Smart Επιδ Γιαουρ Φραουλ 2Χ145γρ +1δώρο', '', '', NULL, 5, 13, '1306', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1227, 'L\'Oreal Κρέμα Προσ Καν/Μικτ Επιδ 3 Φρον 50ml', '', '', NULL, 4, 29, '1307', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1228, 'Dorodo Τυρί Τριμμ Φακ 80γρ', '', '', NULL, 5, 72, '1308', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1229, 'Chicco Βρέφική Κρέμα Συγκάματος 100ml', '', '', NULL, 1, 11, '1309', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1230, 'Καραμολέγκος Παξαμάς Κρίθινος 600γρ', '', '', NULL, 5, 89, '1310', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(1231, 'Γιώτης Sanilac 1 Γάλα Σε Σκόνη Πρώτης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 1, 89, '1311', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1232, 'Dettol Αντιβ Υγρό Κρεμοσ Ευαίσθ Επιδερμ Αντ/κο 250ml', '', '', NULL, 6, 101, '1312', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(1233, 'Παπαδημητρίου Κρέμα Balsamico Με Ρόδι Με Στέβια 250ml', '', '', NULL, 5, 78, '1313', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1234, 'Στεργίου Λουκουμάς 4τεμ 340γρ', '', '', NULL, 5, 67, '1314', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(1235, 'Όλυμπος Γάλα Βιολ Υψηλ Παστ 3,7% Λ 1λιτ', '', '', NULL, 5, 10, '1315', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1236, 'Iglo Fish Sticks 300γρ', '', '', NULL, 5, 83, '1316', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1237, 'Γαύρος Νωπός Καθαρ Απεντ/νος Ελλην Μεσογ Συσ/Νος', '', '', NULL, 5, 92, '1317', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(1238, 'Υφαντής Κεφτεδάκια Κτψ 500γρ', '', '', NULL, 5, 91, '1318', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(1239, 'Γιώτης Ρυζόγαλο Στιγμής 105γρ', '', '', NULL, 5, 45, '1320', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1240, '7 Days Swiss Roll Κακάο 200γρ', '', '', NULL, 5, 50, '1321', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(1241, 'Γιώτης Κουβερτούρα Σε Σταγόνες 100γρ', '', '', NULL, 5, 46, '1323', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1242, 'Μεβγάλ Γάλα Αγελ Λευκό Light 1,5% 500ml', '', '', NULL, 5, 10, '1324', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1243, 'Χρυσά Αυγά Φρέσκα Medium 53/63 γρ.τεμ', '', '', NULL, 5, 43, '1325', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(1244, 'Misko Μακαρόνια Για Παστίτσιο Ν2 500γρ', '', '', NULL, 5, 49, '1326', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1245, 'Χρυσή Ζύμη Μπουγάτσα Θεσ/Κης Κρέμα 850γρ', '', '', NULL, 5, 85, '1327', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1246, 'Τοπ Κρέμα Βαλσάμικο Με Λεμόνι & Μέλι 200ml', '', '', NULL, 5, 61, '1328', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(1247, 'Σολομός Νωπός Φιλετ/νος Με Δέρμα Υδ Νορβ/Εισαγ  Β.Α Ατλ Συσκ/νος', '', '', NULL, 5, 93, '1330', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(1248, 'Παπαδημητρίου Balsamico Με Μέλι 250ml', '', '', NULL, 5, 61, '1331', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(1249, 'Tuborg Σόδα 330ml', '', '', NULL, 2, 4, '1332', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1250, 'Cheetos Pacotinia 114γρ', '', '', NULL, 5, 70, '1333', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(1251, 'Johnson Baby Βρεφικό Σαμπουάν Αντλιά 500ml', '', '', NULL, 1, 70, '1334', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1252, 'Τσίπουρα Υδατ  Καθαρ Ελλην G 400/600 Μεσογ Συσκ/Νη', '', '', NULL, 5, 93, '1335', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(1253, 'Πορτοκ Μερλίν - Λανε Λειτ- Ναβελ Λειτ Κατ Α Εγχ Ε/Ζ', '', '', NULL, 5, 100, '1336', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1254, 'Όλυμπος Φυσικός Χυμός Πορτοκάλι 1λιτ', '', '', NULL, 2, 21, '1337', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1255, 'Crunch Σοκολάτα Λευκή 100γρ Χωρίς Γλουτένη', '', '', NULL, 5, 46, '1338', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1256, 'Klinex Χλωρίνη Classic 2λιτ', '', '', NULL, 3, 5, '1339', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1257, 'Misko Ολικής Άλεσης Μακαρόνια Σπαγγέτι Ν6 500γρ', '', '', NULL, 5, 49, '1341', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1258, 'Καραμολέγκος Πίτες Για Σουβλ Σταρεν 10τεμ 820γρ', '', '', NULL, 5, 85, '1342', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1259, 'Wella Flex Mousse Ultra Strong 200ml', '', '', NULL, 4, 30, '1343', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1260, 'Alfa Μπουγάτσα Θες/νίκης Κρέμα 800γρ', '', '', NULL, 5, 52, '1344', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1261, 'Γιώτης Μείγμα Για Κρέπες 300γρ', '', '', NULL, 5, 45, '1345', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1262, 'Σαρδέλλες Νωπές Ελλην Μεσογ Ε/Ζ', '', '', NULL, 5, 92, '1346', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(1263, 'Alfa Φύλλο Χωριάτικο Κιχι Κτψ 750γρ', '', '', NULL, 5, 85, '1347', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1264, 'Everyday Σερβ Norm/Ultra Plus Sens 18τεμ', '', '', NULL, 4, 38, '1348', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1265, 'Γιώτης Sanilac 3 Γάλα Σκόνη 400γρ', '', '', NULL, 1, 38, '1349', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1266, 'Nestle Smarties Κουφετάκια Σοκολ 38γρ', '', '', NULL, 5, 46, '1350', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1267, 'Κιλότο Βόειου Α/Ο Νωπό Ελλ Εκτρ Άνω Των 5 Μην', '', '', NULL, 5, 98, '1352', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1268, 'Χρυσή Ζύμη Πίτσα Μαργαρίτα 2X470γρ', '', '', NULL, 5, 51, '1353', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_shop`
--

CREATE TABLE `object_shop` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT '',
  `address` varchar(255) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `active_offer` tinyint(1) DEFAULT 0,
  `latitude` decimal(10,7) DEFAULT 0.0000000,
  `longitude` decimal(10,7) DEFAULT 0.0000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_shop`
--

INSERT INTO `object_shop` (`id`, `name`, `address`, `description`, `active_offer`, `latitude`, `longitude`) VALUES
(1, 'Αρισμαρί & Μέλι', '', 'supermarket', 1, '38.0240842', '23.8055564'),
(2, 'Παλία Αγορά Τρόφιμα', '', 'convenience', 0, '38.0236250', '23.7864978'),
(3, 'Mini Market', 'Βασ. Γεωργίου Β 11', 'convenience', 1, '38.0208411', '23.7775027'),
(4, 'Σκλαβενίτης', 'Κηφισίας 7', 'supermarket', 1, '37.9875008', '23.7620167'),
(5, 'Ψιλικά', 'Πανόρμου 12', 'convenience', 1, '37.9883574', '23.7582721'),
(6, 'Κατσογιάννης', 'Λαμίας', 'supermarket', 0, '37.9889045', '23.7602338'),
(7, 'Mini Market1', 'Λαμίας 24', 'convenience', 0, '37.9890495', '23.7591570'),
(8, 'Μασούτης', 'Λαμίας', 'supermarket', 1, '37.9886895', '23.7603626'),
(9, 'Mini Market2', '', 'convenience', 1, '37.9889262', '23.7630400'),
(10, 'Mini Market3', '', 'convenience', 1, '37.9893308', '23.7621603'),
(11, 'African Asian food matket', '', 'convenience', 1, '37.9888139', '23.7633409'),
(12, 'Tindahan NG Bayan', '', 'convenience', 1, '37.9877045', '23.7580536'),
(13, 'Mini Market4', 'Πανόρμου 34', 'convenience', 1, '37.9908687', '23.7595339'),
(14, 'Ανατολίτικη Αύρα, Μπαχαρικά -Βότανα', '', 'convenience', 1, '38.0273294', '23.8429315'),
(15, 'Η Μικρή Αγορά (MiniMarket)', '', 'convenience', 1, '38.0273022', '23.8429942'),
(16, 'Bazaar', 'supermarket', '', 1, '38.0237165', '23.8037239'),
(17, 'Market In', 'Μεταμορφώσεως', 'supermarket', 1, '38.0256943', '23.8231777'),
(18, 'Mini Market5', '', 'convenience', 1, '38.0105910', '23.7950829'),
(19, 'AB city supermarket', '', 'convenience', 1, '38.0111206', '23.7944046'),
(20, 'Ισιδώρα', 'Ύδρας', 'convenience', 1, '38.0194653', '23.8429315'),
(21, 'Ok! Anytime markets', '', 'supermarket', 1, '38.0200100', '23.8035107'),
(22, 'Μασούτης 2', '', 'supermarket', 1, '38.0104033', '23.8009731'),
(23, 'Mini Market6', '25ης Μαρτίου 20-22', 'convenience', 1, '38.0197310', '23.7961284'),
(24, 'Mini Market7', 'Ψαρών', 'convenience', 1, '38.0164028', '23.7979668'),
(25, 'Small Market', '', 'Εθνικής Αντιστάσεως', 1, '38.0157496', '23.7925468'),
(26, 'Mini Market8', 'Μπιζανίου', 'convenience', 0, '38.0135562', '23.7950614'),
(27, 'Mini Market9', 'Διονύσου 18', 'convenience', 0, '38.0208465', '23.8081298'),
(29, 'Lidl', '', 'supermarket', 0, '37.0348135', '22.1010268'),
(31, 'ΣΟΥΠΕΡ ΜΑΡΚΕΤ ΠΑΝΑΓΑΚΟΣ', '', 'supermarket', 0, '36.7358339', '22.5642426'),
(35, 'The Mart', '', 'supermarket', 0, '38.2893100', '21.7806567'),
(37, 'Σουπερμάρκετ Ανδρικόπουλος', 'Αθηνών23', 'supermarket', 0, '38.2952086', '21.7908028'),
(39, 'My market', 'Κωνσταντά', 'supermarket', 0, '39.3634192', '22.9508462'),
(41, 'Γαλαξίας', '', 'supermarket', 0, '39.3616112', '22.9449484'),
(42, 'Tourist Market', '', 'convenience', 0, '36.9321435', '24.7311757'),
(43, 'Karagiannis', '', 'supermarket', 0, '36.7561554', '22.5687966'),
(47, 'Politeia Kiosk', '', 'convenience', 0, '38.0843254', '23.8303434'),
(48, 'Spar', '', 'supermarket', 0, '37.0958566', '25.3800384'),
(49, 'Dallas', '', 'convenience', 0, '37.1017381', '25.3763137'),
(50, 'Papakos', '', 'convenience', 0, '38.2355300', '21.7622778'),
(56, 'AlbhaBeta', '', 'supermarket', 0, '37.8849151', '24.7369903'),
(62, 'OK! anytime market', '', 'supermarket', 0, '37.9719261', '23.7447164'),
(63, 'ΑΒ Βασιλόπουλος', 'Σπύρου Μερκούρη38', 'supermarket', 0, '37.9717903', '23.7477478'),
(67, 'Καραγιάννης', '', 'supermarket', 0, '37.0733521', '22.4265315'),
(70, 'Μπίσσιας', '', 'supermarket', 0, '37.3258566', '23.1431562'),
(71, 'Tzimblakis Store', 'Papavasileiou', 'convenience', 0, '37.1033868', '25.3770305'),
(72, 'Κολωνάκι', '', 'supermarket', 0, '36.9333176', '25.6017900'),
(73, 'Μαρούσα', '', 'convenience', 0, '36.9321494', '25.6020450'),
(74, 'Vergonis', '', 'supermarket', 0, '39.2964151', '23.1386308'),
(75, 'SUPERMARKET', '', 'supermarket', 0, '37.5246717', '22.8632215'),
(79, 'Κρητικός', '', 'supermarket', 0, '37.9282164', '23.7515190'),
(80, 'Unep', '', 'supermarket', 0, '37.0544977', '22.4344674'),
(85, 'Naxos', '', 'convenience', 0, '37.0739988', '25.3518534'),
(86, 'Plus', '', 'convenience', 0, '37.0741032', '25.3522697'),
(87, 'Koutelieris', '', 'supermarket', 0, '37.0756654', '25.3521170'),
(91, 'ΗΠΕΙΡΩΤΙΣΑ', '', 'supermarket', 0, '37.8333895', '23.7763054'),
(94, 'Franchise Σκαλβενίτης', '', 'supermarket', 0, '37.4998645', '23.4004616'),
(95, '24 Shopen', '', 'supermarket', 0, '37.9977037', '23.7682233'),
(99, 'ΓΕΡΟΥΛΗΣ ΖΑΧ', 'ΦΡΑΓΚΟΚΛΗΣΙΑΣ26', 'convenience', 0, '38.0355609', '23.8111196'),
(101, 'Θεονασ', '', 'supermarket', 0, '37.0506023', '25.4972688'),
(104, 'Δούκας', '', 'supermarket', 0, '37.9589094', '23.7432386'),
(108, 'Maragas Super Market', '', 'supermarket', 0, '37.0609795', '25.3569608'),
(109, 'Σκλαβεντης', '', 'supermarket', 0, '37.0515427', '22.0143132'),
(110, 'Γκίνης', '', 'convenience', 0, '37.8924358', '24.0258029'),
(111, 'Μαρινόπουλος', '', 'supermarket', 0, '37.5365678', '25.1635849'),
(113, 'Καλαβρυτινός', '', 'supermarket', 0, '37.0722454', '22.4341014'),
(114, 'Σταυρούλα', '', 'convenience', 0, '37.0913409', '22.7398626'),
(116, 'Circle K', '', 'convenience', 0, '37.9586528', '23.7624442'),
(118, 'Προμηθευτική', 'Σπυριδογιάννη37', 'supermarket', 0, '37.9956746', '23.7561707'),
(125, 'ΑΒ City', '', 'supermarket', 0, '37.9916158', '23.7566865'),
(128, 'Αστέρας', 'Αγλαοφώντος10', 'supermarket', 0, '37.9951194', '23.7504319'),
(130, 'Hercules', '', 'convenience', 0, '38.0820981', '23.9730719'),
(131, 'Τσέρης', '', 'convenience', 0, '38.0781710', '23.9674473'),
(133, 'New Daily Express', '', 'convenience', 0, '38.0025233', '23.7478119'),
(138, 'OK! any time...markets', 'Σαχτούρη65', 'supermarket', 0, '37.9342883', '23.6419036'),
(140, 'Express market', 'Χατζηκυριάκου63', 'supermarket', 0, '37.9355636', '23.6357907'),
(141, 'Easy Market', '', 'convenience', 0, '38.3388846', '21.7482217'),
(142, 'Ρουμελιώτης SUPER Market', '', 'supermarket', 0, '38.2613806', '21.7436127'),
(144, 'john_mini_market', '', 'convenience', 0, '37.9729623', '23.7547460'),
(150, 'Carrefour', '', 'supermarket', 0, '38.0660196', '23.7150466'),
(155, 'AB Βασιλόπουλος', 'Γρηγορίου Κουσίδη28', 'supermarket', 0, '37.9750584', '23.7770297'),
(159, 'Aman', '', 'supermarket', 0, '37.9947732', '23.7273206'),
(160, 'Abutaliab', '', 'convenience', 0, '37.9948383', '23.7273220'),
(161, 'Motaleb', '', 'convenience', 0, '37.9938792', '23.7269730'),
(162, 'Baysha mobile & photo studio', '', 'convenience', 0, '37.9936840', '23.7271969'),
(166, 'Α. Λέλης Π. Κόκκαλης', 'Χρήστου Μωραΐτη49', 'convenience', 0, '37.9959965', '23.3448375'),
(167, 'Anagnostou Evangelia Market', '', 'supermarket', 0, '39.1442302', '23.8643071'),
(176, 'Markoulas', '', 'supermarket', 0, '38.2644973', '21.7603629'),
(178, 'Δημήτρα', '', 'convenience', 0, '38.8647800', '22.9757140'),
(179, 'Αθ. Κ. Γεροδήμου', '', 'convenience', 0, '38.8650040', '22.9752400'),
(180, 'Η Πλατεία', '', 'convenience', 0, '38.8640720', '22.9758080'),
(182, 'restaurant', '', 'supermarket', 0, '39.1545929', '23.0763404'),
(183, 'Kalodimos', '', 'supermarket', 0, '39.1675775', '22.8886249'),
(184, 'Arista', '', 'supermarket', 0, '37.0864347', '25.1527200'),
(185, 'Minimarket', '', 'supermarket', 0, '38.1856358', '24.1995495'),
(186, 'Σούπερ μάρκετ Πρεβαινάς', '', 'supermarket', 0, '38.1786007', '24.2081643'),
(190, 'Σπύρος', '', 'convenience', 0, '39.4146104', '23.1645274'),
(191, 'Νίκος', '', 'convenience', 0, '39.4146853', '23.1644753'),
(194, 'AB Vasilopoulos city', '', 'supermarket', 0, '38.0751983', '23.7399863'),
(195, 'Ελληνικη Διατροφη', '', 'supermarket', 0, '37.1070593', '25.3758976'),
(196, 'Ανδρικόπουλος', '', 'supermarket', 0, '38.2399863', '21.7363710'),
(203, 'Ok Anytime Market', '', 'supermarket', 0, '38.0459032', '23.7756934'),
(210, 'Μανιάτης', '', 'supermarket', 0, '37.4014421', '22.1363732'),
(211, 'Βαλασόπουλος', '', 'supermarket', 0, '37.4009235', '22.1341147'),
(215, 'Βασιλόπουλος', '', 'supermarket', 0, '37.9460446', '23.7734167'),
(216, 'Welcome market', '', 'supermarket', 0, '37.9685312', '23.6222851'),
(226, 'Τρόφιμα', '', 'convenience', 0, '38.0399996', '23.7529540'),
(227, 'Καπασακάλης Αλέξανδρος', '', 'convenience', 0, '38.0365935', '23.7528676'),
(228, 'Οινόη', '', 'supermarket', 0, '38.0531289', '23.0312700'),
(229, 'Αννέτα Μίνι Μάρκετ', '', 'convenience', 0, '37.4204425', '24.8800134'),
(230, 'Παντοπωλειον Ι. Γ. Μερτυρησ', '', 'supermarket', 0, '37.3852201', '23.2490504'),
(231, 'Kreimpardis Supermarket', '', 'supermarket', 0, '37.9068630', '22.8806912'),
(232, 'Savoula\'s', '', 'convenience', 0, '37.9073177', '22.8812059'),
(233, 'Karamanou', '', 'supermarket', 0, '37.9067966', '22.8796973'),
(234, 'Roustemis Supermarket', '', 'supermarket', 0, '37.9074681', '22.8813992'),
(236, 'Sennis', '', 'convenience', 0, '37.9011615', '22.8692113'),
(243, 'Olive shop', '', 'convenience', 0, '38.0273293', '22.9476073'),
(245, 'Παναγιωτόπουλοι', '', 'supermarket', 0, '37.0762099', '22.4256915'),
(246, 'Supermarket Θεοχάρη', '', 'convenience', 0, '38.9841990', '23.3703421'),
(248, '362 Grocery store', '', 'supermarket', 0, '37.9569802', '23.6999555'),
(249, 'Hellas Star Supermarket', '', 'supermarket', 0, '37.5185644', '22.8580322'),
(260, 'ΣΠΑΚ ΜΑΡΚΕΤ ΑΣΣΟΣ', '', 'supermarket', 0, '37.9430343', '22.8227650'),
(261, 'Καφενείο -Παντοπωλείο', '', 'convenience', 0, '37.5764864', '25.1961096'),
(262, 'Παντοπωλείο', '', 'convenience', 0, '37.5763396', '25.1965698'),
(263, 'Katherina\'s market', '', 'supermarket', 0, '36.8482479', '22.2632094'),
(269, 'Σοφία Γκέκη', '', 'convenience', 0, '38.1344157', '22.4931573'),
(270, 'Ψιλικατζιδικο', '', 'convenience', 0, '37.9936147', '23.8053764'),
(272, 'MyMarket', '', 'supermarket', 0, '37.3613780', '23.1623903'),
(274, 'Terra Market', '', 'supermarket', 0, '37.9657992', '23.6617454'),
(278, 'Ok!', '', 'supermarket', 0, '37.9678391', '23.7266722'),
(280, 'Carrefour Express', '', 'convenience', 0, '37.4435297', '24.9446658'),
(282, 'Παλαμάρη', '', 'supermarket', 0, '37.4475835', '24.9412691'),
(283, 'ΠΑΝΔΩΡΑ', 'Αγίου Ιωάννου24Γ', 'convenience', 0, '38.0102841', '23.8228167'),
(286, 'Mini Market Πουλής', 'Βάκχου26', 'convenience', 0, '38.0521463', '23.7597201'),
(287, 'Εμπορικό Κέντρο Φοίνικα', '', 'supermarket', 0, '37.4025592', '24.8817467'),
(288, 'Γλύκας Ευάγγελος', 'Χρυσοστόμου Σμύρνης22', 'convenience', 0, '37.4463128', '24.9352541'),
(289, 'Παλιό Σαλονίκη', '', 'convenience', 0, '37.4463840', '24.9374869'),
(290, 'Mini Market Λαλακιας', '', 'convenience', 0, '37.4450562', '24.9379144'),
(301, 'Food Market', '', 'supermarket', 0, '38.1198160', '23.7498086'),
(316, 'ΑΒ', '', 'supermarket', 0, '37.9955042', '23.7488717'),
(317, 'Kiosky\'s', '', 'convenience', 0, '37.9994212', '23.7386452'),
(320, 'Λεούσης', '', 'convenience', 0, '37.7726708', '23.4868841'),
(322, 'Σταϊκος', '', 'convenience', 0, '37.9833301', '23.7364817'),
(324, 'Παντοπωλείο Ντούβρου', '', 'convenience', 0, '38.5819986', '23.8384694'),
(325, 'Στενή', '', 'convenience', 0, '38.5715927', '23.8265707'),
(326, 'Bazaar Super Market', 'Κερκύρας88', 'supermarket', 0, '38.0008432', '23.7436673'),
(327, 'AB City', 'Φαιδριάδων4-6', 'supermarket', 0, '38.0033319', '23.7415604'),
(329, 'Tony\'s Market', '', 'supermarket', 0, '37.4462620', '24.9015025'),
(332, 'Alfa Market', '', 'supermarket', 0, '36.7439699', '24.4306564'),
(333, 'Βιδάλης', '', 'supermarket', 0, '36.7262103', '24.4466795'),
(335, 'AB Food Market', '', 'supermarket', 0, '37.6499637', '21.6263349'),
(341, 'Super K', '', 'supermarket', 0, '37.3501597', '23.4648434'),
(344, 'Aegeanmarket', '', 'convenience', 0, '36.7219170', '25.2735928'),
(345, 'Rollan', '', 'supermarket', 0, '36.7216559', '25.2818682'),
(346, 'AB', '', 'convenience', 0, '37.4440764', '25.3283166'),
(349, 'Proton', '', 'supermarket', 0, '38.2259849', '26.0008787'),
(350, 'Μανίκης Αριστείδης', '', 'supermarket', 0, '38.0400696', '23.6895715'),
(352, 'Ροσσολάτος', '', 'supermarket', 0, '37.4385576', '24.9368234'),
(358, 'Mini Market Non-Stop', '', 'convenience', 0, '38.3940019', '21.8338496'),
(360, 'Γ. ΗΛΙΟΠΟΥΛΟΣ', '', 'supermarket', 0, '37.8577500', '21.8074815'),
(362, 'Χιώτης Market', '', 'convenience', 0, '37.4440345', '24.9421838'),
(367, 'ΟΚ!', '', 'convenience', 0, '37.9752509', '23.7670102'),
(369, 'Jumbo', 'Χαλανδρίου', 'supermarket', 1, '38.0139150', '23.8176917'),
(375, 'Νέος Κόσμος', '', 'convenience', 0, '38.3926033', '21.8276238'),
(376, 'Κορίνα', '', 'supermarket', 0, '38.3917771', '21.8236100'),
(379, 'ΑΒ shop&go', 'Πεστού', 'convenience', 0, '37.9295044', '23.6376200'),
(383, '1000+1 Νύχτες', 'Επαμεινώνδα', 'convenience', 0, '37.9437408', '23.6902205'),
(392, 'Μόσχα', 'Ελευθερίου Βενιζέλου220', 'supermarket', 0, '37.9516556', '23.6938052'),
(395, 'Κιβωτός', '', 'convenience', 0, '37.9314787', '23.6339725'),
(397, 'Σκρα', '', 'supermarket', 0, '37.9515345', '23.7014334'),
(400, 'Βουλγάρικα και Ελληνικά προϊόντα', '', 'convenience', 0, '37.9797290', '23.7649679'),
(402, 'Tzamaros', '', 'supermarket', 0, '37.3884764', '24.3976218'),
(405, 'BAZAAR CASH AND CARRY', 'Βεΐκου', 'supermarket', 0, '37.9641886', '23.7224000'),
(407, 'Kiosk', 'Odos Nikiforou Lytra', 'convenience', 0, '38.0155403', '23.7669401'),
(411, 'Ντέμος', '', 'convenience', 0, '37.9327158', '23.6307238'),
(412, 'OK! anytime... markets', '', 'supermarket', 0, '37.9324762', '23.6316238'),
(414, 'Γουσέτης', 'Ειρήνης', 'convenience', 0, '37.9476897', '23.6689214'),
(418, 'express', '', 'convenience', 0, '37.3984962', '24.8787809'),
(419, 'Δημητρα Χειλαρη', '', 'supermarket', 0, '37.3873231', '23.2457425'),
(420, 'Ιωαννησ Παλυβοσ', '', 'supermarket', 0, '37.3863914', '23.2451667'),
(423, 'lola market', 'tsokaiti', 'supermarket', 0, '38.9761948', '23.0958303'),
(431, 'Papoulias Market', '', 'supermarket', 0, '36.5050602', '22.9773523'),
(432, 'Super Market', '', 'supermarket', 0, '36.5096158', '22.9792903'),
(434, 'Gegos', '', 'supermarket', 0, '37.9621450', '23.9823813'),
(436, 'Τσακανός Proton', '', 'supermarket', 0, '36.7253269', '24.4466340'),
(437, 'Τέτα Γιάννης', '', 'convenience', 0, '36.7254970', '24.4465318'),
(438, 'Super Market Tolo', '', 'supermarket', 0, '37.5269112', '22.8652116'),
(439, 'ΛΟΥΛΟΥΔΑΚΗ', '', 'supermarket', 0, '37.5212718', '22.8597269'),
(442, 'Economy Market', 'Ηρακλέους35', 'supermarket', 0, '37.9560659', '23.7119160'),
(446, 'Η Γειτονιά', '', 'convenience', 0, '37.9517695', '23.6896087'),
(447, '24hsopen', '', 'convenience', 0, '37.9535685', '23.7048503'),
(453, 'ΜΑΡΙΑ', '', 'supermarket', 0, '37.5402290', '22.8933430'),
(455, 'Πρόοδος', '', 'supermarket', 0, '38.9381480', '23.0765048'),
(456, 'My mini mall', '', 'convenience', 0, '37.9357290', '23.6353100'),
(462, 'Προϊόντα γης', 'Λεωφόρος Φλέμινγκ Αμαλίας23', 'convenience', 0, '37.9600390', '23.6728661'),
(473, 'Λάκης Mini Market', '', 'convenience', 0, '38.0641927', '22.6580004'),
(474, 'Τάκης Μπαρλάς Mini Market', '', 'convenience', 0, '38.0675278', '22.6557461'),
(475, 'Koukounaries', '', 'supermarket', 0, '39.1534611', '23.4024777'),
(476, 'Σμπούκης', '', 'convenience', 0, '38.3940372', '21.8310019'),
(480, 'ΠΛΕΒΕΗ', '', 'convenience', 0, '37.9336018', '23.6420453'),
(483, 'Αγορά του Αλχαλίλι', '', 'convenience', 0, '37.9385780', '23.6421340'),
(484, 'Anna Koumoutsou', 'Χατζηκυριάκου9', 'convenience', 0, '37.9362904', '23.6404560'),
(486, 'Σπύρος & Σπύρος', '', 'convenience', 0, '37.9294262', '23.6324101'),
(488, 'Asia Market', '', 'convenience', 0, '37.9413992', '23.6428743'),
(490, 'Ρούμελη', 'Ηβης', 'supermarket', 0, '37.9282217', '23.6395321'),
(491, 'Το εκλεκτόν', 'Μπουμπουλίνας', 'convenience', 0, '37.9405299', '23.6465189'),
(492, 'Το Καθημερινό', 'Μεγάλου Αλεξάνδρου57', 'convenience', 0, '37.9091457', '23.7405690'),
(496, 'Anytime market', 'Δελφών77', 'convenience', 0, '38.0012688', '23.6725713'),
(498, 'Bazaar Fresh Express', '', 'supermarket', 0, '37.9408799', '23.6510409'),
(499, 'Το Παντοπωλείο της Μεσογειακής Διατροφής', 'Σοφοκλέους1-3', 'convenience', 0, '37.9805353', '23.7299533'),
(505, 'Smile Kiosk', 'Χίου1', 'convenience', 0, '38.0234458', '23.7020969'),
(507, 'AB Shop & Go', 'Δημοσθένους209', 'supermarket', 0, '37.9484214', '23.6992956'),
(509, 'Autogrill', '', 'convenience', 0, '37.8623943', '22.8415014'),
(510, 'Shell Shop', '', 'convenience', 0, '37.8627785', '22.8421842'),
(511, 'Value Market', '', 'convenience', 0, '37.8628086', '22.8399932'),
(512, 'Select', '', 'convenience', 0, '37.1787750', '22.0121182'),
(517, 'Street point', '', 'convenience', 0, '37.9455532', '23.7144984'),
(518, 'Παντοπωλείον \"Ο Γάτος\"', '', 'convenience', 0, '37.9630847', '23.7221781'),
(520, 'Pocopico', 'Δημητρακοπούλου Ν.107', 'convenience', 0, '37.9621841', '23.7206440'),
(521, 'Η Ελιά', 'Δημοσθένους106', 'convenience', 0, '37.9540294', '23.7069508'),
(522, 'Ok Market', '', 'supermarket', 0, '37.9814315', '23.7371086'),
(523, 'Βιολογικά Προϊόντα', 'Μαυροκορδάτου6', 'convenience', 0, '37.9838764', '23.7319084'),
(524, 'Bamboo Vegan', 'Ζωοδόχου Πηγής36', 'convenience', 0, '37.9847155', '23.7357908'),
(525, 'OK! Super Market', '', 'supermarket', 0, '37.9881427', '23.7511883'),
(529, 'Charma', 'Λάμπρου Κατσώνη63', 'convenience', 0, '37.9489094', '23.6776622'),
(530, 'Γαίας δώρα', 'Βαλαωρίτου4', 'supermarket', 0, '37.9776814', '23.7368397'),
(532, 'το μικρο δάσος', 'Κολοκοτρώνη11', 'convenience', 0, '37.9772754', '23.7323007'),
(533, 'Supermarket Bazaar', 'Πραξιτέλους3', 'supermarket', 0, '37.9778054', '23.7308885'),
(534, 'Cibo et Vino Delicatessen', '', 'convenience', 0, '37.9765559', '23.7425154'),
(535, 'Ο δρόμος του τσαγιού', '', 'convenience', 0, '37.9767863', '23.7422177'),
(537, 'Περίπτερο', '', 'convenience', 0, '38.0963305', '23.8285629'),
(542, 'My world market', 'Ηρώων Πολυτεχνείου', 'convenience', 0, '38.0122304', '23.8201074'),
(543, 'Τα Πάντα', '', 'convenience', 0, '37.9869721', '23.7438274'),
(545, 'Economy', '', 'supermarket', 0, '37.9620121', '23.7040828'),
(546, 'Anthidis', '', 'supermarket', 0, '37.8686873', '23.7579836'),
(555, '24shopen', 'Τριών Ιεραρχών164-166', 'convenience', 0, '37.9668936', '23.7094564'),
(562, 'Promitheftiki', 'Σπερχειου', 'supermarket', 0, '38.0390566', '23.7313508'),
(567, 'Ifantis', '', 'supermarket', 0, '36.6888595', '23.0351503'),
(572, 'ok market mini-market', '', 'supermarket', 0, '37.9733412', '23.7130085'),
(573, 'Νέα αγορά', '', 'convenience', 0, '38.0057105', '23.7662069'),
(576, 'Παναγιωτόπουλος', '', 'supermarket', 0, '37.1638477', '22.8672478'),
(578, 'AB shop and go', 'Υψηλάντου13-15', 'convenience', 0, '37.9762861', '23.7438178'),
(581, 'Αμβροσία', '', 'supermarket', 0, '39.0926907', '23.7396251'),
(582, 'Αξία', 'Αριστείδου104-106', 'supermarket', 0, '37.9561218', '23.7060837'),
(583, 'Μάχη', '', 'supermarket', 0, '39.1103713', '23.6645317'),
(584, 'Skopelos', '', 'supermarket', 0, '39.1182967', '23.7306372'),
(586, 'Σπυριδούλα', '', 'supermarket', 0, '37.1179505', '25.2452002'),
(587, 'OK anytime... markets', 'Ακτή Θεμιστοκλέους10', 'supermarket', 0, '37.9332223', '23.6461447'),
(588, 'Μελανίτης Food Market', '', 'supermarket', 0, '37.0367672', '25.2525302'),
(590, 'βίος', '', 'convenience', 0, '37.9423461', '23.6498657'),
(591, 'ΗΛΕΚΤΡΟΝΙΚΟ ΤΣΙΓΑΡΟ (Vape n Smoke)', 'Χριστιανουπόλεως16', 'convenience', 0, '38.0258792', '23.7469259'),
(593, 'Bio4u', 'Εθνικής Αντιστάσεως105', 'convenience', 0, '38.0331773', '23.7360419'),
(595, 'Il kiosk', 'Φωκά Ιωάννου125', 'convenience', 0, '38.0208162', '23.7518251'),
(596, 'mikri vigla supermarket', '', 'convenience', 0, '37.0254703', '25.3756930'),
(605, 'Απόλλων', '', 'convenience', 0, '37.9537005', '23.6672619'),
(606, 'Το Μαγαζί', 'Ελευθερίου Βενιζέλου58', 'convenience', 0, '37.9619927', '23.7104792'),
(607, 'Πουμελιώτης', '', 'supermarket', 0, '37.4812535', '21.6507033'),
(608, 'Το μπακάλικο της γειτονιάς', '', 'convenience', 0, '37.9329315', '23.6450301'),
(611, 'Μουργή', '', 'supermarket', 0, '37.0258224', '22.1130577'),
(614, 'Gr-eatings', 'Νίκης30', 'supermarket', 0, '37.9738834', '23.7328924'),
(617, 'ΠΑΠ', '', 'supermarket', 0, '37.7142185', '24.0545396'),
(618, 'Twenty4', '', 'supermarket', 0, '37.9640616', '23.7576419'),
(624, 'Haradiatrofis.gr', '', 'convenience', 0, '37.9867573', '23.7656565'),
(629, 'Zam', '', 'convenience', 0, '37.9810050', '23.7603726'),
(631, 'Σωτήρης', 'Αντιφίλου8', 'convenience', 0, '37.9762220', '23.7559783'),
(634, 'Λαλαούνης', 'Θεοδάμαντος33', 'convenience', 0, '37.9765576', '23.7622940'),
(637, 'Cosmos', 'Πατησίων232', 'convenience', 0, '38.0076964', '23.7352364'),
(640, 'Ερωφίλη', '', 'convenience', 0, '37.9654754', '23.7261327'),
(643, 'Συν Άλλοις', 'Νηλέως35', 'convenience', 0, '37.9750161', '23.7165700'),
(645, 'Χριστοφορίδης', '', 'convenience', 0, '39.3611891', '22.9503915'),
(647, 'Panorios', 'Gigas Panorios Central Cross Way', 'supermarket', 0, '37.0853358', '25.1543406'),
(648, 'BIDALIS', 'Livadia', 'supermarket', 0, '37.0865477', '25.1527985'),
(649, 'BALTIKA MARKET', '', 'supermarket', 0, '38.0115466', '23.7353717'),
(650, 'Ρέθεμνος', 'Κλεισθένους4', 'convenience', 0, '38.0109802', '23.8439219'),
(652, 'Σοφρώνης SM', '', 'supermarket', 0, '37.8060994', '23.8710987'),
(653, 'Πηγαιν\' Ελα', '', 'convenience', 0, '37.5671976', '22.8014446'),
(654, 'Επιλέγω φρέσκα & οικονομικά', '', 'supermarket', 0, '38.0193526', '23.7398595'),
(657, 'Vrisi Market', 'Νέα Περιφερειακή Οδός / New Ring Road', 'supermarket', 0, '37.4355124', '25.3321394'),
(658, 'Ανδριακόν', '', 'supermarket', 0, '37.8832115', '24.7356984'),
(665, '\"Ταξιάρχης\"', '', 'convenience', 0, '38.6193030', '23.7365580'),
(667, 'Carna', 'Εθνική Οδός 8α', 'convenience', 0, '38.2795377', '21.7667136'),
(672, 'G. Zafeiris', '', 'supermarket', 0, '36.9706743', '22.9933018'),
(673, 'Εμπορικόν', '', 'convenience', 0, '38.7360549', '22.3461921'),
(680, 'Μάκης', 'Γέρακα2', 'convenience', 0, '38.0126336', '23.8600082'),
(681, 'Το Σημείο', '', 'convenience', 0, '37.9831977', '23.7647138'),
(682, 'Τουριστικό Περίπτερο', '', 'convenience', 0, '38.0261812', '22.9479438'),
(683, 'Η Γειτονιά Μας', '', 'supermarket', 0, '37.9708222', '22.9823844'),
(686, 'Κουτσούκος', '', 'supermarket', 0, '37.7440263', '23.0066968'),
(687, 'Το περίπτερο', 'Θεσσαλονίκης', 'convenience', 0, '37.9678296', '23.7088602'),
(688, 'Zaniakos', '', 'convenience', 0, '38.7650908', '23.3166801'),
(691, 'Άστρο', '', 'supermarket', 0, '37.9445340', '23.6509079'),
(693, 'Ταλιούρης Ηρακλής', '', 'convenience', 0, '37.9843613', '23.7627208'),
(694, 'Kleopatra', '', 'supermarket', 0, '37.9815557', '23.7269617'),
(699, 'Παντοπωλείο Τζίμης', '', 'convenience', 0, '37.9665408', '23.7510190'),
(700, 'Το παραδοσιακό', '', 'convenience', 0, '37.9928749', '23.7575985'),
(703, 'Ο κουβαλητής', 'Βαθέως19', 'convenience', 0, '37.9890058', '23.7576684'),
(707, 'Τα Γλεούδια', 'Λάχητος2', 'convenience', 0, '37.9829067', '23.7527764'),
(708, 'Το ΜαγαζΑκη της Γειτονιάς', '', 'convenience', 0, '37.9726871', '23.7708834'),
(711, 'ΓΑΙΑ ΤΡΟΦΙΜΑ Α.Β.&Ε.Ε.', '', 'supermarket', 0, '37.9869726', '23.7520508'),
(712, 'Kampos', 'Φιλελλήνων2', 'supermarket', 0, '37.9747617', '23.7339280'),
(715, 'Σκουρτή', '', 'convenience', 0, '37.9355093', '23.6332130'),
(716, 'Το πέρασμα', '', 'convenience', 0, '37.8920596', '23.7491943'),
(717, 'Shan Market', '', 'supermarket', 0, '38.0063531', '23.7351858'),
(718, 'Adil', '', 'convenience', 0, '37.9999233', '23.7331273'),
(719, 'Angel\'s', 'Περικλέους84', 'convenience', 0, '38.0350677', '23.6779624'),
(723, 'Adel', '', 'convenience', 0, '37.9937366', '23.7272058'),
(724, 'Μάρκετ τροφίμων', 'Αντιγόνης12', 'convenience', 0, '38.0348243', '23.7530861'),
(726, 'Κυριάκος', '', 'convenience', 0, '38.0319673', '23.7861926'),
(729, 'Σβούρα', '', 'convenience', 0, '37.9875355', '23.7346853'),
(730, 'Addis Market', 'Χέυδεν31', 'convenience', 0, '37.9933829', '23.7276885'),
(731, 'Ειρήνη', 'Αριστοτέλους56', 'convenience', 0, '37.9907446', '23.7285311'),
(732, 'Momo', '', 'convenience', 0, '38.0043424', '23.7344625'),
(736, 'Μουστόπουλος', '', 'supermarket', 0, '38.0948148', '23.7316844'),
(738, 'Βιοφύση', '', 'supermarket', 0, '38.0121928', '23.7354032'),
(739, 'Comilla Store', '', 'convenience', 0, '38.0055662', '23.7350214'),
(744, 'Primo', '', 'supermarket', 0, '37.0809908', '25.1502139'),
(746, 'OK! Mini market', '', 'supermarket', 0, '38.0011394', '23.7926344'),
(747, 'Ελευθεριάδης', '', 'supermarket', 0, '37.9942241', '23.7961450'),
(750, 'Statha store', '', 'supermarket', 0, '39.3570406', '22.9550638'),
(752, 'Marinos Market', '', 'supermarket', 0, '37.1441266', '24.5144754'),
(753, 'Condilis Market', '', 'supermarket', 0, '37.1423109', '24.5145712'),
(755, 'Market In (daily\'s)', 'Διονυσίου Αιγινήτου16', 'supermarket', 0, '37.9781137', '23.7547735'),
(756, 'Shell', '', 'convenience', 0, '38.1402540', '23.9659341'),
(757, 'Κακάκης', '', 'convenience', 0, '36.9436243', '24.7521750'),
(759, 'υπεραγορα', '', 'supermarket', 0, '38.1092113', '21.7809461'),
(760, 'ΣΥΝ.ΚΑ.', '', 'supermarket', 0, '37.5391105', '25.1601706'),
(762, 'Γαλα ξλιας', '', 'supermarket', 0, '38.1560264', '22.3437069'),
(764, 'Supermarkt', '', 'supermarket', 0, '37.0454029', '22.1141739'),
(770, 'Coop', '', 'supermarket', 0, '37.4085009', '22.7282105'),
(773, 'Μίνι Μάρκετ', '', 'convenience', 0, '37.6953376', '24.0566491'),
(774, 'Proset', '', 'supermarket', 0, '38.2914320', '22.0121837'),
(776, 'OK', 'Φρύνης6', 'supermarket', 0, '37.9671848', '23.7473976'),
(778, 'Kronos', '', 'supermarket', 0, '38.2425794', '21.7296435'),
(781, 'Ayan', '', 'convenience', 0, '37.9965794', '23.7322459'),
(782, 'diellas', '', 'supermarket', 0, '37.4264482', '25.3335256'),
(783, 'MEGA', 'Φυλής', 'convenience', 0, '38.0736862', '23.7070896'),
(786, 'Φίλιππας', '', 'convenience', 0, '38.2585639', '21.7504681'),
(787, 'ΓΕΩΡΓΙΟΣ Ε ΠΕΤΡΑΚΗΣ', '', 'convenience', 0, '38.8939854', '22.5841342'),
(789, 'Άριστα', '', 'convenience', 0, '37.8586192', '24.7857213'),
(798, 'Two Four Seven', 'Πιπίνου1', 'convenience', 0, '37.9963163', '23.7348888'),
(799, 'kiosque 24', '25ης Μαρτίου84', 'convenience', 0, '38.0416385', '23.6852294'),
(800, 'No supermarket', '', 'supermarket', 0, '38.2498065', '21.7363349'),
(807, 'Α.Α.', 'Παναγή Τσαλδάρη (Πειραιώς)19', 'supermarket', 0, '37.9828054', '23.7254433'),
(811, 'ΣΠΑΚ', '', 'supermarket', 0, '37.9390902', '22.9248283'),
(813, 'Market MAMMAS', '', 'convenience', 0, '39.1409654', '23.2736941'),
(814, 'Καφετζόπουλος', '', 'convenience', 0, '39.1410048', '23.2733912'),
(816, '(Delta)IKTYO', '', 'supermarket', 0, '36.9960828', '25.1368700'),
(817, 'Δημ. Κ. Παρούση', '', 'supermarket', 0, '36.9983957', '25.1364191'),
(819, 'NEFELI Minimarket', '', 'convenience', 0, '36.8498605', '22.6667592'),
(823, 'Supermarket Μχ. Αναχνωστου', '', 'convenience', 0, '39.1445809', '23.8629386'),
(825, 'ΝΤΟΥΡΜΑ ΜΑΡΙΑ', 'Ιστιαίας25', 'convenience', 0, '38.4701626', '23.6028735'),
(826, 'Four coins', '', 'convenience', 0, '37.3471831', '23.4633269'),
(827, 'Σούπερ μάρκετ \" Γαλαξίας\"', 'Μαντούδι - Ιστιαίας', 'supermarket', 0, '38.8052335', '23.4556278'),
(831, 'Γεωργία', 'Κολοκοτρώνη', 'convenience', 0, '38.0321605', '23.7476444'),
(835, 'Ανδρικόπουλος - Supermarket', 'Αξιού1 - 3', 'supermarket', 0, '38.2691937', '21.7481501'),
(838, 'Ψιλικά 24ωρο', 'Ηλία Ηλιού83', 'convenience', 0, '37.9565672', '23.7269874'),
(842, 'Supermarket \"Sklias\"', '', 'supermarket', 0, '37.7649460', '23.1306953'),
(846, 'Σίφνος Market', '', 'convenience', 0, '36.9786060', '24.7248106'),
(847, 'Ορεινό Παντοπωλείο', '', 'convenience', 0, '38.6990879', '22.1763293'),
(848, 'ΑΒ Food Market', 'Χαλεπά', 'supermarket', 0, '38.0208049', '23.7459325'),
(853, 'Το Μιτάτο του Μασαούτη', 'Λεωφόρος Βάρης18', 'supermarket', 0, '37.8336809', '23.8001494'),
(854, 'Μαύρο Πιπέρι', 'Τριών Ιεραρχών135', 'convenience', 0, '37.9686315', '23.7106101'),
(855, 'Ασημάκη', '', 'convenience', 0, '38.5925257', '22.0544044'),
(860, 'Καλμαντης', '', 'convenience', 0, '38.4795734', '22.5839601'),
(862, 'Το μικρό καλάθι', '', 'convenience', 0, '38.0329328', '23.6751108'),
(863, 'My Market easy', '', 'supermarket', 0, '37.9617310', '23.7542672'),
(864, 'Κατσαούνης', '', 'convenience', 0, '37.9331392', '22.3405596'),
(865, 'Δραχμούλα', 'Λυκούργου110', 'convenience', 0, '37.9577550', '23.6980317'),
(866, 'Mini STOP Kiosk', 'Γρηγορίου Αυξεντίου53', 'convenience', 0, '37.9756154', '23.7636651'),
(867, 'Sofia\'s', '', 'convenience', 0, '37.1003626', '25.4793633'),
(868, 'Η αγορά του Ζαχαρία', '', 'supermarket', 0, '37.9472502', '23.6873015'),
(872, 'Καλογιάννης', '', 'supermarket', 0, '38.5776586', '23.6462307'),
(882, 'Londo Market', 'Αριστοφάνους21', 'convenience', 0, '37.9799011', '23.7242359'),
(887, 'Ok! any time... markets', '', 'supermarket', 0, '37.9428907', '23.6539703'),
(889, 'Το μαγαζί της γειτονιάς μας', '', 'convenience', 0, '37.9374789', '23.6530986'),
(893, 'Βύρων', '', 'convenience', 0, '37.9776461', '23.6522702'),
(895, 'Ρούσσος', '', 'convenience', 0, '38.7641679', '23.3204646'),
(901, 'Ο Μπακαλόγατος', 'Μηδείας41', 'convenience', 0, '37.9369362', '23.7111409'),
(904, 'The Mini Market', 'Γαλερίου5', 'convenience', 0, '38.0252275', '23.6955132'),
(906, 'Kritikos', '', 'supermarket', 0, '37.4976104', '23.4586698'),
(907, 'Amar Dream', 'Παναγή Τσαλδάρη (Πειραιώς)37', 'convenience', 0, '37.9815204', '23.7227044'),
(908, 'Milena', 'Στεφάνου Βυζαντιου7', 'convenience', 0, '38.0152651', '23.7345445'),
(910, 'Παππά Χαρ.', '', 'convenience', 0, '38.9446927', '21.9604240'),
(914, 'ΡΙΤΑ', '', 'supermarket', 0, '38.4258943', '23.6700739'),
(915, 'Ya ta panda', 'Παγασών70Α', 'convenience', 0, '39.3679040', '22.9379548'),
(919, 'Ελληνικά market', '', 'supermarket', 0, '39.3728103', '22.9260797'),
(920, 'Μπενεθ', '', 'supermarket', 0, '36.9305837', '25.5999242'),
(922, 'arista super market', '', 'supermarket', 0, '37.4644366', '25.3282363'),
(924, 'Βιολογικό Χωριό', 'Γρηγορίου Λαμπράκη23', 'supermarket', 0, '37.8693209', '23.7580955'),
(925, 'Αρισταίος', 'Μυλοπόταμος', 'convenience', 0, '37.6425446', '24.3212227'),
(928, 'Tami', '', 'convenience', 0, '37.9836738', '23.7248876'),
(939, 'Papoulakos', '', 'supermarket', 0, '38.8986336', '24.5663215'),
(940, 'Toubas', '', 'supermarket', 0, '38.9128895', '24.5691298'),
(941, 'Μανάβικο', '', 'supermarket', 0, '38.0144238', '23.8318803'),
(945, 'Κανάκης', '', 'convenience', 0, '37.7725110', '23.4890576'),
(946, 'Kastraki Market', '', 'convenience', 0, '37.0040280', '25.3862884'),
(951, 'ΔΕΡΒΕΝΟΧΩΡΙΑ', '', 'supermarket', 0, '38.2144189', '23.4962914'),
(954, 'OK! markets', '', 'supermarket', 0, '37.9880209', '23.7353748'),
(961, 'Πέρα δώθε', '', 'convenience', 0, '37.5661520', '22.7983237'),
(964, 'ΑΙΑΚΟΣ 7-11', '', 'convenience', 0, '37.7472550', '23.4286008'),
(965, 'Κάπαρη', 'Ασκληπιού22', 'convenience', 0, '37.9827298', '23.7368560'),
(966, 'Μπακαλόγατος και μπακαλογατί', '', 'supermarket', 0, '39.3880841', '23.1727916'),
(967, 'Νικολάου', '', 'supermarket', 0, '39.3880234', '23.1726920'),
(968, 'Ο Ρήγας', '', 'supermarket', 0, '39.3881023', '23.1724387'),
(972, 'Armonia Grocery Shop', '', 'supermarket', 0, '37.4415563', '25.3348101'),
(975, 'Ornos Super Market', '', 'convenience', 0, '37.4244911', '25.3230926'),
(977, 'Βαλκανιώτης', '', 'supermarket', 0, '38.9380946', '23.0743660'),
(979, 'Σουριλα', '', 'supermarket', 0, '39.0058680', '23.2088045'),
(981, 'Ωρεοί', '', 'supermarket', 0, '38.9506072', '23.0884726'),
(983, 'Super mini market', '', 'convenience', 0, '37.9444549', '23.6575734'),
(985, 'Η Ελένη', '', 'convenience', 0, '37.9575676', '23.6722781'),
(986, 'Coffee & Mini Market', '', 'convenience', 0, '38.1855192', '22.1981969'),
(987, 'Pandrosou 10 shopping center', '', 'supermarket', 0, '37.9754076', '23.7285288'),
(989, 'Σπύρου Τρικούπη', 'Σπύρου Τρικούπη52', 'convenience', 0, '37.9902039', '23.7355198'),
(993, 'Κρητικός Σούπερ μάρκετ', 'Αριστοναυτών', 'supermarket', 0, '38.0800478', '22.6247110'),
(997, 'Gastrogonia.gr', '', 'convenience', 0, '38.0327105', '23.7609314'),
(999, 'Mariyam Mini Market', '', 'convenience', 0, '37.9923120', '23.7234067'),
(1000, 'Δημήτρης', 'Μοναστηρίου', 'convenience', 0, '37.9900859', '23.7102063'),
(1002, 'Συμεωνίδης', 'Σωτήρη Πέτρουλα31', 'supermarket', 0, '38.0801888', '23.7024407'),
(1007, 'Nikolas', '', 'convenience', 0, '37.9961121', '23.7402394'),
(1009, 'Το νέο περίπτερο', 'Ειρήνης8', 'convenience', 0, '38.0602468', '23.7967352'),
(1012, 'Αραφάτ', '', 'convenience', 0, '38.0072011', '23.7352462'),
(1013, 'Sukria', '', 'convenience', 0, '38.0126846', '23.7351036'),
(1014, 'Kiosky´s', '', 'convenience', 0, '37.9596138', '23.7532366'),
(1015, 'Lacandona', 'Ηπίτου4', 'convenience', 0, '37.9743437', '23.7316278'),
(1020, 'Katerina\'s Market', '', 'supermarket', 0, '36.8237026', '22.2828278'),
(1021, 'Athens super mini market', '28ης Οκτωβρίου43', 'convenience', 0, '37.9879216', '23.7301638'),
(1025, 'Δεδες', '', 'convenience', 0, '37.7450121', '23.4299285'),
(1027, 'imarket', 'Λευκωσίας', 'supermarket', 0, '37.9005296', '23.7711807'),
(1029, 'Ασημάκης', 'Ευριπίδου42', 'supermarket', 0, '37.9817933', '23.6363500'),
(1032, 'ΤΣΟΛΑΟΕΣ', '', 'supermarket', 0, '37.9846505', '23.6606428'),
(1033, 'Κάντια', '', 'convenience', 0, '37.5191872', '22.9665754'),
(1036, 'ok any time... markets', 'Αγίας Τριάδος4', 'supermarket', 0, '38.0143502', '23.8317584'),
(1038, 'Όλη μέρα κάθε μέρα', '', 'convenience', 0, '38.0331703', '23.7666396'),
(1039, 'zikoshop.gr', 'Τραπεζούντως21A', 'convenience', 0, '38.0366099', '23.7555867'),
(1040, 'Μικρή Αγορά', 'Δημοσθένους39', 'convenience', 0, '38.0293273', '23.7508207'),
(1041, 'Zain - Mini Market', '', 'convenience', 0, '38.0403252', '23.7557169'),
(1043, 'Το Μικιό', 'Γρέγου19', 'convenience', 0, '37.8890218', '24.0064786'),
(1047, 'Nour Alhouda', '', 'convenience', 0, '38.0096072', '23.7349771'),
(1048, 'Anah', 'Ευγενίου Καραβία25', 'convenience', 0, '38.0127383', '23.7326846'),
(1049, 'Ρους', 'Ταϋγέτου', 'convenience', 0, '38.0144069', '23.7389725'),
(1050, 'Kabbar', 'Τοσίτσα7', 'convenience', 0, '37.9881845', '23.7343589'),
(1052, 'Alahar dan', '', 'convenience', 0, '38.0157855', '23.7345712'),
(1054, 'Cretan Herbs', 'Μητροπόλεως38', 'convenience', 0, '38.0543056', '23.8096337'),
(1055, 'Γαλακτοπωλείο Γαϊτανίδη', 'Μητροπόλεως', 'convenience', 0, '38.0546994', '23.8086478'),
(1056, 'Sharif', '', 'convenience', 0, '37.9864685', '23.7269256'),
(1057, 'City Life', 'Ακαδημίας60', 'convenience', 0, '37.9823349', '23.7338739'),
(1064, 'Varna', '', 'convenience', 0, '37.9889498', '23.7250762'),
(1065, 'Θέμης', '', 'supermarket', 0, '38.0844768', '23.7068659'),
(1066, 'Το Ψιλικάκι', '', 'convenience', 0, '38.0846532', '23.7069797'),
(1067, '24 All', '', 'convenience', 0, '38.0852157', '23.7114423'),
(1068, 'Tsar Market', 'Σιβιτανίδου', 'convenience', 0, '37.9600658', '23.6975416'),
(1070, 'Το ελληνικό', '', 'convenience', 0, '37.9295244', '23.6392656'),
(1071, 'Προϊόντα Νάξου', '', 'convenience', 0, '37.9776102', '23.7247475'),
(1073, 'Δήμητρα Χατζηκαπλάνη', '', 'convenience', 0, '38.0892719', '23.7078061'),
(1076, 'Ηλιάδου Σοφία', '', 'convenience', 0, '38.0914571', '23.7069672'),
(1078, 'Baltika', '', 'supermarket', 0, '38.0030482', '23.7279740'),
(1081, 'Ο Κώστας', 'Σοφοκλέους', 'convenience', 0, '37.9523837', '23.7022427'),
(1091, 'Asian Mini Market', 'Χαριλάου Τρικούπη72', 'convenience', 0, '37.9851092', '23.7377498'),
(1094, 'ΑΖΑΝ', '3ης Σεπτεμβρίου70', 'convenience', 0, '37.9907476', '23.7298457'),
(1095, 'Ανατολή', 'Ιωάννου Δροσοπούλου147', 'convenience', 0, '38.0072811', '23.7359118'),
(1096, 'achinos', '', 'supermarket', 0, '39.1634502', '23.4880601'),
(1097, 'All In Market', '', 'convenience', 0, '39.1632264', '23.4896891'),
(1100, 'Σούπερ Μάρκετ Νάργος', '', 'supermarket', 0, '37.7098291', '23.3646170'),
(1101, 'Κάβα Α. Αντωνίου', '', 'convenience', 0, '37.7098577', '23.3645499'),
(1102, 'Παντοπωλείο Αντωνίου', '', 'supermarket', 0, '37.7085657', '23.3625029'),
(1104, 'Γιακοβάκη', '', 'supermarket', 0, '37.9798340', '23.7278374'),
(1105, 'Η φάρμα του Σάμπλου', '', 'supermarket', 0, '36.7935020', '24.5741657'),
(1106, 'Alex market', 'Παπαρηγοπούλου', 'supermarket', 0, '38.0200411', '23.8352385'),
(1111, 'Welcome Stores', 'Ιωάννου Δροσοπούλου142', 'convenience', 0, '38.0075585', '23.7361337'),
(1112, '\"Δαγρέ\"', 'Τρίπολης - Καλαμάτας', 'supermarket', 0, '37.4995234', '22.3606581'),
(1113, 'Αρτοποιϊα Αλεξόπουλου', 'Καλαμάτας', 'supermarket', 0, '37.5035852', '22.3647032'),
(1116, 'Βιολόγος', '', 'supermarket', 0, '38.0412593', '23.7518862'),
(1117, 'Το ποντιακό', '', 'convenience', 0, '38.0412331', '23.7517904'),
(1118, 'Πατση', '', 'convenience', 0, '38.0410563', '23.7520551'),
(1119, 'Λεονίδας', '', 'convenience', 0, '38.0430978', '23.7552706'),
(1120, 'Rehman', '15', 'convenience', 0, '38.0429061', '23.7557596'),
(1122, 'Supermarkt Kphtike', '', 'supermarket', 0, '37.3985494', '24.8787618'),
(1124, 'Vamvounis - Vamvakaris', '', 'supermarket', 0, '36.7261406', '24.4513033'),
(1125, 'ΠΑΝΤΟΠΩΛΕΙΟ ΑΝΔΡΙΚΟΥ', '', 'supermarket', 0, '37.9551273', '23.8562029'),
(1132, 'ΚΟΥΡΤΑΚΗΣ - ΟΙΚΟΝΟΜΑΚΟΣ & ΥΙΟΙ Ο.Ε.', 'Irakleous6', 'supermarket', 0, '36.7600012', '22.5652586'),
(1137, 'Super Market Κρητικός', '', 'supermarket', 0, '37.9207485', '23.7373778'),
(1139, 'Kiosky’s', '', 'convenience', 0, '37.9247482', '23.7394138'),
(1144, 'Σουπερμάρκετ \"Express\"', 'Παράπλευρη Οδός Α.Θ.Ε.', 'supermarket', 0, '38.8829765', '22.7754711'),
(1148, 'Fast Market', 'Αγίων Αναργύρων', 'convenience', 0, '38.0513995', '23.8005934'),
(1150, 'Καλημέρα', 'Δεμιρδεσίου10', 'convenience', 0, '38.0290545', '23.7526072'),
(1151, 'Επίκεντρο', 'Καλλισθένους2', 'convenience', 0, '38.0313997', '23.7572342'),
(1153, 'Market τροφίμων', '', 'supermarket', 0, '38.0338853', '23.7574940'),
(1156, 'Θεοδοσία', 'Χρυσοστόμου Σμύρνης30', 'convenience', 0, '37.9644279', '23.7015914'),
(1157, 'Ελομάς', 'Κλειούς16', 'supermarket', 0, '37.9645496', '23.7041768'),
(1159, 'Convenience Store', '', 'convenience', 0, '37.9678318', '23.7261095'),
(1160, 'freshop', '', 'convenience', 0, '37.9917550', '23.6844328'),
(1166, 'Τσαμπανάκη', 'Πρωτεσιλάου', 'supermarket', 0, '38.0312497', '23.7045200'),
(1167, 'Ziba', 'Μενάνδρου34', 'convenience', 0, '37.9832933', '23.7252777'),
(1169, 'Το παραδοσιακόν', '', 'convenience', 0, '37.9460000', '23.7137499'),
(1182, 'Ο Γιάννης', '', 'convenience', 0, '38.0401361', '23.7587869'),
(1187, 'Chen Xueyan', '', 'supermarket', 0, '37.9829102', '23.7217654'),
(1193, 'ΤΑΜΠΑΚΗΣ', '', 'supermarket', 0, '38.3320361', '21.7626966'),
(1195, 'Γευση...γώνιον', 'Αγίων Αναργύρων32Α', 'convenience', 0, '38.0517147', '23.8007668'),
(1198, 'Total Clean', 'Πατησίων350-352', 'convenience', 0, '38.0199381', '23.7357450'),
(1199, 'Ελλάς', '', 'supermarket', 0, '37.4079694', '23.4160728'),
(1206, 'Mini Market - Ο Θωμάς', '', 'convenience', 0, '37.9725627', '23.7661210'),
(1207, 'Παπαευθυμίου Κωνσταντίνος Γ', '', 'convenience', 0, '38.8944339', '22.5847401'),
(1209, 'Μίνι Μάρκετ Γιακουμής', '', 'convenience', 0, '37.9662358', '23.5828762'),
(1210, 'BioArt', 'Τατοϊου122', 'supermarket', 0, '38.0952279', '23.8098478'),
(1211, 'σακης', '', 'convenience', 0, '38.0365526', '23.8272851'),
(1212, 'Zahir & Sons', '', 'convenience', 0, '38.0028518', '23.7334342'),
(1213, 'Παντοπωλείο κάτι ξέχασες', '', 'convenience', 0, '37.6424085', '22.7329373'),
(1214, 'Πόντος Μάρκετ', '', 'supermarket', 0, '37.9485600', '23.7010758'),
(1215, 'ΒιοΑναγέννηση', '', 'convenience', 0, '37.9828816', '23.7299820'),
(1216, 'Φωτόπουλος', '', 'supermarket', 0, '37.5234117', '22.7298404'),
(1217, 'Ovenly - Φούρνος, καφέ, μίνι μάρκετ', '', 'convenience', 0, '38.3568827', '21.7754995'),
(1219, 'Δέδε Παναγιώτα', '', 'convenience', 0, '37.6322059', '22.7339777'),
(1221, 'ΕΥΒΟΙΑ ΜΑΡΚΕΤ', '', 'convenience', 0, '38.7554860', '23.5819098'),
(1222, '3A', '', 'supermarket', 0, '38.2504514', '21.7396687'),
(1226, '362 Grocery', 'Μιχαλακοπούλου', 'convenience', 0, '37.9870916', '23.7662805'),
(1229, 'Η Κρήτη', 'Πανδώρου', 'convenience', 0, '37.9692453', '23.7052365'),
(1230, 'Συν+πραξις Μεσογαίας', '', 'convenience', 0, '37.8874307', '24.0037781'),
(1232, 'Stop & Shop', '', 'convenience', 0, '38.0341902', '23.9831459'),
(1237, 'Corner', 'Αμφιδάμαντος34', 'convenience', 0, '38.4723056', '23.5891193'),
(1240, 'Παύλος', 'Ερατοσθένους', 'convenience', 0, '37.9703112', '23.7418571'),
(1242, 'Η Σεπινιτσα', '', 'supermarket', 0, '36.8244734', '22.2809422'),
(1244, 'Αγορα Express', '', 'supermarket', 0, '37.8368767', '24.9364905'),
(1246, 'Campos Market', '', 'supermarket', 0, '36.9792749', '25.3955068'),
(1256, 'Μανταφάρα', '', 'convenience', 0, '38.8884221', '22.4337151'),
(1257, 'Μαχαιράς Χρήστος', '', 'convenience', 0, '38.8918203', '22.4384921'),
(1258, 'Κρανας', '', 'convenience', 0, '38.8889005', '22.4386128'),
(1260, 'Market', '', 'convenience', 0, '36.7232280', '25.2824298'),
(1261, '362grocery', 'Πλατεία Αμβροσίου Πλυτά3', 'supermarket', 0, '37.9591865', '23.7405277'),
(1262, 'Το ψιλικατζίδικο της γειτονιάς', 'Αιγαίου42', 'convenience', 0, '37.9510082', '23.7183720'),
(1263, 'Του Μουράτ', '', 'convenience', 0, '38.0062814', '23.7210924'),
(1264, 'Γυαλισκάρι', 'Ιακωβάτων53', 'convenience', 0, '38.0145722', '23.7305736'),
(1266, 'Lycachat', 'Μηθύμνης37', 'convenience', 0, '38.0019656', '23.7336188'),
(1267, 'Home Market', 'Ευφρονίου', 'convenience', 0, '37.9730147', '23.7486919'),
(1272, 'tsibato', 'Δεκελείας', 'convenience', 0, '38.0282203', '23.7330984'),
(1273, 'Δια...Κρητικά Καλούδια', '', 'supermarket', 0, '37.9682222', '23.6999734'),
(1274, 'Spot market', '', 'convenience', 1, '38.0317370', '23.7630366'),
(1275, 'Nikiforos', '', 'convenience', 0, '37.4643408', '25.3283765'),
(1278, 'Παιχνίδια Ψιλικά', '', 'convenience', 0, '38.0132286', '23.7466828'),
(1279, 'Ena Cash And Carry', '', 'supermarket', 0, '38.2346622', '21.7253472'),
(1280, 'ΚΡΟΝΟΣ - (Σκαγιοπουλείου)', '', 'supermarket', 0, '38.2358002', '21.7294915'),
(1281, 'Ανδρικόπουλος Super Market', '', 'supermarket', 0, '38.2379176', '21.7306406'),
(1282, '3Α Αράπης', '', 'supermarket', 0, '38.2375068', '21.7328984'),
(1284, 'Super Market Θεοδωρόπουλος', '', 'supermarket', 0, '38.2360129', '21.7283123'),
(1285, 'Super Market ΚΡΟΝΟΣ', '', 'supermarket', 0, '38.2390442', '21.7340723'),
(1287, 'Kolovos', '', 'convenience', 0, '37.6571716', '22.7270128'),
(1289, '3A Market', '', 'supermarket', 0, '38.3921898', '23.7916114'),
(1290, 'Κοραλία', '', 'convenience', 0, '37.9353506', '23.6308401'),
(1291, 'Ψιλικά τσιγάρα', '', 'convenience', 0, '38.0334664', '23.7601142'),
(1293, 'Amin', 'Ιακωβάτων30', 'convenience', 0, '38.0146020', '23.7327174'),
(1298, 'Περαντάκος', '', 'supermarket', 0, '37.6411445', '25.0394300'),
(1299, 'Αμβρόσιος', '', 'convenience', 0, '38.0310994', '23.7804684'),
(1300, 'Μικρή Αγορά Περαντάκου', '', 'supermarket', 0, '37.6516406', '25.0517635'),
(1301, 'International Market', 'Αγίας Ζώνης', 'convenience', 0, '38.0049559', '23.7380024'),
(1302, 'Ghazni', '', 'convenience', 0, '37.9928965', '23.7291463'),
(1303, 'Χρήστος', 'Φυλής39Α', 'convenience', 0, '37.9925312', '23.7280205'),
(1305, 'S.M.A. Mini Market', '', 'convenience', 0, '38.0068203', '23.7352440'),
(1308, 'Ok! anytime', '', 'supermarket', 0, '37.9881038', '23.7676308'),
(1310, 'Μήτρου', '', 'convenience', 0, '38.3830076', '23.6292226'),
(1311, 'Banghu', '', 'supermarket', 0, '38.3786580', '23.6305652'),
(1314, '3A ARAPIS', '', 'supermarket', 0, '38.2586424', '21.7460078'),
(1315, 'Ψιλικοκό', '', 'convenience', 0, '38.0434422', '23.7495647'),
(1316, 'Anything anytime', '', 'convenience', 0, '38.0385414', '23.7644201'),
(1318, 'ΑΒ Shop & Go', '', 'supermarket', 0, '38.2495700', '21.7380288'),
(1320, 'Χάρης', 'Αγίας Τριάδος31', 'convenience', 0, '38.0151473', '23.6722454'),
(1323, 'Το ρόδι', 'Βοσπόρου', 'convenience', 0, '38.0377662', '23.7701693'),
(1324, 'Mikron Europa', '', 'convenience', 0, '36.9722974', '24.7251177'),
(1326, 'Σταθμός', '', 'convenience', 0, '39.4172072', '23.1353772'),
(1327, 'Τζερτζελές', '', 'convenience', 0, '39.4188328', '23.1345571'),
(1328, 'Mini Market - Παντοπωλείο', 'Εθνάρχου Μακαρίου51', 'supermarket', 0, '38.4699692', '23.5902667'),
(1333, 'Κωβαίος Mini Market', '', 'supermarket', 0, '36.8697592', '25.5187983'),
(1335, 'Τέλης Πλατανίτης', '', 'supermarket', 0, '37.4482854', '22.4607247'),
(1336, 'Δελής', '', 'supermarket', 0, '37.4482062', '22.4667212'),
(1338, 'Έλενα', '', 'convenience', 0, '39.1483905', '23.8701467'),
(1340, 'Market Katerina Agallou', '', 'supermarket', 0, '39.1526566', '23.8726064'),
(1341, 'Το πρώτο', '', 'supermarket', 0, '39.1396836', '23.6485708'),
(1342, 'Καλλιάνος', '', 'convenience', 0, '39.1398620', '23.6426913'),
(1343, 'Αλέξανδρος', '', 'supermarket', 0, '39.1385926', '23.6459570'),
(1344, 'Louis Supermarkt', '', 'convenience', 0, '38.9456308', '22.2018458'),
(1345, 'Proton Super Market', '', 'supermarket', 0, '38.2651626', '24.1604416'),
(1348, 'Γκουβάς Market', '', 'convenience', 0, '37.9719270', '23.7706422'),
(1349, 'ΚΡΗΤΙΚΟΣ Super market', '', 'supermarket', 0, '37.7538976', '23.4410042'),
(1352, 'Τα Παντα Ολα mini market', 'EO Isthmou Archaias Epidavrou 105, Loutra Oreas Elenis105', 'supermarket', 0, '37.8620894', '22.9967667'),
(1354, 'Κοινωνικό Παντοπωλείο', '', 'convenience', 0, '38.0289767', '23.7349769'),
(1358, 'SUPERmini Market', 'Εθνικής Αντιστάσεως56', 'convenience', 0, '37.9705970', '23.7718837'),
(1360, 'Tragreecetional', 'Αγίας Μαρίνας38', 'convenience', 0, '37.9307276', '23.6364077'),
(1363, 'Everything', '', 'convenience', 0, '37.9285168', '23.6367242'),
(1364, 'Ο Βασιλικός', '', 'convenience', 0, '37.9343353', '23.6430647'),
(1365, 'Mega market', '', 'convenience', 0, '37.9290835', '23.6351963'),
(1367, 'Athina', '28ης Οκτωβρίου73', 'convenience', 0, '37.9921768', '23.7311771'),
(1368, 'Σκουτέλι', '', 'convenience', 0, '38.0328781', '23.7504091'),
(1369, 'Φάμιλυ Μάρκετ Βόλος', 'Αναλήψεως104', 'supermarket', 0, '39.3674608', '22.9487930'),
(1370, 'Φλέα', '', 'convenience', 0, '37.1179183', '25.4254086'),
(1371, 'Αφεντάκης Super Market', '', 'supermarket', 0, '37.0417042', '22.1233808'),
(1372, 'Φώτης', '', 'convenience', 0, '37.0415887', '22.1235646'),
(1374, 'Παναγοπούλου Θεοδ. Μαρία', '', 'convenience', 0, '37.0405862', '22.1249527'),
(1375, 'Super Market Μουργής', '', 'supermarket', 0, '37.0388676', '22.1186382'),
(1376, 'Market plus', '2', 'convenience', 0, '38.0363467', '23.7476457'),
(1377, 'Kazi', '', 'convenience', 0, '37.9971415', '23.7363426'),
(1378, 'Kosmo market', '', 'convenience', 0, '37.9966728', '23.7356827'),
(1379, 'Armam', '', 'convenience', 0, '37.9987378', '23.7355254'),
(1380, 'Ok anytime!', '', 'supermarket', 0, '37.9964949', '23.7354306'),
(1382, 'Panda', '', 'convenience', 0, '37.9778660', '23.7122249'),
(1383, 'Ab shop&go', 'Καυτατζόγλου38', 'supermarket', 0, '38.0161452', '23.7314272'),
(1384, 'Η Σέσουλα', '', 'convenience', 0, '38.0178590', '23.7353548'),
(1385, 'Umar', '', 'convenience', 0, '38.0159553', '23.7318242'),
(1388, 'Imi', '', 'convenience', 0, '37.9999461', '23.7394868'),
(1390, 'Nasser Al Saidi', '', 'convenience', 0, '37.9945291', '23.7270134'),
(1391, 'Karshied', '', 'convenience', 0, '37.9932530', '23.7269252'),
(1392, 'Albasha', '', 'convenience', 0, '37.9912078', '23.7267252'),
(1397, 'Πασλόγλου', '', 'convenience', 0, '37.9834323', '23.6623636'),
(1399, 'Olive oil & oregano', '', 'convenience', 0, '38.4786103', '22.4945527'),
(1401, 'Αλαλούμ', 'Μαλαγαρδη Δ.27', 'convenience', 0, '37.9736961', '23.6541252'),
(1404, 'Bazaar Super Markt', '', 'supermarket', 0, '37.4421337', '25.3365953'),
(1406, 'Σίσσος', '', 'convenience', 0, '38.3767165', '22.6298880'),
(1409, 'Mother\'s blessing', 'Αλκιβιάδου255', 'convenience', 0, '37.9362588', '23.6430731'),
(1410, 'Arian', 'Αχαρνών26', 'convenience', 0, '37.9893146', '23.7268663'),
(1411, 'Kashmir', 'Μενάνδρου15', 'convenience', 0, '37.9812842', '23.7243974'),
(1416, 'Lebara', '', 'convenience', 0, '37.9833329', '23.7252501'),
(1417, 'OK Markets', 'Εθνικής Αντιστάσεως50', 'convenience', 0, '38.0134095', '23.6904209'),
(1422, 'Ataka Stores', '', 'convenience', 0, '38.0758466', '23.4960786'),
(1424, 'eKiosky\'s', '', 'convenience', 0, '37.9599546', '23.7486054'),
(1426, 'Μαργαριτα', '', 'convenience', 0, '37.9395673', '23.1459202'),
(1427, 'Mama Bee', '', 'convenience', 0, '37.9386549', '22.9366450'),
(1428, 'Καρυλακης', '', 'convenience', 0, '38.0072123', '23.4106529'),
(1430, 'Πανας', '', 'convenience', 0, '37.9367018', '22.9299113'),
(1431, 'Mini Market Alaziz', 'Σουρμελή12', 'convenience', 0, '37.9889988', '23.7252183'),
(1432, 'Χαλκιαδάκης', 'Παναγή Τσαλδάρη40', 'convenience', 0, '38.0153326', '23.6934239'),
(1435, 'Η Απάνω Χώρα', '', 'convenience', 0, '37.4504647', '24.9366421'),
(1436, 'Αγγελἐτου', '', 'supermarket', 0, '36.9955393', '22.6957100'),
(1437, 'Ελκηνικη Διατροφη', '', 'supermarket', 0, '37.0689006', '22.4294051'),
(1440, 'Mini Market Γρηγορόπουλου Χρυσούλα', '', 'convenience', 0, '37.4419995', '21.7742684'),
(1444, 'Mercado', 'Μερσίνης4', 'convenience', 0, '38.0376907', '23.7400071'),
(1445, 'Μυλωνας', '', 'convenience', 0, '38.4858804', '21.6269007'),
(1446, 'Ζηση', '', 'convenience', 0, '38.4857649', '21.6273299'),
(1448, 'Η Μελισσα', '', 'convenience', 0, '38.5740755', '21.6672015'),
(1449, 'Στουμπα Θεοδωρα', '', 'convenience', 0, '38.5730032', '21.6658434'),
(1451, 'ΑΒ ΚΟΝΟΠΙΣΗ', '', 'supermarket', 0, '37.5239144', '22.7300491'),
(1452, 'Spar Express', '', 'convenience', 0, '37.9132968', '23.7092992'),
(1454, 'Plessos The Market', '', 'supermarket', 0, '37.9618219', '23.7308970'),
(1457, 'Ο φθηνούλης της Πατησίων 209', '', 'convenience', 0, '38.0071555', '23.7349558'),
(1458, 'Pacific Food Market', '', 'supermarket', 0, '37.9914381', '23.7634175'),
(1460, 'Αποστόλης Βεντούρης', '', 'convenience', 0, '36.7914302', '24.5738243'),
(1463, 'Λεμονιά', 'Ιωαννίνων81', 'convenience', 0, '37.8732307', '23.7710955'),
(1466, 'Market  In', '', 'supermarket', 0, '37.8351874', '24.9314241'),
(1468, 'Αφροδίτη', 'Καματερού78', 'convenience', 0, '38.0603670', '23.7078948'),
(1470, 'God\'s will', 'Μοσχονησίων15Α', 'convenience', 0, '38.0016823', '23.7318580'),
(1473, 'Achiva', '', 'supermarket', 0, '37.9914021', '23.7443588'),
(1474, 'MALTESOS', '', 'supermarket', 0, '37.6909767', '23.4548333'),
(1475, 'Mini Market-Κρεοπωλειο Κυριαζιδη Δεσποινα', '', 'convenience', 0, '36.6203738', '22.4898069'),
(1476, 'Σνακ & σόδα', '', 'convenience', 0, '37.9335256', '23.6315679'),
(1477, 'Μυρσίνη', '', 'convenience', 0, '37.9341121', '23.6352955'),
(1479, 'Basmila Market', '', 'convenience', 0, '38.0088980', '23.7352539'),
(1481, 'MiniStop', '', 'supermarket', 0, '39.1654411', '23.4878564'),
(1483, 'Aspasia Market', '', 'supermarket', 0, '37.0683719', '25.3568902'),
(1485, 'Aiolos Bazaar', 'Αρχαίου Θεάτρου', 'supermarket', 0, '38.3915254', '23.7967920'),
(1487, 'Η Στάση', '', 'supermarket', 0, '38.8111708', '23.2283626'),
(1489, 'Supermarket Καλογιαννης', '', 'supermarket', 0, '39.1526669', '23.8706536'),
(1490, 'Καφενείο Γαλανάδο', '', 'convenience', 0, '37.0748580', '25.4099957'),
(1492, 'Nuru', 'Λιοσίων64', 'convenience', 0, '37.9914700', '23.7236931'),
(1494, 'ΑΘΗΝΑ', 'Αγίων Πάντων38', 'convenience', 0, '37.9564543', '23.7102616'),
(1496, 'Σωτήρης Γαβαλάς', '', 'convenience', 0, '37.9779338', '23.6544074'),
(1497, 'Tobacco Coffee & More', 'Ελευθερίου Βενιζέλου184', 'convenience', 0, '37.9537937', '23.6985339'),
(1502, 'Coffee Kiosk', '', 'convenience', 0, '37.9618337', '23.6493499');
INSERT INTO `object_shop` (`id`, `name`, `address`, `description`, `active_offer`, `latitude`, `longitude`) VALUES
(1503, '4all', 'Ηλία Ηλιού76', 'convenience', 0, '37.9570185', '23.7271860'),
(1508, 'Erbil', '', 'convenience', 0, '37.9846975', '23.7269971'),
(1509, 'Mini Super Market', '', 'convenience', 0, '37.9917287', '23.7280550'),
(1510, 'Al Hayat', '', 'convenience', 0, '37.9854264', '23.7271802'),
(1511, 'Buyan Rahim', '', 'convenience', 0, '37.9908300', '23.7250890'),
(1515, 'Κεντικελένης', '', 'supermarket', 0, '37.9683390', '23.6513088'),
(1518, 'Παπαδάκης', 'Δεξαμενής37', 'convenience', 0, '37.9879472', '23.6384942'),
(1519, 'Proton Απαλίδη', 'Ευριπίδου', 'supermarket', 0, '37.9801405', '23.6396853'),
(1521, 'Ανατολίτικες γεύσεις', 'Αγίου Αλεξάνδρου96', 'supermarket', 0, '37.9322310', '23.6966659'),
(1523, 'Το παντοπωλείο της Ειρήνης', 'Αγίου Αλεξάνδρου79', 'convenience', 0, '37.9317170', '23.6959021'),
(1524, 'Your Market', '', 'supermarket', 0, '37.9306212', '23.6951424'),
(1526, 'enjoy', '28ης Οκτωβρίου', 'convenience', 0, '37.9923691', '23.7316535'),
(1530, 'Kafe Kopteio', '', 'convenience', 0, '36.8529013', '22.6695740'),
(1531, 'Το Εναλλακτικόν', 'Βιθυνίας4', 'convenience', 0, '37.9429206', '23.7144752'),
(1532, 'Sarita', 'Λιοσίων96', 'supermarket', 0, '37.9938349', '23.7229430'),
(1533, 'Αλεξάνδρεια', 'Αγίων Πάντων66', 'convenience', 0, '37.9585079', '23.7079663'),
(1534, 'S.Market Ντόμαρης', 'Ελλ.Αμερικής & Ήρας', 'supermarket', 0, '38.0148117', '24.4247620'),
(1535, 'Μίνα', '', 'convenience', 0, '37.9968165', '22.4792187'),
(1536, 'Ο Γλάρος', '', 'convenience', 0, '37.9740097', '23.6487911'),
(1543, 'BG food market', 'Αχαρνών365', 'convenience', 0, '38.0179402', '23.7282527'),
(1544, 'Ο Ζήκος', 'Γράμμου', 'convenience', 0, '37.9595289', '23.6967383'),
(1545, 'City kiosk', 'Δημητρακοπούλου Ν.47', 'convenience', 0, '37.9650667', '23.7254368'),
(1546, 'Manana', 'Λαυρίου125', 'supermarket', 0, '37.9534208', '23.8606087'),
(1548, 'Across', '', 'convenience', 0, '37.9791785', '23.6501327'),
(1550, 'Οινο-παντοπωλείο', 'Σεβαστείας22', 'convenience', 0, '37.9792035', '23.7576762'),
(1552, 'Αφοί Παναγιωτόπουλοι', '', 'supermarket', 0, '36.8041097', '22.8628342'),
(1554, 'Λεκάκης', '', 'supermarket', 0, '36.6863473', '23.0370615'),
(1555, 'TO stores', 'Ιλισίων28', 'convenience', 0, '37.9791733', '23.7587929'),
(1556, 'Πολυκανδριώτη', '', 'convenience', 0, '37.9332509', '23.6357085'),
(1558, 'Friends market', 'Ιωάννου Φωκά43', 'convenience', 0, '38.0245397', '23.7454892'),
(1559, 'Ινδικά τρόφιμα', '', 'convenience', 0, '37.9424343', '23.6448650'),
(1561, 'Carrefour Market', '', 'supermarket', 0, '37.9459223', '23.6431087'),
(1564, 'Το άριστον', '', 'convenience', 0, '37.0629785', '25.4815379'),
(1565, 'Arip', 'Αγίου Κωνσταντίνου53-55', 'convenience', 0, '37.9849114', '23.7227358'),
(1566, 'Praktiker', '', 'supermarket', 0, '38.0567780', '23.5269711'),
(1568, 'Της γειτονιάς το μαγαζάκι', 'Ιωάννου Φωκά62-64', 'convenience', 0, '38.0235589', '23.7470627'),
(1570, 'Qureshi market', 'Ιωάννου Δροσοπούλου90', 'convenience', 0, '38.0030268', '23.7354474'),
(1572, 'daily\'s', 'Ευφρονίου', 'convenience', 0, '37.9721996', '23.7541488'),
(1577, 'πολυκαταστημα  χιλιαδες ειδη με 1ευρω', 'λεωφ.Σαλαμινας194', 'supermarket', 0, '37.9657319', '23.5071421'),
(1578, 'GDH Service Χασάνι', 'Αγίου Τρύφωνα20', 'supermarket', 0, '38.8829282', '22.4511448'),
(1579, 'GALLERY KOSMAS', '', 'supermarket', 0, '38.9012899', '22.4357710'),
(1581, 'Κική Mini Market', '', 'convenience', 0, '36.7947408', '24.5727331'),
(1582, 'Bhatti Mini Market', 'Ραμνούντος2', 'convenience', 0, '38.1669535', '24.0246338'),
(1583, 'Φούρνος «Ο Στάσης»', 'Ραμνούντος64', 'convenience', 0, '38.1742997', '24.0237526'),
(1584, 'Βασιλικός', '', 'convenience', 0, '37.7059580', '22.0965517'),
(1585, 'Deli Kiosk 24', '', 'convenience', 0, '38.0893672', '23.8191770'),
(1589, 'Κέκης', '', 'supermarket', 0, '38.0487686', '24.3196377'),
(1592, 'Spot Stop', 'Δημοσθένους2', 'convenience', 0, '38.1179595', '23.9902573'),
(1595, 'Ζερβουδησ Μιχαήλ Ηλιαδ', '', 'convenience', 0, '38.2269893', '25.9984925'),
(1597, 'Κανερη Ηλιανα', '', 'convenience', 0, '38.5269890', '25.8681604'),
(1598, 'Gratsias Market', '', 'supermarket', 0, '36.9926511', '25.3956842'),
(1601, 'Παντοπωλείο Κωσταρή', '', 'convenience', 0, '38.2018500', '26.0411578'),
(1604, 'Το κυψελάκι', 'Ιωάννου Δροσοπούλου142', 'convenience', 0, '38.0076126', '23.7361131');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_subcategory`
--

CREATE TABLE `object_subcategory` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text DEFAULT '',
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `ekat_id` varchar(255) DEFAULT NULL,
  `ekat_cat_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_subcategory`
--

INSERT INTO `object_subcategory` (`id`, `name`, `description`, `category_id`, `category_name`, `ekat_id`, `ekat_cat_id`) VALUES
(1, 'Πάνες', '', 1, 'Βρεφικά Είδη', 'e0efaa1776714351a4c17a3a9d412602', '8016e637b54241f8ad242ed1699bf2da'),
(2, 'Βρεφικές τροφές', '', 1, 'Βρεφικά Είδη', '7e86994327f64e3ca967c09b5803966a', '8016e637b54241f8ad242ed1699bf2da'),
(3, 'Μπύρες', '', 2, 'Ποτά - Αναψυκτικά', '329bdd842f9f41688a0aa017b74ffde4', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(4, 'Αναψυκτικά - Ενεργειακά Ποτά', '', 2, 'Ποτά - Αναψυκτικά', '3010aca5cbdc401e8dfe1d39320a8d1a', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(5, 'Είδη γενικού καθαρισμού', '', 3, 'Καθαριότητα', '3be81b50494d4b5495d5fea3081759a6', 'd41744460283406a86f8e4bd5010a66d'),
(6, 'Χαρτικά', '', 3, 'Καθαριότητα', '034941f08ca34f7baaf5932427d7e635', 'd41744460283406a86f8e4bd5010a66d'),
(7, 'Αποσμητικά', '', 4, 'Προσωπική φροντίδα', '35410eeb676b4262b651997da9f42777', '8e8117f7d9d64cf1a931a351eb15bd69'),
(8, 'Κρέμες μαλλιών', '', 4, 'Προσωπική φροντίδα', 'cf079c66251342b690040650104e160f', '8e8117f7d9d64cf1a931a351eb15bd69'),
(9, 'Απορρυπαντικά', '', 1, '', 'e60aca31a37a40db8a83ccf93bd116b1', 'd41744460283406a86f8e4bd5010a66d'),
(10, 'Γάλα', '', 1, '', 'b3992eb422c2495ca02dd19de9d16ad1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(11, 'Περιποιήση σώματος', '', 1, '', 'ddb733df68324cfc8469c890b32e716d', '8016e637b54241f8ad242ed1699bf2da'),
(12, 'Σαμπουάν - Αφρόλουτρα', '', 1, '', '46b02b6b4f4c4d5d8a0efe21d0981027', '8e8117f7d9d64cf1a931a351eb15bd69'),
(13, 'Γιαούρτια', '', 1, '', '0364b4be226146699140e81a469d04a1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(14, 'Μωρομάντηλα', '', 1, '', '92680b33561c4a7e94b7e7a96b5bb153', '8016e637b54241f8ad242ed1699bf2da'),
(15, 'Αποσμητικά Χώρου', '', 3, '', '21051788a9ff4d5d9869d526182b9a5f', 'd41744460283406a86f8e4bd5010a66d'),
(16, 'Εντομoκτόνα - Εντομοαπωθητικά', '', 3, '', '8f98818a7a55419fb42ef1d673f0bb64', 'd41744460283406a86f8e4bd5010a66d'),
(17, 'Είδη κουζίνας - Μπάνιου', '', 3, '', 'b5d54a3d8dd045fb88d5c31ea794dcc5', 'd41744460283406a86f8e4bd5010a66d'),
(18, 'Εμφιαλωμένα νερά', '', 2, '', 'bc4d21162fbd4663b0e60aa9bd65115e', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(19, 'Κρασιά', '', 2, '', '3d01f4ce48ad422b90b50c62b1f8e7f2', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(20, 'Ποτά', '', 2, '', '08f280dee57c4b679be0102a8ba1343b', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(21, 'Χυμοί', '', 2, '', '4f1993ca5bd244329abf1d59746315b8', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(22, 'Βαμβάκια', '', 4, '', 'af538008f3ab40989d67f971e407a85c', '8e8117f7d9d64cf1a931a351eb15bd69'),
(23, 'Βαφές μαλλιών', '', 4, '', '09f2e090f72c4487bc44e5ba4fcea466', '8e8117f7d9d64cf1a931a351eb15bd69'),
(24, 'Λοιπά προϊόντα', '', 4, '', 'a610ce2a98a94ee788ee5f94b4be82c2', '8e8117f7d9d64cf1a931a351eb15bd69'),
(25, 'Υγρομάντηλα', '', 4, '', 'f4d8a256e3944c05a3e7b8904b863882', '8e8117f7d9d64cf1a931a351eb15bd69'),
(26, 'Ξυριστικά - Αποτριχωτικά', '', 4, '', '2df01835007545a880dc43f69b5cae07', '8e8117f7d9d64cf1a931a351eb15bd69'),
(27, 'Οδοντόβουρτσες', '', 4, '', '6db091264f494c86b9cf22a562593c82', '8e8117f7d9d64cf1a931a351eb15bd69'),
(28, 'Πάνες ενηλίκων', '', 4, '', '0bf072374a8e4c40b915e4972990a417', '8e8117f7d9d64cf1a931a351eb15bd69'),
(29, 'Περιποίηση προσώπου', '', 4, '', '5a2a0575959c40d6a46614ab99b2d9af', '8e8117f7d9d64cf1a931a351eb15bd69'),
(30, 'Προϊόντα μαλλιών', '', 4, '', '5935ab588fa444f0a71cc424ad651d12', '8e8117f7d9d64cf1a931a351eb15bd69'),
(31, 'Κρέμα ημέρας', '', 4, '', 'de77af9321844b1f863803f338f4a0c2', '8e8117f7d9d64cf1a931a351eb15bd69'),
(32, 'Κρέμα Σώματος', '', 4, '', 'c44b50bef9674aaeb06b578122bf4445', '8e8117f7d9d64cf1a931a351eb15bd69'),
(33, 'Αντρική περιποίηση', '', 4, '', 'e2f81e96f70e45fb9552452e381529d3', '8e8117f7d9d64cf1a931a351eb15bd69'),
(34, 'Επίδεσμοι', '', 4, '', '1b59d5b58fb04816b8f6a74a4866580a', '8e8117f7d9d64cf1a931a351eb15bd69'),
(35, 'Κρέμες ενυδάτωσης', '', 4, '', 'fefa136c714945a3b6bcdcb4ee9e8921', '8e8117f7d9d64cf1a931a351eb15bd69'),
(36, 'Κρεμοσάπουνα - Σαπούνι', '', 4, '', '9c86a88f56064f8588d42eee167d1f8a', '8e8117f7d9d64cf1a931a351eb15bd69'),
(37, 'Προφυλακτικά', '', 4, '', '7cfab59a5d9c4f0d855712290fc20c7f', '8e8117f7d9d64cf1a931a351eb15bd69'),
(38, 'Σερβιέτες', '', 4, '', '2bce84e7df694ab1b81486aa2baf555d', '8e8117f7d9d64cf1a931a351eb15bd69'),
(39, 'Στοματικά διαλύματα', '', 4, '', '181add033f2d4d95b46844abf619dd30', '8e8117f7d9d64cf1a931a351eb15bd69'),
(40, 'Στοματική υγιεινή', '', 4, '', '26e416b6efa745218f810c34678734b2', '8e8117f7d9d64cf1a931a351eb15bd69'),
(41, 'Αλεύρι - Σιμιγδάλι', '', 5, '', 'c761cd8b18a246eb81fb21858ac10093', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(42, 'Αλλαντικά', '', 5, '', 'be04eae3ca484928a86984d73bf3cc3a', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(43, 'Αυγά', '', 5, '', '6d2babbc7355444ca0d27633207e4743', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(44, 'Βούτυρο - Μαργαρίνη', '', 5, '', 'a240e48245964b02ba73d1a86a2739be', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(45, 'Είδη Ζαχαροπλαστικής', '', 5, '', 'a1a1c2c477b74504b58ad847f7e0c8e1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(46, 'Γλυκά/Σοκολάτες', '', 5, '', 'dca17e0bfb4e469c93c011f8dc8ab512', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(47, 'Επιδόρπια', '', 5, '', '509b949f61cc44f58c2f25093f7fc3eb', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(48, 'Έτοιμα γεύματα/Σούπες', '', 5, '', '1eef696c0f874603a59aed909e1b4ce2', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(49, 'Ζυμαρικά', '', 5, '', '0c347b96540a427e9823f321861ce58e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(50, 'Γλυκά/Κέικ', '', 5, '', 'e63b2caa8dd84e6ea687168200859baa', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(51, 'Κατεψυγμένα/Πίτσες', '', 5, '', '3f38edda7854447a837956d64a2530fa', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(52, 'Κατεψυγμένα/Φύλλα - Βάσεις', '', 5, '', 'd1315c04b3d64aed93472e41d6e5a6f8', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(53, 'Καφέδες', '', 5, '', 'b89cb8dd198748dd8c4e195e4ab2168e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(54, 'Κονσέρβες', '', 5, '', 'df10062ca2a04789bd43d18217008b5f', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(55, 'Τυποποιημένα κρεατικά', '', 5, '', '463e30b829274933ab7eb8e4b349e2c5', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(56, 'Κρέμες γάλακτος', '', 5, '', '4e4cf5616e0f43aaa985c1300dc7109e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(57, 'Λάδι', '', 5, '', '1e9187fb112749ff888b11fd64d79680', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(58, 'Όσπρια', '', 5, '', '50e8a35122854b2b9cf0e97356072f94', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(59, 'Παγωτά', '', 5, '', 'bc66b1d812374aa48d6878730497ede7', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(60, 'Καραμέλες - Τσίχλες', '', 5, '', '7cfe21f0f1944b379f0fead1c8702099', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(61, 'Ξύδι', '', 5, '', '5dca69b976c94eccbf1341ee4ee68b95', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(62, 'Κύβοι', '', 5, '', '3935d6afbf50454595f1f2b99285ce8c', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(63, 'Πελτές τομάτας', '', 5, '', '5aba290bf919489da5810c6122f0bc9b', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(64, 'Πουρές', '', 5, '', 'f6007309d91c4410adf000ffd5e8129e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(65, 'Ροφήματα', '', 5, '', '2d711ee19d17429fa7f964d56fe611db', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(66, 'Ρύζι', '', 5, '', '5d0be05c3b414311bcda335b036202f1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(67, 'Σνάκς/Αρτοσκευάσματα', '', 5, '', 'ea47b5f0016f4f0eb79e3a4b932f7577', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(68, 'Σνάκς/Γαριδάκια', '', 5, '', 'f87bed0b4b8e44c3b532f2c03197aff9', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(69, 'Σνάκς/Κρουασάν', '', 5, '', '19c54e78d74d4b64afbb1fd124f01dfc', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(70, 'Σνάκς/Πατατάκια', '', 5, '', 'ec9d10b5d68c4d8b8998d51bf6d67188', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(71, 'Σνάκς/Ποπ κορν', '', 5, '', '8851b315e2f0486180be07facbc3b21f', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(72, 'Τυριά', '', 5, '', '4c73d0eccd1e4dde8bb882e436a64ebb', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(73, 'Φούρνος/Τσουρέκια', '', 5, '', '0e1982336d8e4bdc867f1620a2bce3be', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(74, 'Φούρνος/Ψωμί', '', 5, '', 'c928573dd7bc4b7894d450eadd7f5d18', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(75, 'Χυμός τομάτας', '', 5, '', 'a02951b1c083449b9e7fab2fabd67198', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(76, 'Μπαχαρικά', '', 5, '', '2ad2e93c1c0c41b4b9769fe06c149393', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(77, 'Σνάκς/Μπάρες - Ράβδοι', '', 5, '', 'df433029824c4b4194b6637db26f69eb', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(78, 'Ειδική διατροφή', '', 5, '', 'b1866f1365a54e2d84c28ad2ca7ab5af', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(79, 'Γλυκά αλλείματα', '', 5, '', 'e397ddcfb34a4640a42b8fa5e999b8c8', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(80, 'Δημητριακά', '', 5, '', '916a76ac76b3462baf2db6dc508b296b', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(81, 'Έτοιμα γεύματα/Σαλάτες', '', 5, '', '4f205aaec31746b89f40f4d5d845b13e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(82, 'Κατεψυγμένα/Πατάτες', '', 5, '', '5c5e625b739b4f19a117198efae8df21', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(83, 'Κατεψυγμένα/Ψάρια', '', 5, '', '7ca5dc60dd00483897249e0f8516ee91', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(84, 'Κατεψυγμένα/Λαχανικά', '', 5, '', '6d084e8eab4945cdb4563d7ff49f0dc3', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(85, 'Κατεψυγμένα/Πίτες', '', 5, '', '1eb56e6ffa2a449296fb1acc7b714cc5', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(86, 'Σάλτσες - Dressings', '', 5, '', 'ce4802b6c9f44776a6e572b3daf93ab1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(87, 'Σνάκς/Μπισκότα', '', 5, '', '35cce434592f489a9ed37596951992b3', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(88, 'Ζάχαρη - Υποκατάστατα ζάχαρης', '', 5, '', 'a885d8cd1057442c9092af37e79bf7a7', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(89, 'Φούρνος/Παξιμάδια', '', 5, '', 'bcebd8cc2f554017864dbf1ce0069ac5', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(90, 'Φούρνος/Φρυγανίες', '', 5, '', 'a483dd538ecd4ce0bdbba36e99ab5eb1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(91, 'Κατεψυγμένα/Κρεατικά', '', 5, '', '9b7795175cbc4a6d9ca37b8ee9bf5815', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(92, 'Φρέσκα/Αφρόψαρο', '', 5, '', 'c487e038079e407fb1a356599c2aec3e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(93, 'Φρέσκα/Ψάρι', '', 5, '', '3d22916b908b40b385bebe4b478cf107', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(94, 'Φρέσκα/Κοτόπουλο', '', 5, '', '8ef82da99b284c69884cc7f3479df1ac', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(95, 'Φρέσκα/Αρνί', '', 5, '', '0936072fcb3947f3baf83e31bb5c1cab', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(96, 'Φρέσκα/Κατσίκι', '', 5, '', 'd3385ff161f0423aa364017d4413fa77', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(97, 'Φρέσκα/Χοιρινό', '', 5, '', 'a73f11a7f08b41c081ef287009387579', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(98, 'Φρέσκα/Μοσχάρι', '', 5, '', 'c2ce05f4653c4f4fa8f39892bbb98960', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(99, 'Φρέσκα/Λαχανικά', '', 5, '', '9bc82778d6b44152b303698e8f72c429', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(100, 'Φρέσκα/Φρούτα', '', 5, '', 'ea47cc6b2f6743169188da125e1f3761', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(101, 'Αντισηπτικά', '', 6, '', '8f1b83b1ab3e4ad1a62df8170d1a0a25', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6'),
(102, 'Μάσκες Προσώπου', '', 7, '', '79728a412a1749ac8315501eb77550f9', '2d5f74de114747fd824ca8a6a9d687fa'),
(103, 'Pet shop/Τροφή γάτας', '', 8, '', '926262c303fe402a8542a5d5cf3ac7eb', '662418cbd02e435280148dbb8892782a'),
(104, 'Pet shop/Τροφή σκύλου', '', 8, '', '0c6e42d52765495dbbd06c189a4fc80f', '662418cbd02e435280148dbb8892782a');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_user`
--

CREATE TABLE `object_user` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `last_session_id` varchar(255) DEFAULT '',
  `name` varchar(255) DEFAULT '',
  `first_name` varchar(255) DEFAULT '',
  `last_name` varchar(255) DEFAULT '',
  `date_creation` datetime DEFAULT current_timestamp(),
  `address` varchar(255) DEFAULT '',
  `latitude` decimal(10,7) DEFAULT 0.0000000,
  `longitude` decimal(10,7) DEFAULT 0.0000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Άδειασμα δεδομένων του πίνακα `object_user`
--

INSERT INTO `object_user` (`id`, `username`, `password`, `email`, `last_session_id`, `name`, `first_name`, `last_name`, `date_creation`, `address`, `latitude`, `longitude`) VALUES
(1, 'ilias2', '1234', 'elangelis2@yahoo.gr', '', '', '', '', '2023-09-13 02:18:25', '', '38.0184475', '23.8003411'),
(2, 'mpou', '1234!', 'kouper2@yahoo.gr', '', '', '', '', '2023-09-13 02:18:25', '', '0.0000000', '0.0000000'),
(3, 'test', '12344', 'testmails2@yahoo.gr', '', '', '', '', '2023-09-13 02:18:25', '', '0.0000000', '0.0000000'),
(4, 'ilias2', '12345', 'kati2@yahoo.gr', '', '', '', '', '2023-09-13 02:18:25', '', '38.0184475', '23.8003411');

--
-- Δείκτες `object_user`
--
DELIMITER $$
CREATE TRIGGER `OnAfterInsert_CreateUserScoreRecord` AFTER INSERT ON `object_user` FOR EACH ROW BEGIN
    INSERT INTO Archive_score_TOTAL (user_id,score) VALUES(new.id,0);
END
$$
DELIMITER ;

--
-- Ευρετήρια για άχρηστους πίνακες
--

--
-- Ευρετήρια για πίνακα `archive_product_history`
--
ALTER TABLE `archive_product_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_Product_History_product_id` (`product_id`),
  ADD KEY `Archive_Product_History_shop_id` (`shop_id`);

--
-- Ευρετήρια για πίνακα `archive_product_mesitimi`
--
ALTER TABLE `archive_product_mesitimi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_Product_MesiTimi_product_id` (`product_id`);

--
-- Ευρετήρια για πίνακα `archive_score_month`
--
ALTER TABLE `archive_score_month`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_score_MONTH_user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `archive_score_total`
--
ALTER TABLE `archive_score_total`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_score_TOTAL_user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `archive_token_bank`
--
ALTER TABLE `archive_token_bank`
  ADD PRIMARY KEY (`id`,`date_created`);

--
-- Ευρετήρια για πίνακα `archive_token_month`
--
ALTER TABLE `archive_token_month`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_token_MONTH_user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `archive_token_total`
--
ALTER TABLE `archive_token_total`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_token_TOTAL_user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `archive_user_actions`
--
ALTER TABLE `archive_user_actions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_user_actions_user_id` (`user_id`),
  ADD KEY `Archive_user_actions_offer_id` (`offer_id`);

--
-- Ευρετήρια για πίνακα `archive_user_score_history`
--
ALTER TABLE `archive_user_score_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Archive_user_score_history_user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `object_admin`
--
ALTER TABLE `object_admin`
  ADD PRIMARY KEY (`id`,`name`);

--
-- Ευρετήρια για πίνακα `object_category`
--
ALTER TABLE `object_category`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `object_offer`
--
ALTER TABLE `object_offer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `object_offer_shop_id` (`shop_id`),
  ADD KEY `object_offer_product_id` (`product_id`),
  ADD KEY `object_offer_creation_user_id` (`creation_user_id`);

--
-- Ευρετήρια για πίνακα `object_product`
--
ALTER TABLE `object_product`
  ADD PRIMARY KEY (`id`,`name`),
  ADD KEY `object_product_category_id` (`category_id`),
  ADD KEY `object_product_subcategory_id` (`subcategory_id`);

--
-- Ευρετήρια για πίνακα `object_shop`
--
ALTER TABLE `object_shop`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Ευρετήρια για πίνακα `object_subcategory`
--
ALTER TABLE `object_subcategory`
  ADD PRIMARY KEY (`id`,`name`),
  ADD KEY `object_subcategory_category_id` (`category_id`);

--
-- Ευρετήρια για πίνακα `object_user`
--
ALTER TABLE `object_user`
  ADD PRIMARY KEY (`id`,`username`),
  ADD UNIQUE KEY `email` (`email`,`password`);

--
-- AUTO_INCREMENT για άχρηστους πίνακες
--

--
-- AUTO_INCREMENT για πίνακα `archive_product_history`
--
ALTER TABLE `archive_product_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT για πίνακα `archive_product_mesitimi`
--
ALTER TABLE `archive_product_mesitimi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT για πίνακα `archive_score_month`
--
ALTER TABLE `archive_score_month`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT για πίνακα `archive_score_total`
--
ALTER TABLE `archive_score_total`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT για πίνακα `archive_token_bank`
--
ALTER TABLE `archive_token_bank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `archive_token_month`
--
ALTER TABLE `archive_token_month`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT για πίνακα `archive_token_total`
--
ALTER TABLE `archive_token_total`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT για πίνακα `archive_user_actions`
--
ALTER TABLE `archive_user_actions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT για πίνακα `archive_user_score_history`
--
ALTER TABLE `archive_user_score_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT για πίνακα `object_category`
--
ALTER TABLE `object_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT για πίνακα `object_offer`
--
ALTER TABLE `object_offer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT για πίνακα `object_product`
--
ALTER TABLE `object_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1269;

--
-- AUTO_INCREMENT για πίνακα `object_shop`
--
ALTER TABLE `object_shop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3381;

--
-- AUTO_INCREMENT για πίνακα `object_subcategory`
--
ALTER TABLE `object_subcategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT για πίνακα `object_user`
--
ALTER TABLE `object_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `archive_product_history`
--
ALTER TABLE `archive_product_history`
  ADD CONSTRAINT `Archive_Product_History_product_id` FOREIGN KEY (`product_id`) REFERENCES `object_product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Archive_Product_History_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `object_shop` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_product_mesitimi`
--
ALTER TABLE `archive_product_mesitimi`
  ADD CONSTRAINT `Archive_Product_MesiTimi_product_id` FOREIGN KEY (`product_id`) REFERENCES `object_product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_score_month`
--
ALTER TABLE `archive_score_month`
  ADD CONSTRAINT `Archive_score_MONTH_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_score_total`
--
ALTER TABLE `archive_score_total`
  ADD CONSTRAINT `Archive_score_TOTAL_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_token_month`
--
ALTER TABLE `archive_token_month`
  ADD CONSTRAINT `Archive_token_MONTH_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_token_total`
--
ALTER TABLE `archive_token_total`
  ADD CONSTRAINT `Archive_token_TOTAL_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_user_actions`
--
ALTER TABLE `archive_user_actions`
  ADD CONSTRAINT `Archive_user_actions_offer_id` FOREIGN KEY (`offer_id`) REFERENCES `object_offer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Archive_user_actions_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `archive_user_score_history`
--
ALTER TABLE `archive_user_score_history`
  ADD CONSTRAINT `Archive_user_score_history_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `object_offer`
--
ALTER TABLE `object_offer`
  ADD CONSTRAINT `object_offer_creation_user_id` FOREIGN KEY (`creation_user_id`) REFERENCES `object_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `object_offer_product_id` FOREIGN KEY (`product_id`) REFERENCES `object_product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `object_offer_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `object_shop` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `object_product`
--
ALTER TABLE `object_product`
  ADD CONSTRAINT `object_product_category_id` FOREIGN KEY (`category_id`) REFERENCES `object_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `object_product_subcategory_id` FOREIGN KEY (`subcategory_id`) REFERENCES `object_subcategory` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Περιορισμοί για πίνακα `object_subcategory`
--
ALTER TABLE `object_subcategory`
  ADD CONSTRAINT `object_subcategory_category_id` FOREIGN KEY (`category_id`) REFERENCES `object_category` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$
--
-- Συμβάντα
--
CREATE DEFINER=`root`@`localhost` EVENT `EndMonth_TokenBank` ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-31 20:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL EndMonth_UpdateAllUserScore()$$

CREATE DEFINER=`root`@`localhost` EVENT `StartMonth_TokenBank` ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-01 00:00:01' ON COMPLETION NOT PRESERVE ENABLE DO CALL StartMonth_UpdateTokenBankAvailableTokens()$$

CREATE DEFINER=`root`@`localhost` EVENT `Update_and_DeleteOffers` ON SCHEDULE EVERY 1 DAY STARTS '2023-07-29 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL Update_DeleteExistingOffers()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
