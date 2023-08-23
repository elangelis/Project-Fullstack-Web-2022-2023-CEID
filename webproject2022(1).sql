-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Εξυπηρετητής: 127.0.0.1
-- Χρόνος δημιουργίας: 24 Αυγ 2023 στις 00:29:16
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
CREATE DATABASE IF NOT EXISTS `webproject2022` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `webproject2022`;

DELIMITER $$
--
-- Διαδικασίες
--
DROP PROCEDURE IF EXISTS `ADMIN_InsertCategories`$$
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

DROP PROCEDURE IF EXISTS `ADMIN_InsertProductPrices`$$
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

DROP PROCEDURE IF EXISTS `ADMIN_InsertProducts`$$
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

DROP PROCEDURE IF EXISTS `ADMIN_InsertSubcategories`$$
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

DROP PROCEDURE IF EXISTS `CalculateMesiTimiPrevious7Days`$$
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

DROP PROCEDURE IF EXISTS `CalculateMesiTimiPreviousDay`$$
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

DROP PROCEDURE IF EXISTS `ChangeOfferStockStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ChangeOfferStockStatus` (IN `in_offer_id` INTEGER, IN `Available` BOOLEAN)   BEGIN
    SET @COUNT=NULL;
    SELECT COUNT(*) INTO @COUNT FROM object_offer WHERE id=in_offer_id;
    IF(@COUNT IS NOT NULL AND @COUNT>0)THEN
        UPDATE object_offer SET has_stock=Available WHERE id=in_offer_id;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `Database_AllHistoryLikesUser`$$
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

DROP PROCEDURE IF EXISTS `Database_AllOffersDetails`$$
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

DROP PROCEDURE IF EXISTS `Database_AllProductDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllProductDetails` ()   BEGIN

    SELECT * FROM object_product;

END$$

DROP PROCEDURE IF EXISTS `Database_AllShopDetails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllShopDetails` ()   BEGIN

    SELECT * FROM object_shop;
    
END$$

DROP PROCEDURE IF EXISTS `Database_AllUserDetails`$$
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
            s.score         AS total_score

     FROM object_user AS u
     LEFT JOIN Archive_score_TOTAL AS s ON s.user_id=u.id;
    
END$$

DROP PROCEDURE IF EXISTS `Database_AllUserLeaderboard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Database_AllUserLeaderboard` ()   BEGIN

    SELECT 	u.username                                              as username,
    		CONCAT( u.first_name, " ", u.last_name )                as full_name,
            u.date_creation                                         as date_created,
            IFNULL(s.score,0)                                       as total_score,
            COUNT(o.id)                                             as offers,
			( SELECT COUNT(*) FROM archive_user_actions as a WHERE user_id = u.id AND type = 1 )                    as likes,
			( SELECT COUNT(*) FROM archive_user_actions as a WHERE user_id = u.id AND type = 2 )                    as dislikes
            ,
            IFNULL( (SELECT token FROM Archive_token_MONTH as tm WHERE tm.user_id = u.id AND tm.month_start<=CURRENT_DATE AND tm.month_end>=CURRENT_DATE),0)    as current_tokens,
            IFNULL( (SELECT tokens FROM Archive_token_TOTAL as tt WHERE tt.user_id = u.id),0)                                                                   as total_tokens
            
			      
    FROM object_user as u
    INNER JOIN archive_score_total   	as s on s.user_id=u.id
	LEFT JOIN object_offer          	as o on o.creation_user_id=u.id
    GROUP BY u.id
    ORDER BY total_score DESC;


END$$

DROP PROCEDURE IF EXISTS `Database_AllUserLikes`$$
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

DROP PROCEDURE IF EXISTS `Database_AllUserOffers`$$
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

DROP PROCEDURE IF EXISTS `Database_UserScores`$$
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
          WHERE u.id=userid;
     END IF;
END$$

DROP PROCEDURE IF EXISTS `DeleteAllData`$$
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

DROP PROCEDURE IF EXISTS `DeleteAllPOIS`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAllPOIS` ()   BEGIN

    DELETE FROM object_shop;
    
    
END$$

DROP PROCEDURE IF EXISTS `EndMonth_UpdateAllUserScore`$$
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

DROP PROCEDURE IF EXISTS `F_GetOffersProductUser`$$
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
          IFNULL(t.score,0) as userscore
     FROM object_offer as o
     INNER JOIN object_product as p ON p.id=o.product_id
     INNER JOIN object_user AS u ON o.creation_user_id=u.id
     LEFT JOIN archive_score_total as t ON t.user_id=u.id;

END$$

DROP PROCEDURE IF EXISTS `InsertPOIS`$$
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

DROP PROCEDURE IF EXISTS `M_UpdateUserCredentials`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserCredentials` (IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255), IN `in_session_username` VARCHAR(255))   BEGIN
    UPDATE object_user 
    SET 
        username=in_username,
        password=in_password,
        email=in_email 
    WHERE username=in_session_username;    
END$$

DROP PROCEDURE IF EXISTS `M_UpdateUserLatLong`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UpdateUserLatLong` (IN `in_latitude` DECIMAL(12,7), IN `in_longitude` DECIMAL(12,7), IN `in_username` CHAR(255))   BEGIN
    UPDATE object_user 
    SET latitude=in_latitude, longitude=in_longitude
    WHERE username=in_username;
END$$

DROP PROCEDURE IF EXISTS `M_UserCreation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `M_UserCreation` (IN `in_username` VARCHAR(255), IN `in_password` VARCHAR(255), IN `in_email` VARCHAR(255))   BEGIN
    INSERT INTO object_user(username,password,email)
    VALUES (in_username,in_password,in_email);
END$$

DROP PROCEDURE IF EXISTS `StartMonth_UpdateTokenBankAvailableTokens`$$
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

DROP PROCEDURE IF EXISTS `SubmitDislike`$$
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

DROP PROCEDURE IF EXISTS `SubmitLike`$$
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

DROP PROCEDURE IF EXISTS `SubmitOffer`$$
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

DROP PROCEDURE IF EXISTS `Update_DeleteExistingOffers`$$
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

DROP PROCEDURE IF EXISTS `UserScoreAndTokens`$$
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

DROP TABLE IF EXISTS `archive_product_history`;
CREATE TABLE IF NOT EXISTS `archive_product_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `date` date DEFAULT curdate(),
  PRIMARY KEY (`id`),
  KEY `Archive_Product_History_product_id` (`product_id`),
  KEY `Archive_Product_History_shop_id` (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_product_history`
--

TRUNCATE TABLE `archive_product_history`;
--
-- Δείκτες `archive_product_history`
--
DROP TRIGGER IF EXISTS `OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord`;
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

DROP TABLE IF EXISTS `archive_product_mesitimi`;
CREATE TABLE IF NOT EXISTS `archive_product_mesitimi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `mesi_timi` decimal(10,2) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Archive_Product_MesiTimi_product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_product_mesitimi`
--

TRUNCATE TABLE `archive_product_mesitimi`;
-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_score_month`
--

DROP TABLE IF EXISTS `archive_score_month`;
CREATE TABLE IF NOT EXISTS `archive_score_month` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `score` int(10) UNSIGNED DEFAULT 0,
  `date_created` date DEFAULT curdate(),
  `month_start` date DEFAULT NULL,
  `month_end` date DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Archive_score_MONTH_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_score_month`
--

TRUNCATE TABLE `archive_score_month`;
--
-- Δείκτες `archive_score_month`
--
DROP TRIGGER IF EXISTS `OnAfterInsertArchiveScoreMonth_InsertUpdateScoreTotal`;
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
DROP TRIGGER IF EXISTS `OnBeforeInsertArchiveScoreMonth_ModifyDatesCurrentRecord`;
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

DROP TABLE IF EXISTS `archive_score_total`;
CREATE TABLE IF NOT EXISTS `archive_score_total` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `score` int(10) UNSIGNED DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Archive_score_TOTAL_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_score_total`
--

TRUNCATE TABLE `archive_score_total`;
--
-- Άδειασμα δεδομένων του πίνακα `archive_score_total`
--

INSERT INTO `archive_score_total` (`id`, `user_id`, `score`) VALUES
(7, 17, 0),
(8, 18, 0),
(9, 19, 0),
(10, 20, 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_token_bank`
--

DROP TABLE IF EXISTS `archive_token_bank`;
CREATE TABLE IF NOT EXISTS `archive_token_bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_count` int(11) DEFAULT 0,
  `token_TOTAL` int(11) DEFAULT 0,
  `token_AVAILABLE` int(11) DEFAULT 0,
  `date_created` date NOT NULL DEFAULT curdate(),
  `datetime_created` datetime DEFAULT current_timestamp(),
  `month_start` date DEFAULT NULL,
  `month_end` date DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_token_bank`
--

TRUNCATE TABLE `archive_token_bank`;
--
-- Δείκτες `archive_token_bank`
--
DROP TRIGGER IF EXISTS `OnBeforeInsertArchiveTokenBANK_ModifyDatesCurrentRecord`;
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

DROP TABLE IF EXISTS `archive_token_month`;
CREATE TABLE IF NOT EXISTS `archive_token_month` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` int(10) UNSIGNED DEFAULT 0,
  `date_created` date DEFAULT curdate(),
  `month_start` date DEFAULT NULL,
  `month_end` date DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Archive_token_MONTH_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_token_month`
--

TRUNCATE TABLE `archive_token_month`;
--
-- Δείκτες `archive_token_month`
--
DROP TRIGGER IF EXISTS `OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal`;
DELIMITER $$
CREATE TRIGGER `OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal` AFTER INSERT ON `archive_token_month` FOR EACH ROW BEGIN

    SET @count=0;
    SELECT COUNT(*) INTO @count FROM Archive_token_TOTAL WHERE user_id=new.user_id;
    -- check if record exists
    IF (@count IS NOT NULL AND @count>0) THEN
        -- modify previous one
        SELECT SUM(token) INTO @prev_tokens FROM Archive_token_TOTAL WHERE user_id=new.user_id;
        
        SET @new_tokens=@prev_tokens+new.token;
        
        UPDATE Archive_token_TOTAL SET token=@new_score WHERE user_id=new.user_id;

    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_token_TOTAL (user_id,token)VALUES(new.user_id,new.token);
    
    END IF;

END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `OnBeforeInsertArchivetokenMONTH_ModifyDatesCurrentRecord`;
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

DROP TABLE IF EXISTS `archive_token_total`;
CREATE TABLE IF NOT EXISTS `archive_token_total` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `tokens` int(10) UNSIGNED DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Archive_token_TOTAL_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_token_total`
--

TRUNCATE TABLE `archive_token_total`;
-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `archive_user_actions`
--

DROP TABLE IF EXISTS `archive_user_actions`;
CREATE TABLE IF NOT EXISTS `archive_user_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `date` date DEFAULT current_timestamp(),
  `type` enum('like','dislike') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Archive_user_actions_user_id` (`user_id`),
  KEY `Archive_user_actions_offer_id` (`offer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_user_actions`
--

TRUNCATE TABLE `archive_user_actions`;
--
-- Δείκτες `archive_user_actions`
--
DROP TRIGGER IF EXISTS `OnAfterInsertUserActions_InsertIntoUserScoreHistory`;
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
DROP TRIGGER IF EXISTS `OnAfterUpdateUserActions_UpdateIntoUserScoreHistory`;
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
DROP TRIGGER IF EXISTS `OnBeforeInsertUserActions_ModifyDateCurrentRecord`;
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

DROP TABLE IF EXISTS `archive_user_score_history`;
CREATE TABLE IF NOT EXISTS `archive_user_score_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `user_likes_id` int(11) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `score` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Archive_user_score_history_user_id` (`user_id`),
  KEY `Archive_user_score_history_offer_id` (`offer_id`),
  KEY `Archive_user_score_history_user_likes_id` (`user_likes_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `archive_user_score_history`
--

TRUNCATE TABLE `archive_user_score_history`;
-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_admin`
--

DROP TABLE IF EXISTS `object_admin`;
CREATE TABLE IF NOT EXISTS `object_admin` (
  `id` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(255) DEFAULT '',
  `password` varchar(255) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '',
  `first_name` varchar(255) DEFAULT '',
  `last_name` varchar(255) DEFAULT '',
  `isAdmin` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_admin`
--

TRUNCATE TABLE `object_admin`;
-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_category`
--

DROP TABLE IF EXISTS `object_category`;
CREATE TABLE IF NOT EXISTS `object_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `ekat_id` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_category`
--

TRUNCATE TABLE `object_category`;
--
-- Άδειασμα δεδομένων του πίνακα `object_category`
--

INSERT INTO `object_category` (`id`, `name`, `description`, `ekat_id`) VALUES
(21, 'Βρεφικά Είδη', '', '8016e637b54241f8ad242ed1699bf2da'),
(22, 'Καθαριότητα', '', 'd41744460283406a86f8e4bd5010a66d'),
(23, 'Ποτά - Αναψυκτικά', '', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(24, 'Προσωπική φροντίδα', '', '8e8117f7d9d64cf1a931a351eb15bd69'),
(25, 'Τρόφιμα', '', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(26, 'Αντισηπτικά', '', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6'),
(27, 'Προστασία Υγείας', '', '2d5f74de114747fd824ca8a6a9d687fa'),
(28, 'Για κατοικίδια', '', '662418cbd02e435280148dbb8892782a'),
(29, 'Βρεφικά Είδη', '', '8016e637b54241f8ad242ed1699bf2da'),
(30, 'Ποτά - Αναψυκτικά', '', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(31, 'Καθαριότητα', '', 'd41744460283406a86f8e4bd5010a66d'),
(32, 'Προσωπική φροντίδα', '', '8e8117f7d9d64cf1a931a351eb15bd69');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_offer`
--

DROP TABLE IF EXISTS `object_offer`;
CREATE TABLE IF NOT EXISTS `object_offer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `product_price` decimal(7,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_offer_shop_id` (`shop_id`),
  KEY `object_offer_product_id` (`product_id`),
  KEY `object_offer_creation_user_id` (`creation_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_offer`
--

TRUNCATE TABLE `object_offer`;
--
-- Δείκτες `object_offer`
--
DROP TRIGGER IF EXISTS `OnAfterDeleteOffer_UpdateShopHasOffer`;
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
DROP TRIGGER IF EXISTS `OnAfterInsertOffer_InsertIntoProductHistory`;
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
DROP TRIGGER IF EXISTS `OnAfterInsertOffer_InsertIntoUserScoreHistory`;
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
DROP TRIGGER IF EXISTS `OnAfterInsertOffer_UpdateShopHasOffer`;
DELIMITER $$
CREATE TRIGGER `OnAfterInsertOffer_UpdateShopHasOffer` AFTER INSERT ON `object_offer` FOR EACH ROW BEGIN

    UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;

    END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `OnAfterUpdateOffer_InsertIntoProductHistory`;
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
DROP TRIGGER IF EXISTS `OnAfterUpdateOffer_InsertIntoUserScoreHistory`;
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
DROP TRIGGER IF EXISTS `OnAfterUpdateOffer_UpdateShopHasOffer`;
DELIMITER $$
CREATE TRIGGER `OnAfterUpdateOffer_UpdateShopHasOffer` AFTER UPDATE ON `object_offer` FOR EACH ROW BEGIN

        UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;

    END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `OnBeforeInsertOffer_ModifyExpiratioDate`;
DELIMITER $$
CREATE TRIGGER `OnBeforeInsertOffer_ModifyExpiratioDate` BEFORE INSERT ON `object_offer` FOR EACH ROW BEGIN
        SET new.expiration_date=DATE_ADD(new.creation_date,INTERVAL 7 DAY);

    END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `OnBeforeInsertOffer_ModifyExpirationDate`;
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

DROP TABLE IF EXISTS `object_product`;
CREATE TABLE IF NOT EXISTS `object_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text DEFAULT '',
  `photourl` text DEFAULT '',
  `photo_DATA` longblob DEFAULT NULL,
  `category_id` int(11) NOT NULL DEFAULT 0,
  `subcategory_id` int(11) NOT NULL DEFAULT 0,
  `ekat_id` varchar(255) DEFAULT '',
  `ekat_cat_id` varchar(255) DEFAULT '',
  `ekat_sub_id` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`,`name`),
  KEY `object_product_category_id` (`category_id`),
  KEY `object_product_subcategory_id` (`subcategory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2538 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_product`
--

TRUNCATE TABLE `object_product`;
--
-- Άδειασμα δεδομένων του πίνακα `object_product`
--

INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(1270, 'Κύκνος Τομάτες Αποφλ Ολoκλ 400γρ', '', '', NULL, 25, 195, '0', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1271, 'Elite Φρυγανιές Ολικής Άλεσης 180γρ', '', '', NULL, 25, 210, '1', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1272, 'Trata Σαρδέλα Λαδιού 100γρ', '', '', NULL, 25, 174, '2', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1273, 'Μεβγάλ Τυρί Ημισκλ Μακεδ 420γρ', '', '', NULL, 25, 192, '3', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1274, 'Μινέρβα Χωριό Μαργαρίνη Με Ελαιόλαδο 250γρ', '', '', NULL, 25, 164, '4', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1275, 'Εύρηκα Λευκαντικό 60γρ', '', '', NULL, 22, 129, '5', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1276, 'Sprite 330ml', '', '', NULL, 23, 139, '7', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1277, 'Μετέωρα Ξύδι Λευκού Κρασιού 400ml', '', '', NULL, 25, 181, '8', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(1278, 'Μέλισσα Τορτελίνια Γεμ Τυρίων 250γρ', '', '', NULL, 25, 169, '9', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1279, 'Klinex Χλωρίνη Ultra Lemon 750ml', '', '', NULL, 22, 129, '10', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1280, 'Στεργίου Τσουρέκι 380γρ', '', '', NULL, 25, 193, '11', 'ee0022e7b1b34eb2b834ea334cda52e7', '0e1982336d8e4bdc867f1620a2bce3be'),
(1281, 'Sani Πάνα Ακρατ Sensitive N4 Xlarge 10τεμ', '', '', NULL, 24, 148, '12', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(1282, '3 Άλφα Ρεβύθια Χονδρά Εισαγωγής 500γρ', '', '', NULL, 25, 178, '13', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1283, 'Soupline Mistral Μαλακτικό Συμπ 28πλ', '', '', NULL, 22, 129, '14', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1284, 'Knorr Κύβοι Ζωμού Λαχανικών Extra Γεύση 147γρ', '', '', NULL, 25, 182, '15', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1285, 'Ζαγόρι Νερό 500ml', '', '', NULL, 23, 135, '16', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1286, 'Hansaplast Universal Αδιάβροχα 20τεμ', '', '', NULL, 24, 154, '17', '8e8117f7d9d64cf1a931a351eb15bd69', '1b59d5b58fb04816b8f6a74a4866580a'),
(1287, 'Friskies Άμμος Υγιεινής 5κιλ', '', '', NULL, 28, 223, '18', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1288, 'Everyday Σερβ Super/Ultra Plus Sens 10τεμ', '', '', NULL, 24, 158, '20', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1289, 'Έψα Λεμοναδα 232ml', '', '', NULL, 23, 139, '21', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1290, 'Pyrox Εντομ/Κο Σπιράλ 10τεμ', '', '', NULL, 22, 132, '22', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(1291, 'Fairy Υγρό Πιάτων Ultra Λεμόνι 900ml', '', '', NULL, 22, 121, '23', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1292, 'Δέλτα Γάλα Πλήρες 2λιτ', '', '', NULL, 25, 123, '24', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1293, 'Elite Φρυγανιές Σταριού Κουτί 250γρ', '', '', NULL, 25, 210, '25', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1294, 'Nestle Φαρίν Λακτέ 350γρ', '', '', NULL, 21, 128, '27', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(1295, 'Μπριζόλες Καρέ/Κόντρα Χοιρ Νωπές Εισ Μ/Ο ', '', '', NULL, 25, 217, '28', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(1296, 'Fissan Baby Κρέμα 50γρ', '', '', NULL, 21, 124, '29', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1297, 'Νουνού Γάλα Family Υψ Θερ Επ Light 1,5% 1,5λιτ', '', '', NULL, 25, 123, '30', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1298, 'Everyday Σερβ Extr Long/Ultra Plus Hyp 10τεμ', '', '', NULL, 24, 158, '31', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1299, 'Bailey\'s Irish Cream Λικέρ 700ml', '', '', NULL, 23, 137, '32', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1300, 'Nivea Γαλάκτ Καθαρ Ξηρ/ Ευαίσθ Επιδ 200ml', '', '', NULL, 24, 149, '33', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1301, 'Dr Beckmann Καθαρ Πλυν Ρούχ 250γρ', '', '', NULL, 22, 129, '34', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1302, 'Klinex Σπρέυ 4σε1 750ml', '', '', NULL, 22, 129, '35', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1303, 'Τεντούρα Κάστρο Λικέρ 500ml', '', '', NULL, 23, 137, '36', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1304, 'Ήλιος Πιπέρι Μαύρο Τριμμένο 40gr', '', '', NULL, 25, 196, '37', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(1305, 'Agrino Φασόλια Μέτρια 500γρ', '', '', NULL, 25, 178, '38', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1306, 'Αχλάδια Κρυσταλία Εισ Εξτρα', '', '', NULL, 25, 220, '39', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1307, 'Αρνιά Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ Συσκ/Νο', '', '', NULL, 25, 215, '40', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(1308, 'Overlay Κρέμα Επίπλων 250ml', '', '', NULL, 22, 129, '41', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1309, 'Μεταξά 3 Μπράντυ 350ml', '', '', NULL, 23, 137, '42', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1310, 'Fornet Καθαρ Φούρνου 300ml', '', '', NULL, 22, 129, '43', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1311, 'Pyrox Εντομ/Ko Σπιράλ 20τεμ', '', '', NULL, 22, 132, '44', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(1312, 'Axe Αποσμητικό Σπρέυ Africa 150ml', '', '', NULL, 24, 140, '45', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(1313, 'Roli Καθαριστικό Σκόνη Για Όλες Τις Επιφάνειες Λεμονί 500γρ', '', '', NULL, 22, 129, '46', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1314, 'Λακωνία Φυσικός Χυμός Πορτοκάλι 1λιτ', '', '', NULL, 23, 138, '47', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1315, 'Axe Αφροντούς Africa 400ml', '', '', NULL, 24, 125, '48', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1316, 'Red Bull Ενεργειακό Ποτό 250ml', '', '', NULL, 23, 139, '49', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1317, 'Becel Pro Activ Μαργαρίνη Σκαφ 250γρ', '', '', NULL, 25, 164, '50', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1318, 'Μπριζόλες Καρέ/Κόντρα Χοιρ Νωπές Ελλ Μ/Ο ', '', '', NULL, 25, 217, '52', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(1319, 'Κανάκι Σφολιατ Χωρ Στρ Κουρού 450γρ', '', '', NULL, 25, 172, '53', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1320, 'Fissan Baby Ενυδατική κρέμα 150 ml', '', '', NULL, 21, 124, '54', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1321, 'Regilait Γάλα Αποβ/Νο Σε Σκόνη 250γρ', '', '', NULL, 21, 124, '55', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1322, 'Pescanova Μπακαλιαράκια 600γρ', '', '', NULL, 25, 203, '57', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1323, 'Maggi Κύβοι Ζωμού Λαχανικών 6λιτ 12τεμ', '', '', NULL, 25, 182, '58', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1324, 'Pampers Πάνες Μωρού Premium Pants Nο 4 9-15κιλ 38τεμ', '', '', NULL, 21, 122, '59', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1325, 'Nivea Black/White Invisible 48h Rollon 50ml', '', '', NULL, 24, 140, '60', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(1326, 'Moscato D\'Αsti Casarito Κρασί 750ml', '', '', NULL, 23, 136, '61', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1327, 'Calliga Demi Sec Ροζέ Οίνος 750ml', '', '', NULL, 23, 136, '63', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1328, 'Monster Energy Drink 500ml', '', '', NULL, 23, 139, '64', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1329, 'Fissan Baby Bagnetto Υποαλ Σαμπουάν/Αφρόλ 500ml', '', '', NULL, 21, 139, '65', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1330, 'Dove Αφροντούς Deep Nour 500ml', '', '', NULL, 24, 125, '66', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1331, 'Γιώτης Μπισκοτόκρεμα 300γρ', '', '', NULL, 21, 128, '67', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(1332, 'Pampers Πάνες Premium Care Nο 3 5-9 κιλ 20τεμ', '', '', NULL, 21, 122, '68', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1333, 'Neomat Total Eco Απορ Σκον 14πλ 700γρ', '', '', NULL, 22, 121, '69', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1334, 'Γιώτης Κορν Φλάουρ 200γρ', '', '', NULL, 25, 165, '70', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1335, 'Φάγε Γιαούρτι Αγελαδίτσα 4% 3χ200γρ', '', '', NULL, 25, 126, '71', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1336, 'Maggi Πουρές Χ Γλουτ 250γρ', '', '', NULL, 25, 198, '72', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1337, 'Finish Αποσκλ/Κο Αλάτι Πλυν 2,5κιλ', '', '', NULL, 22, 129, '73', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1338, 'Svelto Gel Υγρό Πιάτων Λεμόνι 500ml', '', '', NULL, 22, 121, '74', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1339, 'Del Monte Κομπόστα Ανανά Φέτες 565γρ', '', '', NULL, 25, 174, '75', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1340, 'Κολοκυθάκια Εγχ', '', '', NULL, 25, 219, '76', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1341, 'Μακβελ Μακαρόνια Σπαγγέτι No 10 500γρ', '', '', NULL, 25, 169, '77', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1342, 'Quaker Τραγανές Μπουκ Σοκολ Υγείας 375γρ', '', '', NULL, 25, 200, '78', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1343, 'Ferrero Kinder Αυγό Εκπλ Χ Γλουτ 3τ 60γρ', '', '', NULL, 25, 198, '79', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1344, 'Ίον Σοκοφρέτα Μίνι Σακουλάκι 210γρ', '', '', NULL, 25, 166, '80', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1345, 'Kellogg\'s Δημητριακά Choco Pops Chocos 500γρ', '', '', NULL, 25, 200, '81', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1346, 'Παλίρροια Ντολμαδάκια Γιαλαντζί 280γρ', '', '', NULL, 25, 174, '82', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1347, 'Φάγε Total Γιαούρτι 5% Φάγε 3Χ200γρ', '', '', NULL, 25, 126, '83', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1348, 'Johnson\'s Baby Λοσιόν Bedtime 300ml', '', '', NULL, 21, 124, '84', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1349, 'Κανάκι Pizza Special 3 Χ 460γρ', '', '', NULL, 25, 171, '85', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa'),
(1350, 'Κύκνος Τοματοπολτός 410γρ', '', '', NULL, 25, 183, '86', 'ee0022e7b1b34eb2b834ea334cda52e7', '5aba290bf919489da5810c6122f0bc9b'),
(1351, 'Κρασί Της Παρέας Ροζέ Κοκκινέλι 1λιτ', '', '', NULL, 23, 136, '87', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1352, 'Quaker Τραγ Μπουκ 4 Ξηροί Καρποί 375γρ', '', '', NULL, 25, 200, '88', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1353, 'Μεβγάλ Φέτα Vacuum 400γρ', '', '', NULL, 25, 192, '89', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1354, 'Pedigree Rodeo Σκυλ/Φή Μοσχ 70γρ', '', '', NULL, 28, 224, '90', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1355, 'Μινέρβα Ελαιόλαδο 1λιτ', '', '', NULL, 25, 177, '91', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1356, 'Γιώτης Αλεύρι Για Όλες Τις Χρήσεις 1κιλ', '', '', NULL, 25, 161, '92', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1357, 'Babylino Πάνες Μωρού Sensitive 16+ κιλ No 6 15τεμ', '', '', NULL, 21, 122, '93', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1358, 'Orzene Σαμπουάν Μπύρας Κανον 400ml', '', '', NULL, 24, 125, '94', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1359, 'Dettol Κρεμ Sensitive Αντ/κο 750ml', '', '', NULL, 26, 221, '95', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(1360, 'Everyday Σερβ Maxi Nig/Ultra Plus Sens 18τεμ', '', '', NULL, 24, 158, '96', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1361, 'Dettol Κρεμοσάπουνο 250ml', '', '', NULL, 24, 156, '97', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1362, 'Εβόλ Γάλα Παστερ Διαλεχτο 3,7% Λ 1λιτ', '', '', NULL, 25, 123, '98', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1363, 'Νουνού Frisogrow Γάλα 800γρ', '', '', NULL, 21, 123, '99', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1364, 'La Vache Qui Rit Τυροβουτιές 4Χ35γρ', '', '', NULL, 25, 192, '100', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1365, 'Πορτοκ Βαλέντσια Εγ Χυμ Συσκ/Να', '', '', NULL, 25, 220, '101', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1366, 'Αττική Μέλι 250γρ', '', '', NULL, 25, 199, '102', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(1367, 'Klinex Καθαριστικό Τουαλέτας Block Ροζ Μανόλια 55γρ', '', '', NULL, 22, 129, '103', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1368, 'Libero Swimpants Πάνες Small 7-12κιλ 6τεμ', '', '', NULL, 21, 122, '104', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1369, 'Scotch Brite Σφουγγ Κουζ Γίγας Αντιβ', '', '', NULL, 22, 133, '105', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1370, 'Άριστον Αλάτι Ιμαλαΐων Φιάλη 400γρ', '', '', NULL, 25, 196, '106', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(1371, 'Εύρηκα Σκόνη Antikalk 54γρ', '', '', NULL, 22, 121, '107', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1372, 'Όλυμπος Γιαούρτι Στραγγιστό 10% 1κιλ', '', '', NULL, 25, 126, '108', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1373, 'Nestle Fitness Dark Chocolate 375γρ', '', '', NULL, 25, 200, '109', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1374, 'Όλυμπος Γάλα Επιλεγμ. 3,7% Λ 1,5λιτ', '', '', NULL, 25, 123, '110', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1375, 'Μάσκες Προστασ Προσώπου 50τεμ', '', '', NULL, 27, 222, '200', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(1376, 'Μπανάνες Chiquita Εισ', '', '', NULL, 25, 220, '112', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1377, 'Pampers Prem Care No5 11-18κιλ 30τεμ', '', '', NULL, 21, 122, '113', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1378, 'Jacobs Καφές Φίλτρου Εκλεκτός 250γρ', '', '', NULL, 25, 173, '114', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1379, 'Ροδόπη Γιαούρτι Πρόβειο 240γρ', '', '', NULL, 25, 126, '115', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1380, 'Καλλιμάνης Γλώσσα Φιλέτο 595γρ', '', '', NULL, 25, 203, '118', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1381, 'Μελιτζάνες Φλάσκες Εισ', '', '', NULL, 25, 219, '119', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1382, 'Παπαδοπούλου Caprice Ν6 400γρ', '', '', NULL, 25, 207, '120', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(1383, 'Gillette Fusion 5 Proglide Ξυρ Μηχ+Ανταλ', '', '', NULL, 24, 146, '121', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1384, 'Pampers Πάνες Premium Care Νο 2 4-8κιλ 23τεμ', '', '', NULL, 21, 122, '122', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1385, 'Tuboflo Αποφρακτικό Σκόνη Φάκελ 100g', '', '', NULL, 22, 129, '123', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1386, 'Αλλατίνη Κέικ Βανίλια Με Κακάο 400γρ', '', '', NULL, 25, 170, '124', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(1387, 'Baby Care Μωρόμαντηλα Sensitive 63τεμ', '', '', NULL, 21, 127, '125', '8016e637b54241f8ad242ed1699bf2da', '92680b33561c4a7e94b7e7a96b5bb153'),
(1388, 'Γιώτης Φρουτόκρεμα 5 Φρούτα 300γρ', '', '', NULL, 21, 128, '126', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(1389, 'Πατάτες  Εισ Κατ Α Ε/Ζ ', '', '', NULL, 25, 219, '127', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1390, 'Neomat Υγρό Απορρυπαντικό Ρούχων Τριαντάφυλλο 62μεζ', '', '', NULL, 22, 121, '128', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1391, 'Μέλισσα Μακαρόνια Σπαγγετίνη Νο 10 500γρ', '', '', NULL, 25, 169, '129', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1392, 'Gelita Ζελατίνη Φύλλα 20γρ', '', '', NULL, 25, 165, '130', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1393, 'Barilla Μακαρόνια Ν5 500γρ', '', '', NULL, 25, 169, '131', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1394, 'Ω3 Αυγά Αμερικ Γεωργ Σχολής 6τ Large 63-73γρ', '', '', NULL, 25, 163, '132', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(1395, 'Philadelphia Τυρί 200γρ', '', '', NULL, 25, 192, '133', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1396, 'Γιώτης Σοκολάτα Sweet/Balance Χ Γλουτ 100γρ', '', '', NULL, 25, 198, '134', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1397, 'Σαρδέλλες Νωπές Καθαρ Απεντ/νες Ελλην Μεσογ Συσκ/Νες', '', '', NULL, 25, 212, '135', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(1398, 'Pampers Πάνες Μωρού 31τεμ', '', '', NULL, 21, 122, '136', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1399, 'Ferrero Kinder Pingui Σοκ/Γκοφρ 4X124γρ', '', '', NULL, 25, 166, '137', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1400, 'Rilken Gel Χτεν Clubber 150ml', '', '', NULL, 24, 153, '138', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(1401, 'Alpro Ρόφημα Αμύγδαλο Χ Γλουτ 1λιτ', '', '', NULL, 25, 198, '139', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1402, 'Maggi Barilla Spaghettoni No7 500γρ', '', '', NULL, 25, 169, '140', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1403, 'Johnson\'s Baby Μπατονέτες Βαμβ 100τεμ', '', '', NULL, 21, 124, '141', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1404, 'Chupa Chups Melody Γλυφιτζ 12γρ', '', '', NULL, 25, 180, '142', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(1405, 'Elnett Λακ Βαμμένα Μαλλ Satin 200ml', '', '', NULL, 24, 150, '144', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1406, 'Bic Ξυρ Μηχ Classic 10τεμ', '', '', NULL, 24, 146, '145', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1407, 'Kellogg\'s Special Κ 375γρ', '', '', NULL, 25, 200, '146', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1408, 'Flokos Καλαμάρια Φυσ Χυμού 370γρ', '', '', NULL, 25, 174, '147', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1409, 'Δέλτα Mmmilk Γάλα Οικογεν Χαρτ 1,5% 1,5λιτ', '', '', NULL, 25, 123, '148', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1410, 'Babylino Sensitive No1 2-5κιλ 28τεμ', '', '', NULL, 21, 122, '149', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1411, 'Γιώτης Κουβερτούρα Γαλακ Σταγ 100γρ', '', '', NULL, 25, 165, '150', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1412, 'Tsakiris Πατατάκια Αλάτι 72γρ', '', '', NULL, 25, 190, '151', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(1413, 'Λεβέτι Κασέρι Ποπ Φέτες 175γρ', '', '', NULL, 25, 192, '152', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1414, 'Χρυσή Ζύμη Στριφταρi Τυρί Μυζ Μακεδον 850γρ', '', '', NULL, 25, 205, '153', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1415, 'Ντομάτες Εγχ Υδροπ Α ', '', '', NULL, 25, 219, '154', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1416, 'Creta Farms Λουκαν Χωριατ Μυρ Χ Γλουτ 400γρ', '', '', NULL, 25, 198, '155', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1417, 'Frulite Φρουτοπ Καροτ/Πορτ/Μαγκ 1λιτ', '', '', NULL, 23, 138, '156', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1418, 'Finish Υγρό Απορρυπαντικό Πλυντηρίου Πιάτων Lemon 1λιτ', '', '', NULL, 22, 121, '157', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1419, 'Iglo Κροκέτες Ψαριών Κατεψυγμένες 300γρ', '', '', NULL, 25, 203, '159', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1420, 'Pummaro Χυμός Τομάτα 500γρ', '', '', NULL, 25, 195, '160', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1421, 'Φλώρινα Ξυνό Νερό 1λιτ', '', '', NULL, 23, 135, '161', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1422, 'Life Φρουτοποτό Πορτ/Μηλ/Καρ 400ml', '', '', NULL, 23, 138, '162', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1423, 'Δέλτα Φυσικ Χυμός Smart Ροδ Βερ200ml', '', '', NULL, 23, 138, '163', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1424, 'Δέλτα Milko Κακάο 450ml', '', '', NULL, 25, 123, '165', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1425, 'Overlay Ultra Spray Λιποκαθαριστής Λεμόνι 650ml', '', '', NULL, 22, 129, '166', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1426, 'Δέλτα Advance Επιδ Μπαν/Μηλο 2Χ150γρ', '', '', NULL, 25, 126, '167', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1427, 'Κατσίκια Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ  Συσκ/Νο', '', '', NULL, 25, 216, '168', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(1428, 'Όλυμπος Γάλα Επιλεγμ 1,5% Λ 1,5λιτ', '', '', NULL, 25, 123, '169', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1429, 'Βεμ Ρώσικη Σαλάτα 250γρ', '', '', NULL, 25, 201, '170', 'ee0022e7b1b34eb2b834ea334cda52e7', '4f205aaec31746b89f40f4d5d845b13e'),
(1430, 'Κύκνος Τοματά Τριμμενη 500γρ', '', '', NULL, 25, 195, '171', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1431, 'Κύκνος Τομάτα Ψιλ 400γρ', '', '', NULL, 25, 195, '173', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1432, 'Alfa Τριγωνάρια Με Τυρί Ανεβατο Κατεψυγμένα 750γρ', '', '', NULL, 25, 205, '174', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1433, 'Μεβγάλ Γάλα Αγελ Λευκό Πλήρες 3,5% 500ml', '', '', NULL, 25, 123, '175', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1434, 'Μεβγάλ Στραγγιστό Γιαούρτι 2% 1κιλ', '', '', NULL, 25, 126, '176', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1435, 'Εν Ελλάδι Γαλοπούλα Καπνιστή Φέτες 160γρ', '', '', NULL, 25, 162, '177', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(1436, 'Μεβγάλ Ζελέ Φράουλα 3Χ150γρ', '', '', NULL, 25, 167, '178', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(1437, 'Μεβγάλ High Protein Choc Drink 242ml', '', '', NULL, 25, 123, '179', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1438, 'Μινέρβα Χωριό Φέτα Ποπ Βιολ Άλμη 350γρ', '', '', NULL, 25, 192, '180', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1439, 'Παπουτσάνη Σαπούνι Πρασ Παραδ 125γρ', '', '', NULL, 24, 156, '181', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1440, 'Εύρηκα Υγρό Απορρυπαντικό Ρούχων Μασσαλίας 30μεζ', '', '', NULL, 22, 121, '182', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1441, 'Softex Χαρτοπετσέτες Λευκές 30x30 56τεμ', '', '', NULL, 22, 130, '183', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1442, 'Lipton Ice Tea Green No Sugar 500ml', '', '', NULL, 23, 138, '184', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1443, 'Asti Martini Αφρώδης Οίνος 0,75λιτ', '', '', NULL, 23, 136, '186', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1444, 'Fego Καμφορά Πλακέτα 6τεμ', '', '', NULL, 22, 132, '187', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(1445, 'Όλυμπος Ταχίνι Χ Γλουτ 300γρ', '', '', NULL, 25, 198, '188', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1446, 'Χρυσή Ζύμη Σπιτικά Τριγων Φέτα Κατικ 750γρ', '', '', NULL, 25, 205, '189', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1447, 'Χρυσή Ζύμη Μπουγάτσα Θεσσαλονίκης Με Πραλίνα 450γρ', '', '', NULL, 25, 205, '190', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1448, 'Χρυσή Ζύμη Λουκανικοπιτάκια Κατεψυγμένα Κουρού 800γρ', '', '', NULL, 25, 205, '191', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1449, 'Swiffer Πανάκια Αντ/Κα 16τεμ', '', '', NULL, 22, 129, '192', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1450, 'Coca Cola 1,5λιτ', '', '', NULL, 23, 139, '193', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1451, 'Heineken Μπύρα 6X330ml', '', '', NULL, 23, 134, '194', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1452, 'Coca Cola 6Χ330ml', '', '', NULL, 23, 139, '195', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1453, 'Μπάρμπα Στάθης Αρακάς 450γρ', '', '', NULL, 25, 204, '196', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(1454, 'Vanish Σαμπουάν Χαλιών 500ml', '', '', NULL, 22, 129, '197', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1455, 'OralB Οδ/Mα 1/2/3 75ml', '', '', NULL, 24, 160, '198', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1456, 'Everyday Σερβ/Κια XL All Cotton 24τεμ', '', '', NULL, 24, 158, '199', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1457, 'EveryDay Natural Fresh Υγρό Ευαίσθ Περιοχ 200ml', '', '', NULL, 24, 158, '201', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1458, 'Χρυσή Ζύμη Χωριάτικο Φυλλο Κατεψυγμένο 700γρ', '', '', NULL, 25, 172, '203', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1459, 'Nescafe Cappuccino 10φακ 140γρ', '', '', NULL, 25, 173, '204', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1460, 'Σουρωτή Ανθρακούχο Φυσικό Νερό 250ml', '', '', NULL, 23, 135, '205', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1461, 'Skip Υγρό Απορρυπαντικό Ρούχων Spring Fresh 42μεζ', '', '', NULL, 22, 121, '206', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1462, 'Υφαντής Λουκάνικα Βιέννα Αποφλ Χ Γλουτ 250γρ', '', '', NULL, 25, 198, '207', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1463, 'Fissan Baby Σαπούνι 90γρ', '', '', NULL, 21, 198, '208', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1464, 'Nutricia Biskotti 180γρ', '', '', NULL, 21, 128, '209', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(1465, 'Canderel Υποκατάστατο Ζάχαρης 120 Δισκία', '', '', NULL, 25, 208, '210', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(1466, 'Ava Υγρό Πιάτων Perle Classic 900ml', '', '', NULL, 22, 121, '211', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1467, 'Ava Υγρό Πιάτων Action Λευκο Ξυδι Αντλια 650ml', '', '', NULL, 22, 121, '213', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1468, 'Gilette Ξυρ Μ/Χ Blue II Slalom 5τεμ', '', '', NULL, 24, 146, '214', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1469, 'Ferrero Kinder Αυγό Εκπλ Χ Γλουτ 20γρ', '', '', NULL, 25, 198, '215', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1470, 'Garnier Νερό Ντεμακιγιάζ Micellaire 100ml', '', '', NULL, 24, 149, '216', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1471, 'Friskies Active Σκυλ/Φή Ξηρά Vital 1,5κιλ', '', '', NULL, 28, 224, '217', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1472, 'Νίκας Λουκάν Φρανκ Γαλοπ Χ Γλ 280γρ', '', '', NULL, 25, 198, '218', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1473, 'Palette Λακ Πολύ Δυνατή 300ml', '', '', NULL, 24, 150, '219', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1474, 'Johnson\'s Baby Oil Ενυδατικό Λάδι, 300ml', '', '', NULL, 21, 124, '220', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1475, '3 Άλφα Φασόλια Μέτρια 500γρ', '', '', NULL, 25, 178, '221', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1476, 'Pampers Πάνες Βρακάκι Νο 5 11-18κιλ 15τεμ', '', '', NULL, 21, 122, '222', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1477, 'Knorr Ζωμός Κότας Σε Κόκκους Extra Γεύση 88γρ', '', '', NULL, 25, 182, '223', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1478, 'Nivea Μάσκα Μέλι για Ξηρ/Ευαίσθ Επιδ 2x7,5ml', '', '', NULL, 24, 149, '224', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1479, 'Nivea Αφρόλουτρο Cream Care 750ml', '', '', NULL, 24, 125, '225', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1480, 'Lux Σαπούνι Soft/Creamy 125γρ', '', '', NULL, 24, 156, '226', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1481, 'Κατσίκια Νωπά Ελλην Γαλ Ολοκλ Μ/Κ Μ/Σ', '', '', NULL, 25, 216, '227', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(1482, 'Zest Familia Λουκανικοπιτάκια 800γρ', '', '', NULL, 25, 172, '228', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1483, 'Agrino Ρύζι Φάνσυ Ελλάδας 1κιλ', '', '', NULL, 25, 186, '229', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1484, 'Syoss Hairspray Max Ultra Strong 400ml', '', '', NULL, 24, 150, '230', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1485, 'Κοντοβερός Σολωμός Φιλέτο Chum 595γρ', '', '', NULL, 25, 203, '231', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1486, 'Υφαντής Πίτσα Rock N Roll 3Χ460γρ', '', '', NULL, 25, 171, '232', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa'),
(1487, 'Nan Optipro 4 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 21, 171, '234', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1488, 'Γιώτης Κρέμα Ζαχαροπλ Βανίλια 117γρ', '', '', NULL, 25, 165, '235', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1489, 'Pescanova Μπακαλιάρος Φιλέτο 400γρ', '', '', NULL, 25, 203, '236', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1490, 'Ήπειρος Φέτα Ποπ Σε Άλμη 400γρ', '', '', NULL, 25, 192, '237', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1491, 'Tena Lady Maxi 12τεμ', '', '', NULL, 24, 158, '238', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1492, 'Νουνού Gouda Φέτες 200γρ', '', '', NULL, 25, 192, '239', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1493, 'Καλλιμάνης Γαρίδες Αποφλ Μικρές 425γρ', '', '', NULL, 25, 203, '240', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1494, 'Aim Οδοντόβ Μέτρια Antiplaque', '', '', NULL, 24, 147, '241', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(1495, 'Εβόλ Γάλα Παστερ Κατσικ Βιολ 590ml', '', '', NULL, 25, 123, '242', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1496, 'Παπαδοπούλου Τριμμα Φρυγανιας Τριμμα 180γρ', '', '', NULL, 25, 210, '243', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1497, 'Μινέρβα Χωριό Ορεινές Περιοχές Ελαιόλαδο Παρθένο 2λιτ', '', '', NULL, 25, 177, '244', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1498, 'Μέλισσα Σπαγγέτι Ν6 500γρ', '', '', NULL, 25, 169, '245', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1499, 'Pescanova Μύδια Ψίχα 450γρ', '', '', NULL, 25, 203, '246', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1500, 'Όλυμπος Γάλα Κατσικίσιο Hπ 3,5% 1λιτ', '', '', NULL, 25, 123, '247', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1501, 'Misko Μακαρόνια Σπαγγέτι Ν3 500γρ', '', '', NULL, 25, 169, '248', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1502, 'Atrix Κρέμα Χερ Intens Χαμομήλι 150ml', '', '', NULL, 24, 155, '249', '8e8117f7d9d64cf1a931a351eb15bd69', 'fefa136c714945a3b6bcdcb4ee9e8921'),
(1503, 'Ροδόπη Γάλα Χ Λακτόζη 1λιτ', '', '', NULL, 25, 198, '250', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1504, 'Μεβγάλ Harmony 1% Ροδακινο 3Χ200γρ', '', '', NULL, 25, 126, '251', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1505, 'Τράτα Γαύρος Φιλέτο Κατεψυγμένος 400γρ', '', '', NULL, 25, 203, '252', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1506, 'Sprite Αναψυκτικό 1,5λιτ', '', '', NULL, 23, 139, '253', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1507, 'Klinex Χλωρίνη Ultra Lemon 1250ml', '', '', NULL, 22, 129, '254', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1508, 'Afroso Wc Block Τριαντ 2Χ40ΓΡ', '', '', NULL, 22, 129, '257', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1509, 'Fytro Ζάχαρη Καστανή Ακατέργαστη 500γρ', '', '', NULL, 25, 208, '258', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(1510, 'Pillsbury Ζύμη Φρέσκια Σφολιάτας 700γρ', '', '', NULL, 25, 172, '259', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1511, 'Friskies Adult Ξηρά Γατ/Φή Βοδ/Συκ/Κοτ 400γρ', '', '', NULL, 28, 223, '260', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1512, 'Libresse Σερβ Goodnight Clip 10τεμ', '', '', NULL, 24, 158, '261', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1513, 'Παυλίδης Μέρεντα Με Φουντούκι 570γρ', '', '', NULL, 25, 199, '263', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(1514, 'Τσίχλες Trident Δυόσμος 8γρ', '', '', NULL, 25, 180, '264', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(1515, 'Lipton Ice Tea Instant Λεμονι 125γρ', '', '', NULL, 23, 138, '265', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1516, 'Lenor Gold Orchid 56μεζ 1,4λιτ', '', '', NULL, 22, 129, '266', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1517, 'Pantene Μάσκα Μαλ Αναδόμησης 2λεπτ 300ml', '', '', NULL, 24, 143, '267', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(1518, 'Pampers Πάνες Βρακάκι Νο 6 15+κιλ 14τεμ', '', '', NULL, 21, 122, '268', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1519, 'Παυλίδης Σοκολάτα Υγείας Αμύγδ 100γρ', '', '', NULL, 25, 166, '269', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1520, 'Ace Gentile Ενισχυτικό Πλύσης 2lt', '', '', NULL, 22, 129, '270', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1521, 'Barilla Πένες Rigate Νο 73 500γρ', '', '', NULL, 25, 169, '271', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1522, 'Omino Bianco Υγρό Blacκ Wash 25πλ 1,5λιτ', '', '', NULL, 22, 121, '272', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1523, 'Sanitas Αντικολλητικό Χαρτί 8μετ', '', '', NULL, 22, 133, '273', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1524, 'Delica Χαρτομάντηλα Αυτοκινήτου Λευκά Big 150τεμ', '', '', NULL, 22, 130, '274', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1525, 'Cif Άσπρο Creαm 500ml', '', '', NULL, 22, 129, '275', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1526, 'Cif Λεμόνι Creαm 500ml', '', '', NULL, 22, 129, '276', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1527, 'Colgate Οδ/Μα Sensation Whiten.75ml', '', '', NULL, 24, 160, '277', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1528, 'Klinex Υγρό Καθαρισμού Μπάνιου Spray 750ml', '', '', NULL, 22, 129, '278', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1529, 'Όλυμπος Γιαούρτι Στραγγιστό 2% Λιπ 1κιλ', '', '', NULL, 25, 126, '279', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1530, 'Κορπή Φυσικό Μεταλλικό Νερό 500ml', '', '', NULL, 23, 135, '281', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1531, 'Nescafe Classic Στιγμιαίος Καφές 100γρ', '', '', NULL, 25, 173, '282', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1532, 'Χρυσή Ζύμη Τυροπιτάκια Κουρου 920γρ', '', '', NULL, 25, 205, '283', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1533, 'Babylino Πάνες Μωρού Sensitive Nο7 17+ κιλ 14τεμ', '', '', NULL, 21, 122, '284', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1534, 'Calgon Αποσκ/Κο Νερού Σκόνη 950γρ', '', '', NULL, 22, 129, '285', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1535, 'Ferrero Kinder Bueno Σοκ/Τα 43γρ', '', '', NULL, 25, 166, '286', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1536, 'Nesquik Δημητριακά Extra Choco Waves 375γρ', '', '', NULL, 25, 200, '287', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1537, 'Κιχί Πίτα Με Πράσο Ταψί Κατεψυγμένο 800γρ', '', '', NULL, 25, 205, '288', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1538, 'Soflan Υγρό Απορ Ρούχ Μαλλ/Ευαισθ 950ml', '', '', NULL, 22, 129, '289', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1539, 'Sanitas Αλουμινόχαρτο 10μετ', '', '', NULL, 22, 133, '290', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1540, 'Creta Farm Λουκάνικα Τρικάλων Με Πράσο 400γρ', '', '', NULL, 25, 162, '291', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(1541, 'Εν Ελλάδι Μπέικον Καπνιστό Σε Φέτες 100γρ', '', '', NULL, 25, 162, '292', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(1542, 'Donna Οινόπνευμα Καθαρό 245ml', '', '', NULL, 26, 221, '293', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(1543, 'Biofarma Παστέλι Βιολ Με Σουσάμι 30gr', '', '', NULL, 25, 167, '294', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(1544, 'Λουξ Πορτοκαλάδα Μπλε 330ml', '', '', NULL, 23, 139, '295', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1545, 'Neomat Total Eco Απορ Τριαν 14πλ 700γρ', '', '', NULL, 22, 121, '296', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1546, '3 Αλφα Ρύζι Καρολίνα 500γρ', '', '', NULL, 25, 186, '297', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1547, 'Nestle Cookie Crispies 375γρ', '', '', NULL, 25, 200, '298', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1548, 'Nescafe Dolce Gusto Cappuccino 16 Καψ', '', '', NULL, 25, 173, '299', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1549, 'Pampers Active Baby No5 11-16κιλ 51τεμ', '', '', NULL, 21, 122, '300', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1550, 'Agrino Ρύζι Λαΐς Καρολίνα 500γρ', '', '', NULL, 25, 186, '301', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1551, 'Νέα Φυτίνη Φυτικό Μαγειρικό Λίπος 400γρ', '', '', NULL, 25, 164, '303', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1552, 'Ρούσσος Νάμα Κρασί Ερυθρό Γλυκο 375ml', '', '', NULL, 23, 136, '304', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1553, 'OralB Οδ/Μα Pro Exp Prof Prot 75m', '', '', NULL, 24, 160, '305', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1554, 'Babylino Πάνες Μωρού Sensitive 11 - 25κιλ No 5 18τεμ', '', '', NULL, 21, 122, '306', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1555, 'Μεβγάλ Harmony Gourm ΑλατΚαραμ /Dark Choc 165γρ', '', '', NULL, 25, 126, '307', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1556, 'Γιώτης Κρέμα Παιδική Φαρίν Λακτέ 300γρ', '', '', NULL, 21, 128, '308', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(1557, 'Αύρα Φυσικό Μεταλλικό Νερό 500ml', '', '', NULL, 23, 135, '309', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1558, 'Μάσκες Προστ Προσώπου 50τεμ Non-Woven', '', '', NULL, 27, 222, '310', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(1559, 'Zewa Χαρτί Υγείας Deluxe Χαμομήλι 3 Φύλλα 8τεμ 768γρ', '', '', NULL, 22, 130, '311', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1560, 'Λουξ Λεμονάδα 330ml', '', '', NULL, 23, 139, '312', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1561, 'Nutricia Biskotti Ζωάκια 180γρ', '', '', NULL, 21, 128, '313', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(1562, 'Dewar\'s Ουίσκι 0,7λιτ', '', '', NULL, 23, 137, '314', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1563, 'Pampers Premium Care No 5 11-18κιλ 44τεμ', '', '', NULL, 21, 122, '315', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1564, 'Omo Bianco Υγρό Αφρ Μασ Παραδοσ 30πλ', '', '', NULL, 22, 121, '316', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1565, 'Ίον Κακάο 125γρ', '', '', NULL, 25, 185, '317', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(1566, 'Μακεδονικό Ταχίνι Σε Βάζο 300γρ', '', '', NULL, 25, 199, '318', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(1567, 'Hellmann\'s Μαγιονέζα 225ml', '', '', NULL, 25, 206, '319', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1568, 'Becel Μαργαρίνη Light 40% Λιπ 250γρ', '', '', NULL, 25, 164, '320', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1569, 'Colgate Οδ/Μα Total Original 75ml', '', '', NULL, 24, 160, '321', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1570, 'Pillsbury Σάλτσα Για Πίτσα 200γρ', '', '', NULL, 25, 206, '322', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1571, 'Δομοκού Τυρί Κατίκι Ποπ 200g', '', '', NULL, 25, 192, '323', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1572, 'Νουνού Γάλα Family 3,6% 1,5λιτ', '', '', NULL, 25, 123, '324', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1573, 'Βιτάμ Μαργαρίνη Soft Σκαφ 500γρ', '', '', NULL, 25, 164, '325', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1574, 'Coca Cola 1λιτ', '', '', NULL, 23, 139, '326', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1575, 'Coca Cola Zero 1λιτ', '', '', NULL, 23, 139, '327', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1576, 'Zewa Χαρτί Κουζίνας Με Σχέδια 2τεμ', '', '', NULL, 22, 130, '328', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1577, 'Μεβγάλ Only 0% Et Συρτ 3Χ200γρ', '', '', NULL, 25, 126, '329', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1578, 'Amita Motion Φυσικός Χυμός 330ml', '', '', NULL, 23, 138, '330', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1579, 'Klinex Χλωρίνη Lemon 2λιτ', '', '', NULL, 22, 129, '331', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1580, 'Άλτις Ελαιόλαδο Δοχείο 4λιτ', '', '', NULL, 25, 177, '332', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1581, 'Overlay Επίπλων Σπρέυ 250ml', '', '', NULL, 22, 129, '333', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1582, 'Cesar Clasicos Σκυλ/Φή Μοσχ 150γρ', '', '', NULL, 28, 224, '334', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1583, 'Δέλτα Milko Γάλα Παστερ 250ml', '', '', NULL, 25, 123, '335', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1584, 'Δέλτα Milko Κακάο 500ml', '', '', NULL, 25, 123, '336', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1585, 'Δέλτα Vitaline 0% Τρ Φρουτ/Δημ 380γρ', '', '', NULL, 25, 126, '337', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1586, 'Jacobs Καφές Φίλτρου Εκλεκτός 500γρ', '', '', NULL, 25, 173, '338', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1587, 'Becel Pro Activ Ρόφημα Γιαουρ Φράουλα 4Χ100γρ', '', '', NULL, 25, 126, '339', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1588, 'Ζαναέ Ντολμαδάκια 280γρ', '', '', NULL, 25, 174, '340', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1589, 'Omo Υγρό Απορ Τροπ Λουλ 30πλ 1,95l', '', '', NULL, 22, 121, '341', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1590, 'Knorr Quick Soup Μανιτ Με Κρουτόν 36γρ', '', '', NULL, 25, 168, '342', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eef696c0f874603a59aed909e1b4ce2'),
(1591, 'Lactacyd Intimate Lotion Ευαίσθ Περιοχ 200ml', '', '', NULL, 24, 125, '343', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1592, 'Daκor Corned Beef Μοσχάρι 200γρ', '', '', NULL, 25, 174, '344', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1593, 'Αρνιά Νωπά Ελλην Γαλ Ολοκλ Χ/Κ Χ/Σ ', '', '', NULL, 25, 215, '345', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(1594, 'Μπούτι Χοιρινό Α/Ο Νωπό Εισ Χ/Δ ', '', '', NULL, 25, 217, '346', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(1595, 'Λάπα Βόειου Α/Ο Νωπή Εισ', '', '', NULL, 25, 218, '347', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1596, 'Μελιτζάνες Φλάσκες Εγχ', '', '', NULL, 25, 219, '348', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1597, 'Πατάτες  Ελλ Κατ Α Ε/Ζ', '', '', NULL, 25, 219, '349', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1598, 'Friskies Adult Ξηρά Γατ/Φή Κουν/Κοτ/Λαχ 400γρ', '', '', NULL, 28, 223, '351', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1599, 'Κρι Κρι Σπιτικό Επιδόρπιο Γιαουρτιού 2% 1κιλ', '', '', NULL, 25, 126, '352', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1600, 'Bonne Maman Μαρμελάδα Φρα Χ Γλ.370γρ', '', '', NULL, 25, 198, '353', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1601, 'Wella Flex Σπρέυ Ultra Strong 250ml', '', '', NULL, 24, 150, '354', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1602, 'Γιώτης Μαγιά 3φακ 8γρ', '', '', NULL, 25, 165, '355', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1603, 'Friskies Σκυλ/Φή Βοδ/Κοτ/Λαχ 400γρ', '', '', NULL, 28, 224, '356', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1604, 'La Vache Qui Rit Τυρί 8τμχ 140γρ', '', '', NULL, 25, 192, '357', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1605, 'Pedigree Σκυλ/Φή Πατέ Κοτοπ/Μοσχ 300γρ', '', '', NULL, 28, 224, '358', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1606, 'Purina Gold Gourmet Γατ/Φή Βοδ/Κοτ 85γρ', '', '', NULL, 28, 223, '359', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1607, 'Μεβγάλ Μανούρι 200γρ', '', '', NULL, 25, 192, '360', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1608, 'Johnson Βρέφικη Πουδρα Σωματος 200γρ', '', '', NULL, 21, 124, '361', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1609, 'Le Petit Marseillais Μάσκα Μαλλ Ξηρ 300ml', '', '', NULL, 24, 143, '362', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(1610, 'Nestle Fitness Bars Σοκολάτα 6Χ23,5γρ', '', '', NULL, 25, 200, '363', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1611, 'Johnson\'s 24η Κρ Ημ Essentials Hydr SPF15 50ml', '', '', NULL, 24, 149, '364', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af');
INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(1612, 'Μεβγάλ Παραδοσιακό Γιαούρτι Αγελαδ 220γρ', '', '', NULL, 25, 126, '365', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1613, 'Johnson\'s Baby Σαμπουάν 750ml', '', '', NULL, 21, 126, '366', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1614, 'L\'Oreal Σαμπ Elvive Color Vive Βαμμένα 400ml', '', '', NULL, 24, 125, '367', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1615, 'Elvive Color Vive Μάσκα Μαλ 300ml', '', '', NULL, 24, 143, '368', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(1616, 'Nivea Κρέμα 150ml', '', '', NULL, 24, 149, '369', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1617, 'Φάγε Τυρί Τριμμένο Gouda 200γρ', '', '', NULL, 25, 192, '370', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1618, 'Βέρμιον Νάουσα Κομπόστα Ροδάκινο 1κιλ', '', '', NULL, 25, 174, '371', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1619, 'Maltesers Κουφετάκια Σοκολ 37gr', '', '', NULL, 25, 166, '372', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1620, 'Νουνού Κρέμα Γάλακτος Πλήρης 330ml', '', '', NULL, 25, 176, '373', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(1621, 'Pantene Σαμπουάν Αναδόμησης 360ml', '', '', NULL, 24, 125, '374', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1622, 'Snickers Σοκολάτα 50γρ', '', '', NULL, 25, 166, '375', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1623, 'Μεβγάλ Harmony 1% Λεμ 3Χ200γρ', '', '', NULL, 25, 126, '376', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1624, 'Whiskas Γατ/Φή Κοτόπουλο 400γρ', '', '', NULL, 28, 223, '377', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1625, 'Champion Κρουασ Πραλίνα Φουντουκ 4X70γρ', '', '', NULL, 25, 189, '378', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1626, 'Aim Οδ/Μα Παιδ 2/6ετων 50ml', '', '', NULL, 24, 160, '379', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1627, 'Κριθαράκι Μίσκο Χονδρό 500γρ', '', '', NULL, 25, 169, '380', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1628, 'Becel Pro Activ Ρόφημα Με Γαλ 1,8% Λ 1λιτ', '', '', NULL, 25, 123, '381', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1629, 'Heineken Μπύρα Premium Lager 500ml', '', '', NULL, 23, 134, '383', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1630, 'Αγγούρια Εγχ', '', '', NULL, 25, 219, '384', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1631, 'Υφαντής Σαλάμι Αέρος Χ Γλουτ 100γρ', '', '', NULL, 25, 198, '385', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1632, 'Agrino Ρύζι Σουπέ Γλασέ 500γρ', '', '', NULL, 25, 186, '386', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1633, 'Noxzema Αποσμ Rollon Classic 50ml', '', '', NULL, 24, 140, '387', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(1634, 'Καραμολέγκος Ψωμί Τοστ Σταρένιο 680γρ', '', '', NULL, 25, 194, '388', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1635, 'Agrino Φασόλια Γίγαντες Ελέφαντες Καστοριάς Π.Γ.Ε. 500γρ', '', '', NULL, 25, 178, '389', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1636, 'Λάβδας Καραμέλες Βούτυρου 0% Ζαχαρ 32γρ', '', '', NULL, 25, 180, '390', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(1637, 'Παυλίδης Σοκολατα Υγειας Πορτοκ 100γρ', '', '', NULL, 25, 166, '391', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1638, 'Ροδάκινα Εγχ', '', '', NULL, 25, 220, '392', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1639, 'Barilla Σάλτσα Βασιλικος 400γρ', '', '', NULL, 25, 206, '393', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1640, 'Proderm Σαμπουάν/Αφρόλουτρο 1-3 400ml', '', '', NULL, 21, 206, '394', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1641, 'Philadelphia Τυρί 300γρ', '', '', NULL, 25, 192, '395', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1642, 'Quaker Νιφ Βρώμης Ολ Άλεσης 500γρ', '', '', NULL, 25, 200, '396', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1643, 'Νουνού Γάλα Εβαπορέ 170γρ', '', '', NULL, 25, 123, '397', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1644, 'Στήθος Φιλέτο Κοτ Ελλην. Νωπό Συσκ/Νο', '', '', NULL, 25, 214, '398', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(1645, 'Pantene Κρέμα Μαλλ Αναδόμησης 270ml', '', '', NULL, 24, 150, '399', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1646, 'Ίον Σοκολάτες Γάλακτος 70γρ', '', '', NULL, 25, 166, '400', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1647, 'EggPro Ροφ Πρωτεΐνης Φράουλα Χ Γλουτ 250ml', '', '', NULL, 25, 198, '401', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1648, 'Lay\'s Πατατάκια Ρίγανη150γρ', '', '', NULL, 25, 190, '402', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(1649, 'Pummaro Ψιλοκ Τοματ Κλασ 400γρ', '', '', NULL, 25, 195, '403', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(1650, 'Κάλας Αλάτι Θαλασσινό Κλασικό 400γρ', '', '', NULL, 25, 196, '404', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(1651, 'Lipton Χαμομήλι Φακ 10τεμΧ1γρ', '', '', NULL, 25, 185, '405', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(1652, 'Μεβγάλ Τριμμένο Κεφαλοτύρι 200γρ', '', '', NULL, 25, 192, '406', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1653, 'Everyday Σερβ Norm/Ultra Plus Sens 10τεμ', '', '', NULL, 24, 158, '407', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1654, 'Μεβγάλ Πολίτικο 2Χ150γρ', '', '', NULL, 25, 167, '408', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(1655, 'Klinex Advance Απορρυπαντικό Ρούχων Πλυντηρίου Με Χλώριο 2λιτ', '', '', NULL, 22, 121, '409', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1656, 'Τράτα Τόνος Φιλέτο 240γρ', '', '', NULL, 25, 203, '410', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1657, 'Πλωμάρι Ούζο 0,7λιτ', '', '', NULL, 23, 137, '411', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1658, 'Melissa Σιμιγδάλι Χονδρό 500γρ', '', '', NULL, 25, 161, '412', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1659, 'Scotch Brite Σφουγγαράκι Πράσ Κλασ 1τεμ', '', '', NULL, 22, 129, '413', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1660, 'Aim Οδ/μα White System 75ml', '', '', NULL, 24, 160, '414', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1661, 'Heineken Μπύρα 330ml', '', '', NULL, 23, 134, '1340', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1662, 'Μεβγάλ Harmony Gourmet Πορτοκ Νιφ Σοκ 165γρ', '', '', NULL, 25, 126, '416', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1663, 'Dettol Κρεμοσάπουνο Soothe 250ml', '', '', NULL, 24, 156, '418', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1664, 'Φάγε Τρικαλινό Τυρί Ζαρί Light Φάγε 380γρ', '', '', NULL, 25, 192, '419', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1665, 'Libero Swimpants Πάνες Midi 10-16κιλ 6τεμ', '', '', NULL, 21, 122, '420', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1666, 'Λουμίδης Καφές Ελληνικός 194γρ', '', '', NULL, 25, 173, '421', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1667, 'Χρυσή Ζύμη Τυροπίτα Σπιτική 850γρ', '', '', NULL, 25, 205, '422', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1668, 'Libresse Σερβιέτες Ultra Thin Long Wings 8τεμ', '', '', NULL, 24, 158, '424', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1669, 'Φάγε Total Γιαούρτι Στραγγιστό 2% 1κιλ', '', '', NULL, 25, 126, '425', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1670, 'Stella Artois Μπύρα 330ml', '', '', NULL, 23, 134, '426', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1671, 'Βιτάμ Μαργαρίνη Soft Light 39% Λιπ 250γρ', '', '', NULL, 25, 164, '427', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1672, 'Πέρκα Φιλέτο Κτψ Εισ Συσκ/Νη', '', '', NULL, 25, 203, '428', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1673, 'Ariel Υγρό Πλυντηρίου Ρούχων Mountain Spring 54μεζ', '', '', NULL, 22, 121, '429', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1674, 'Airwick Αντ/Κο Αποσμ Χώρου Βαν/Ορχιδ', '', '', NULL, 22, 131, '430', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(1675, 'Αλλατίνη Φαρίνα Κέικ Φλάουρ 500γρ', '', '', NULL, 25, 161, '431', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1676, 'Nan Optipro 2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 21, 161, '432', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1677, 'Νουνού Γάλα Family 1,5% 1λιτ', '', '', NULL, 25, 123, '433', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1678, 'Ελιά Βόειου Α/Ο Νωπή Ελλ Εκτρ Άνω Των 5 Μην ', '', '', NULL, 25, 218, '434', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1679, 'Μπάρμπα Στάθης Σπανάκι Φύλλα 1κιλ', '', '', NULL, 25, 204, '435', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(1680, 'Everyday Σερβ Maxi Nig/Ultra Plus Hyp 18τεμ', '', '', NULL, 24, 158, '436', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1681, 'Kellogg\'s Coco Pops Chocos 375γρ', '', '', NULL, 25, 200, '437', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1682, 'Amita Motion Φυσικός Χυμός 1λιτ', '', '', NULL, 23, 138, '438', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1683, 'Μεβγάλ Ξινόγαλο 500ml', '', '', NULL, 25, 123, '439', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1684, 'Pampers Prem Care No4 8-14κιλ 34τεμ', '', '', NULL, 21, 122, '440', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1685, 'Crunch Σοκολάτα Γάλακτος 100γρ', '', '', NULL, 25, 166, '441', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1686, 'Barilla Σάλτσα Pesto Alla Genovese 190γρ', '', '', NULL, 25, 206, '442', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1687, 'Babylino Πάνες Μωρού Sensitive No 5+ Εως 27 κιλ 16τεμ', '', '', NULL, 21, 122, '443', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1688, 'Babylino Sensitive No6 Econ 15-30κιλ 40τεμ', '', '', NULL, 21, 122, '444', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1689, 'Αχλάδια Κρυσταλία Εγχ Εξτρα ', '', '', NULL, 25, 220, '445', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1690, 'Μεβγάλ Harmony 1% Φράουλα 3Χ200γρ', '', '', NULL, 25, 126, '446', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1691, 'Klinex Υγρό Απορρυπαντικό Ρούχων Fresh Clean 25μεζ', '', '', NULL, 22, 121, '447', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1692, 'Proderm Ενυδατική Κρέμα 150ml', '', '', NULL, 21, 124, '448', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1693, 'Duck Στερεό Block Aqua Blue 40ml', '', '', NULL, 22, 129, '449', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1694, 'Ζαγόρι Νερό Athletic 750ml', '', '', NULL, 23, 135, '450', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1695, 'Χρυσά Αυγά Εξαίρετα Φρέσκα Large 6τ Χ 63γρ Πλαστ Θήκη', '', '', NULL, 25, 163, '451', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(1696, 'Κρίς Κρίς Τόστιμο Ψωμί Τόστ Ολικής Άλεσης 400γρ', '', '', NULL, 25, 194, '452', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1697, 'Μήλα Στάρκιν Κατ Έξτρα Εγχ', '', '', NULL, 25, 220, '453', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1698, '3 Άλφα Φασόλια Γίγαντες Εισαγωγής 500γρ', '', '', NULL, 25, 178, '454', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1699, 'Pescanova Μπακαλιάρος Ρολό Φιλeto 480γρ', '', '', NULL, 25, 203, '455', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1700, 'Κανάκι Βάση Πίτσας Κατεψυγμένη 660γρ', '', '', NULL, 25, 172, '456', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1701, 'Κρασί Της Παρέας Ερυθρό 1λιτ', '', '', NULL, 23, 136, '457', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1702, 'Μέγα Βαμβάκι 100γρ', '', '', NULL, 24, 141, '458', '8e8117f7d9d64cf1a931a351eb15bd69', 'af538008f3ab40989d67f971e407a85c'),
(1703, 'La Vache Qui Rit Τυρί Cheddar Φέτες 200γρ', '', '', NULL, 25, 192, '459', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1704, 'Όλυμπος Γιαούρτι Στραγγιστό 2% 3Χ200γρ', '', '', NULL, 25, 126, '460', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1705, 'Τοματίνια Βελανίδι Ε/Ζ', '', '', NULL, 25, 219, '461', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1706, 'Λαυράκια Υδατ  Ελλην 400/600 Μεσογ', '', '', NULL, 25, 213, '462', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(1707, '7 Days Κρουασάν Κακάο 70γρ', '', '', NULL, 25, 189, '463', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1708, 'Tena Lady Extra 20τεμ', '', '', NULL, 24, 148, '464', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(1709, 'Palmolive Κρεμ Μέλι Γάλα Αντ/κο 750ml', '', '', NULL, 24, 156, '465', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1710, 'Τράτα Σαρδέλες Φιλέτο Κατεψυγμένες 400γρ', '', '', NULL, 25, 203, '466', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1711, 'Neslac Επιδόρπιο Γάλακτος Μπισκότο 4Χ100γρ', '', '', NULL, 21, 203, '467', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1712, 'Μεβγάλ Στραγγιστό Γιαούρτι 3Χ200γρ', '', '', NULL, 25, 126, '469', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1713, 'Sanitas Σακ Απορ Ultra 52Χ75cm 10τεμ', '', '', NULL, 22, 133, '470', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1714, 'Vaseline Petroleum Jelly 100% Καθαρή Βαζελίνη 100 ml', '', '', NULL, 24, 155, '471', '8e8117f7d9d64cf1a931a351eb15bd69', 'fefa136c714945a3b6bcdcb4ee9e8921'),
(1715, 'Amstel Μπύρα Premium Quality 0,5λιτ', '', '', NULL, 23, 134, '472', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1716, 'Gillette Venus Close&Clean+2 Ανταλ', '', '', NULL, 24, 146, '473', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1717, 'Χρυσή Ζύμη Κασερόπιτα Σπιτική 850γρ', '', '', NULL, 25, 205, '474', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1718, 'Dove Deodorant Κρέμα Rollon 50ml', '', '', NULL, 24, 140, '475', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(1719, 'Klinex Υγρά Πανάκια 30τεμ', '', '', NULL, 22, 133, '476', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1720, 'Γιώτης Σιρόπι Σοκολάτα 350γρ', '', '', NULL, 25, 165, '477', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1721, 'OralB Χειρ Οδοντoβ 1/2/3 Clas Care 40 Med 2 τεμ', '', '', NULL, 24, 147, '478', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(1722, 'Κιλότο Νεαρού Μοσχ Α/Ο Νωπό Εισ', '', '', NULL, 25, 218, '479', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1723, 'Halls Καραμ Cool Menthol 28γρ', '', '', NULL, 25, 180, '480', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(1724, 'Pedigree Υγ Σκυλ/Φή 3 Ποικ Πουλερικών 400γρ', '', '', NULL, 28, 224, '481', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1725, 'Μεβγάλ Ζελέ Κεράσι 3Χ150γρ', '', '', NULL, 25, 167, '482', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(1726, 'Μεβγάλ High Protein Vanilla Drink 242ml', '', '', NULL, 25, 123, '483', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1727, 'Sanitas Παγοκυψέλες 2 Σε 1', '', '', NULL, 22, 133, '484', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1728, 'Βιτάμ Soft Μαργαρίνη 3/4 250γρ', '', '', NULL, 25, 164, '485', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1729, 'Ferrero Kinder Σοκολ Bars Χ Γλουτ 8τ 100γρ', '', '', NULL, 25, 198, '487', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1730, 'Εδέμ Φασόλια Κόκκινα Σε Νερό 240γρ.', '', '', NULL, 25, 178, '488', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1731, 'Omo Σκόνη Πλυντ Τροπ Λουλούδια 45πλ', '', '', NULL, 22, 121, '489', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1732, 'Flokos Σκουμπρί Φιλέτο Καπνιστό 160gr', '', '', NULL, 25, 203, '490', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1733, 'Fissan Baby Σαπούνι 30% Eνυδ Kρέμα 100gr', '', '', NULL, 21, 203, '491', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1734, 'Μίνι Ούζο Γλυκάνισο 200ml', '', '', NULL, 23, 137, '492', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1735, 'Πατάτες  Κύπρου  Κατ Α Συσκ/Νες', '', '', NULL, 25, 219, '493', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1736, 'Quanto Μαλακτ Ρουχ Ελλ Νησ 2λιτ', '', '', NULL, 22, 129, '495', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1737, 'Vanish Oxi Action Ενισχυτικό Πλεύσης 1γρ', '', '', NULL, 22, 121, '496', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1738, 'Μπανάνες Υπολ Μάρκες ', '', '', NULL, 25, 220, '497', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1739, 'Molto Κρουασάν Πραλίνα 80γρ', '', '', NULL, 25, 189, '498', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1740, 'Ajax Υγρό Κατά Των Αλάτων Spray Expert 500ml', '', '', NULL, 22, 129, '499', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1741, 'Νίκας Γαλοπούλα Καπνιστή Φέτες 160γρ', '', '', NULL, 25, 162, '500', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(1742, 'Παπαδοπούλου Αρτοσκεύασμα Πολύσπορο 540γρ', '', '', NULL, 25, 194, '501', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1743, 'Μεταξά 3 Μπράντυ 700ml', '', '', NULL, 23, 137, '502', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1744, 'Persil Black Essenzia Απορ Υγρ 25πλ 1,5λιτ', '', '', NULL, 22, 121, '503', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1745, 'Akis Ρυζάλευρο 500γρ', '', '', NULL, 25, 161, '504', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1746, 'Μεβγάλ Τριμμένο Σκλήρο Τυρί 80γρ', '', '', NULL, 25, 192, '505', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1747, 'Μπούτι Χοιρινό Α/Ο Νωπό Ελλ Χ/Δ ', '', '', NULL, 25, 217, '506', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(1748, 'Πατάτες  Κύπρου  Κατ Α Ε/Ζ', '', '', NULL, 25, 219, '507', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1749, 'Dixan Gel 30πλ', '', '', NULL, 22, 121, '508', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1750, 'Dixan Υγρό Απορρυπαντικό Ρούχων 42μεζ', '', '', NULL, 22, 121, '509', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1751, 'Babylino Πάνες Μωρού Sensitive 3-6κιλ Nο 2 26τεμ', '', '', NULL, 21, 122, '510', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1752, 'Νουνού Ρόφημα Γάλακτος Calciplus 1λιτ', '', '', NULL, 25, 123, '511', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1753, '3 Άλφα Ρύζι Νυχάκι 1κιλ', '', '', NULL, 25, 186, '512', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1754, 'Όλυμπος Γάλα Επιλεγμ 3,7% Λ 1λιτ', '', '', NULL, 25, 123, '513', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1755, 'Fairy Υγρό Πιάτων Ultra Κανονικό 900ml', '', '', NULL, 22, 121, '514', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1756, 'Elite Φρυγανιά Τρίμμα 180γρ', '', '', NULL, 25, 210, '515', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1757, 'Sensodyne Οδ/μα Complete Protection 75ml', '', '', NULL, 24, 160, '516', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(1758, 'Barilla Ζυμαρικά Capellini No1 500γρ', '', '', NULL, 25, 169, '517', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1759, 'Αρκάδι Υγρό Πλυντ Baby Με Σαπούνι 26πλυς', '', '', NULL, 21, 169, '518', '8016e637b54241f8ad242ed1699bf2da', '991276688c8c4a91b5524b1115122ec1'),
(1760, 'Elite Φρυγανιές Σίκαλης 180γρ', '', '', NULL, 25, 210, '520', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1761, 'Sanitas Μεμβράνη Διάφανη 30μετ', '', '', NULL, 22, 133, '521', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1762, 'Μήλα Στάρκιν Ζαγορ Πηλίου ΠΟΠ Κατ Έξτρα', '', '', NULL, 25, 220, '522', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1763, 'Οίνος Ερ Γλυκ Μαυροδάφνη Αχαΐα 375ml', '', '', NULL, 23, 136, '523', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1764, 'Agrino Ρύζι Bella Parboiled Χ Γλουτ 1κιλ', '', '', NULL, 25, 186, '524', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1765, 'Absolut Βότκα 0,7λιτ', '', '', NULL, 23, 137, '525', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1766, 'Αλλοτινό Οίνος Ερυθρ Ημιγλυκ 0,5ml', '', '', NULL, 23, 136, '526', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1767, 'Agrino Φακές Ψιλές Εισαγωγής 500γρ', '', '', NULL, 25, 178, '527', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1768, 'Bravo Καφές Κλασικός 95γρ', '', '', NULL, 25, 173, '528', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1769, 'Zewa Χαρτι Κουζίνας Wisch And Weg Economy 3τεμ', '', '', NULL, 22, 130, '529', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1770, 'Κοτοπουλα Ολοκληρα Νωπα Τ.65% Νιτσιακος Π.Α.Ελλην Συσκ/Να', '', '', NULL, 25, 214, '530', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(1771, 'Johnson\'s Baby Κρέμα Μαλλ Χωρ Κομπ 500ml', '', '', NULL, 21, 214, '531', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1772, 'Garnier Express Ντεμακιγιάζ Ματιών 2σε1 125ml', '', '', NULL, 24, 149, '532', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1773, 'Κατσέλης Κριτσίνια Μακεδονικά Ολικής Άλεσης 200γρ', '', '', NULL, 25, 209, '533', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(1774, 'Δωδώνη Γιαούρτι Στραγγιστό 2% 1Kg', '', '', NULL, 25, 126, '536', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1775, 'Όλυμπος Γάλα Ζωής Πλήρες Υψ Παστ 1,5λιτ', '', '', NULL, 25, 123, '537', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1776, 'Bacardi Ρούμι 700ml', '', '', NULL, 23, 137, '538', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1777, 'Ava Υγρό Πιάτων Perle Σύμπλεγμα Βιταμινών 430ml', '', '', NULL, 22, 121, '539', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1778, 'Μεβγάλ Τριμμένο Τυρί Light 10% Λ 200γρ', '', '', NULL, 25, 192, '541', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1779, 'Creta Farms Εν Ελλάδi Λουκάν Παραδ Χ Γλουτ 340γρ', '', '', NULL, 25, 198, '542', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1780, 'Creta Farms Εν Ελλάδι Κεφτεδάκια Κτψ 420γρ', '', '', NULL, 25, 211, '543', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(1781, 'Barilla Maccheroncini Μακαρόνια Για Παστίτσιο 500γρ', '', '', NULL, 25, 169, '544', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1782, 'Klinex Χλωρίνη Classic 1λιτ', '', '', NULL, 22, 129, '545', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1783, 'Μπάρμπα Στάθης Ρύζι Με Καλαμπόκι 600γρ', '', '', NULL, 25, 204, '546', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(1784, 'Elvive Extraordinary Oil Universal 100ml', '', '', NULL, 24, 150, '547', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1785, 'Activel Plus Αντισηπτικό Gel Χεριών 500ml', '', '', NULL, 26, 221, '548', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(1786, 'Ζαγόρι Φυσικό Μεταλλικό Νερό 1.5λιτ', '', '', NULL, 23, 135, '549', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1787, 'Παπαδοπούλου Krispies Σουσάμι 200γρ', '', '', NULL, 25, 209, '550', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(1788, 'Γιαννιώτη Φύλλο Κρουσ Νωπό 450γρ', '', '', NULL, 25, 172, '551', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1789, 'Ροδόπη Γιαούρτι Κατσικίσιο 240γρ', '', '', NULL, 25, 126, '552', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1790, 'Pillsbury Αφρατ Ζυμ Για Πίτσα 400γρ', '', '', NULL, 25, 172, '553', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1791, 'Γλώσσες Φιλέτο Κτψ Εισ Συσκ/Νες', '', '', NULL, 25, 203, '554', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(1792, 'Coca Cola Zero 2Χ1,5λιτ', '', '', NULL, 23, 139, '555', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1793, 'Jumbo Σνακ Γαριδάρες 85gr', '', '', NULL, 25, 188, '556', 'ee0022e7b1b34eb2b834ea334cda52e7', 'f87bed0b4b8e44c3b532f2c03197aff9'),
(1794, 'Διβάνη Βούτυρο Αγνό Γάλακτ Λιωμ 500γρ', '', '', NULL, 25, 164, '559', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1795, 'Gouda Τυρί Φάγε Φέτες 200γρ', '', '', NULL, 25, 192, '560', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1796, 'Flora Μαργαρίνη Πλακ 70% Λιπ 25% 250γρ', '', '', NULL, 25, 164, '561', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1797, 'Uncle Bens Ρύζι Basmati 500γρ', '', '', NULL, 25, 186, '562', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1798, 'St Clemens Μπλέ Τυρί Δανίας 100γρ', '', '', NULL, 25, 192, '563', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1799, 'Quanto Μαλακτικό Ρούχων Ελληνικά Νησιά 18μεζ', '', '', NULL, 22, 121, '564', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1800, 'Pampers Πάνες Μωρού Premium Care Newborn 2-5κιλ 26τεμ', '', '', NULL, 21, 122, '565', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1801, 'Παπαδημητρίου Κρέμα Balsamico Λευκή 250ml', '', '', NULL, 25, 181, '566', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(1802, 'Gillette Αφρός Ξυρ Sens Classic 200ml', '', '', NULL, 24, 153, '567', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(1803, 'Airwick Αποσμ Χώρου Stick Up 120γρ 2τεμ', '', '', NULL, 22, 131, '568', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(1804, 'Lipton Τσάι Ρόφημα 10 Φακ 1,5γρ', '', '', NULL, 25, 185, '569', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(1805, 'Knorr Κύβοι Ζωμού Λαχανικών 12λιτ 24τεμάχια', '', '', NULL, 25, 182, '570', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1806, 'Fairy Original All in One Καψ Πλυντ Πιάτ Λεμόνι 22τεμ', '', '', NULL, 22, 121, '571', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1807, 'Μινέρβα Χωριό Βούτυρο 41% Επαλ Σκαφ 225γρ', '', '', NULL, 25, 164, '572', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1808, 'Always Σερβ Ultra Platinum Night 6τεμ', '', '', NULL, 24, 158, '573', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1809, 'Ελιά Νεαρού Μοσχ Α/Ο Νωπή Εισ', '', '', NULL, 25, 218, '574', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1810, 'Pom Pon Μαντ Καθαρ Argan Oil 20τεμ', '', '', NULL, 24, 149, '575', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1811, 'Lenor Υγρό Απορρυπαντικό Ρούχων Gold Orchid 19μεζ', '', '', NULL, 22, 121, '576', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1812, 'Φράουλες Εγχ', '', '', NULL, 25, 220, '577', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1813, 'Life Χυμός Φυσικός Πορτοκάλι 1λιτ', '', '', NULL, 23, 138, '578', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1814, 'Φάγε Τρικαλινό Τυρί Ζάρι Φάγε 380γρ', '', '', NULL, 25, 192, '580', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1815, 'Fissan Baby Πούδρα 100gr', '', '', NULL, 21, 124, '581', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(1816, 'Barilla Cannelloni 250γρ', '', '', NULL, 25, 169, '582', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1817, 'McCain Πατάτες Mediterannean 750γρ', '', '', NULL, 25, 202, '583', 'ee0022e7b1b34eb2b834ea334cda52e7', '5c5e625b739b4f19a117198efae8df21'),
(1818, 'Λαυράκια Υδατ  Καθαρ Ελλην400/600 Μεσογ Συσκ/Να', '', '', NULL, 25, 213, '584', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(1819, 'Skip Υγρό Regular 30πλ', '', '', NULL, 22, 121, '585', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1820, 'Cajoline Συμπυκνωμένο Μαλακτικό Blue Fresh 30μεζ', '', '', NULL, 22, 121, '586', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1821, 'Syoss Cond Βαμμένα Μαλ 500ml', '', '', NULL, 24, 143, '587', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(1822, 'Knorr Μανιταρόσουπα 90γρ', '', '', NULL, 25, 168, '588', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eef696c0f874603a59aed909e1b4ce2'),
(1823, 'Ajax Antistatic Καθαριστικό Για Τζάμια Αντλία 750ml', '', '', NULL, 22, 129, '590', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1824, 'Palmolive Αφρόλ Natural Αμυγδ 650ml', '', '', NULL, 24, 125, '591', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1825, 'Soupline Mistral Μαλακτικό Συμπ 82πλ', '', '', NULL, 22, 129, '592', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1826, 'Όλυμπος Κεφαλοτύρι Προβ 250γρ', '', '', NULL, 25, 192, '593', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1827, 'Joya Ρόφημα Σογιας Bio Χ Ζαχ 1λιτ', '', '', NULL, 25, 198, '594', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1828, 'Κρεμμύδια Κόκκινα Ξερά Εισ ', '', '', NULL, 25, 219, '596', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1829, 'Forno Bonomi Μπισκ Σφολιατ 200γρ', '', '', NULL, 25, 165, '597', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1830, 'Κρεμμύδια Ξανθά Ξερά Εγχ', '', '', NULL, 25, 219, '598', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1831, 'Gillette Sensor Excel Ανταλ Ξυρ 5 τεμ', '', '', NULL, 24, 146, '599', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1832, 'Johnson Baby Βρεφικό Σαμπουάν Χαμομήλι Αντλιά 500ml', '', '', NULL, 21, 146, '601', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1833, 'Fix Hellas Μπύρα 6X330ml', '', '', NULL, 23, 134, '602', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1834, 'Mini Babybel Τυρί Classic 10τεμ 200γρ', '', '', NULL, 25, 192, '603', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1835, 'Hansaplast Universal Αδιάβροχα 40τεμ', '', '', NULL, 24, 154, '604', '8e8117f7d9d64cf1a931a351eb15bd69', '1b59d5b58fb04816b8f6a74a4866580a'),
(1836, 'Nivea After Shave Balsam 100ml', '', '', NULL, 24, 153, '605', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(1837, 'Nivea Baby Φυσιολογικός Ορός 24Χ5ml', '', '', NULL, 24, 149, '606', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1838, 'Nivea After Shave Balsam Sens 100ml', '', '', NULL, 24, 153, '607', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(1839, 'Nivea Κρ Νύχτας Cellular Anti-Age 50ml', '', '', NULL, 24, 149, '608', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1840, 'Wella New Wave Πηλός Γλυπτικής 75ml', '', '', NULL, 24, 150, '609', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(1841, 'Nestle Nesquik 375γρ', '', '', NULL, 25, 200, '610', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1842, 'Brasso Γυαλιστικό Μετάλλων 150ml', '', '', NULL, 22, 129, '611', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1843, 'Johnnie Walker Ουίσκι Black Label 12ετών', '', '', NULL, 23, 137, '613', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1844, 'Κανάκι Ζύμη Κατεψυγμένη Κουρού 700γρ', '', '', NULL, 25, 172, '614', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1845, 'Finish Εκθαμβωτικό Υγρο Πλυν Πιάτ 400ml', '', '', NULL, 22, 129, '615', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1846, 'Ίον Σοκολ Αμυγδ Υγείας 100γρ', '', '', NULL, 25, 166, '616', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1847, 'Texas Νιφάδες Βρώμης 500γρ', '', '', NULL, 25, 200, '617', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(1848, 'Ribena Φρουτοποτό Φραγκοστάφυλλο 250ml', '', '', NULL, 23, 138, '618', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1849, 'Ήπειρος Φέτα Μαλακή 400γρ', '', '', NULL, 25, 192, '619', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1850, 'Υφαντής Παριζάκι 330γρ', '', '', NULL, 25, 162, '620', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(1851, 'Γιώτης Φρουιζελέ Κεράσι Σε Σκ 200γρ', '', '', NULL, 25, 165, '623', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1852, 'Dirollo Τυρί Ημισκλ 14% Λιπ Φετ 175γρ', '', '', NULL, 25, 192, '624', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1853, 'Παπαδοπούλου Πτι Μπερ Ολικ Αλ 225γρ', '', '', NULL, 25, 207, '625', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(1854, 'Παπαδοπούλου Φρυγανιές Χωριάτικες Ολικής Άλεσης 240γρ', '', '', NULL, 25, 210, '626', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1855, 'Amita Φυσικός Χυμός Πορτοκάλι 100% 1λιτ', '', '', NULL, 23, 138, '627', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1856, 'Δέλτα Γάλα Daily Υψ Παστ Χ Λακτ 1λιτ', '', '', NULL, 25, 123, '628', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1857, 'Dixan Υγρό Απορρυπαντικό Ρούχων Άνοιξης 30μεζ', '', '', NULL, 22, 121, '629', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1858, 'Gillette Fusion Proglide Power Ανταλ 3 τεμ', '', '', NULL, 24, 146, '630', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1859, 'Jannis Παστέλι Σουσάμι Χ Γλ 70γρ', '', '', NULL, 25, 198, '631', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1860, 'Cair Αφρώδης Λευκός Ημίξηρος Οίνος 750ml', '', '', NULL, 23, 136, '632', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(1861, 'Σπάλα Βόειου Α/Ο Νωπή Ελλ Εκτρ Άνω Των 5 Μην', '', '', NULL, 25, 218, '633', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1862, 'Παυλίδης Σοκολάτα Υγείας Ν11 100γρ', '', '', NULL, 25, 166, '634', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1863, 'Μιμίκος Κοτόπουλο Στηθ Φιλ Νωπό Τυποπ 845γρ', '', '', NULL, 25, 175, '635', 'ee0022e7b1b34eb2b834ea334cda52e7', '463e30b829274933ab7eb8e4b349e2c5'),
(1864, 'Κανάκι Λουκανικοπιτάκια Κατεψυγμένα 920γρ', '', '', NULL, 25, 205, '637', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1865, 'Κύκνος Κέτσαπ Top Down Χ Γλουτ 580γρ', '', '', NULL, 25, 198, '638', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1866, 'Κύκνος Τοματοπολτός 28% Μεταλ 70γρ', '', '', NULL, 25, 183, '639', 'ee0022e7b1b34eb2b834ea334cda52e7', '5aba290bf919489da5810c6122f0bc9b'),
(1867, 'Δέλτα Γάλα 2λιτ', '', '', NULL, 25, 123, '640', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1868, 'Persil Express Σκόνη Χεριού 420γρ', '', '', NULL, 22, 121, '641', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1869, 'Καραμολέγκος Δέκα Αρτοσκεύασμα Σταρένιο Σε Φέτες 550γρ', '', '', NULL, 25, 194, '642', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1870, 'Hellmann\'s Μουστάρδα Απαλή 250γρ', '', '', NULL, 25, 206, '643', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1871, '7 Days Κρουασάν Κακάο 3Χ70γρ', '', '', NULL, 25, 189, '644', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1872, 'Μεβγάλ Γιαούρτι Πρόβειο Παραδ 300γρ', '', '', NULL, 25, 126, '645', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1873, 'Μεβγάλ Στραγγιστό Γιαούρτι 1κιλ', '', '', NULL, 25, 126, '646', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1874, 'Μεβγάλ Γάλα «Κάθε Μέρα» 1.5% 1λιτ', '', '', NULL, 25, 123, '647', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1875, 'Μεβγάλ Ζελέ Ροδάκινο 3Χ150γρ', '', '', NULL, 25, 167, '650', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(1876, 'Μεβγάλ Κεφίρ Φράουλα 500ml', '', '', NULL, 25, 123, '651', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1877, 'Μινέρβα Αραβοσιτέλαιο 1λιτ', '', '', NULL, 25, 177, '652', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1878, 'Babylino Sensitive Econ Ν5+ 13-27κιλ 42τεμ', '', '', NULL, 21, 122, '653', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1879, 'Μινέρβα Αραβοσιτέλαιο 2λιτ', '', '', NULL, 25, 177, '654', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(1880, 'Lacta Σοκολάτα Γάλακτος 200γρ', '', '', NULL, 25, 166, '656', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1881, 'Palette Βαφή Μαλ Ξανθό N8', '', '', NULL, 24, 142, '657', '8e8117f7d9d64cf1a931a351eb15bd69', '09f2e090f72c4487bc44e5ba4fcea466'),
(1882, 'Δωδώνη Τυρί Φέτα 400γρ Σε Άλμη', '', '', NULL, 25, 192, '658', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1883, 'Nivea Μάσκα Peel Off 10ml', '', '', NULL, 24, 149, '659', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1884, 'Μήλα Στάρκιν Ψιλά Συσκ/Να ', '', '', NULL, 25, 220, '660', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1885, 'Melissa Σιμιγδάλι Ψιλό 500γρ', '', '', NULL, 25, 161, '661', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1886, 'Κορπή Φυσικό Μεταλλικό Νερό1,5λιτ', '', '', NULL, 23, 135, '662', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(1887, 'Adoro Κρέμα Γάλακτος 35% Λιπαρά 200ml', '', '', NULL, 25, 176, '664', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(1888, 'Baby Care Μωρομάντηλα Χαμομήλι Minipack 12τεμ', '', '', NULL, 21, 127, '665', '8016e637b54241f8ad242ed1699bf2da', '92680b33561c4a7e94b7e7a96b5bb153'),
(1889, 'Knorr Ρύζι Risonatto Milanaise 220γρ', '', '', NULL, 25, 186, '666', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1890, 'Folie Κρουασάν Κρέμα Κακαο 80γρ', '', '', NULL, 25, 189, '667', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1891, 'Ωμέγα Special Ρύζι Νυχάκι 500γρ', '', '', NULL, 25, 186, '668', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1892, 'Amstel Μπύρα 6Χ330ml', '', '', NULL, 23, 134, '669', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(1893, 'Μπάρμπα Στάθης Σαλάτα Καλαμπ 450γρ', '', '', NULL, 25, 204, '670', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(1894, 'Κρεμμύδια Κόκκινα Ξερά Εγχ', '', '', NULL, 25, 219, '671', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1895, 'Everyday Σερβ Maxi Nig/Ultra Plus Sens 10τεμ', '', '', NULL, 24, 158, '672', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1896, 'Zwan Luncheon Meat 200γρ', '', '', NULL, 25, 174, '673', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(1897, 'Softex Χαρτί Υγείας Super Giga 2 Φύλλα 12τεμ', '', '', NULL, 22, 130, '674', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1898, 'Alfa Μπουγάτσα Με Σπανάκι Και Τυρί Κατεψυγμένη 850γρ', '', '', NULL, 25, 205, '675', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1899, 'Knorr Κύβοι Ζωμού Κότας 6λιτ 12τεμάχια', '', '', NULL, 25, 182, '676', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(1900, 'Hellmann\'s Μουστάρδα Απαλή 500γρ', '', '', NULL, 25, 206, '677', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(1901, 'Μεβγάλ High Protein Φρα Drink 237ml', '', '', NULL, 25, 123, '679', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1902, 'Babylino Πάνες Μωρού Sensitive 4 - 9 κιλ No 3 22τεμ', '', '', NULL, 21, 122, '680', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1903, 'Babylino Sensitive No5 Econ 11-25κιλ 44τεμ', '', '', NULL, 21, 122, '681', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1904, 'Μίνι Ούζο Επομ 700ml', '', '', NULL, 23, 137, '682', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1905, 'Coca Cola 330ml', '', '', NULL, 23, 139, '683', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1906, 'Jose Cuervo Τεκίλα Espec Κιτρ 0,7λιτ', '', '', NULL, 23, 137, '684', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1907, 'Camel Υγρο Δερμα Παπουτσιών Μαύρο 75ml', '', '', NULL, 24, 144, '685', '8e8117f7d9d64cf1a931a351eb15bd69', 'a610ce2a98a94ee788ee5f94b4be82c2'),
(1908, 'Noxzema Αφρόλ Talc 750ml', '', '', NULL, 24, 125, '686', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1909, 'Ava Υγρό Πιάτων Perle Χαμομήλι/Λεμόνι 1500ml', '', '', NULL, 22, 121, '687', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1910, 'Bioten 24η Κρέμα Ενυδ 50ml', '', '', NULL, 24, 155, '688', '8e8117f7d9d64cf1a931a351eb15bd69', 'fefa136c714945a3b6bcdcb4ee9e8921'),
(1911, 'Oral B Στοματικό Διαλ Δοντ/Ουλων 500ml', '', '', NULL, 24, 159, '689', '8e8117f7d9d64cf1a931a351eb15bd69', '181add033f2d4d95b46844abf619dd30'),
(1912, 'Calgon Gel 750ml', '', '', NULL, 22, 129, '690', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1913, 'Νουνού Γάλα Ζαχαρούχο 397γρ', '', '', NULL, 25, 123, '691', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1914, 'Dettol Κρεμοσάπουνο Citrus 250ml', '', '', NULL, 24, 156, '692', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(1915, 'Lipton Τσάι Κίτρινο Φακ 20τεμΧ1,5γρ', '', '', NULL, 25, 185, '693', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(1916, 'Nivea Νερό Διφασ Ντεμακ Ματιών 125ml', '', '', NULL, 24, 149, '694', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1917, 'Vanish Oxi Action Ενισχ Πλύσης 500γρ', '', '', NULL, 22, 129, '695', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1918, 'Vanish Pink Πολυκαθαριστικό Λεκέδων 30γρ', '', '', NULL, 22, 129, '696', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1919, 'Grants Ουίσκι 0,7λιτ', '', '', NULL, 23, 137, '697', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(1920, '7 Days Κέικ Bar Κακάο 5Χ30γρ', '', '', NULL, 25, 170, '698', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(1921, 'Pedigree Denta Stix Small Σκύλου 110γρ', '', '', NULL, 28, 224, '699', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(1922, 'Νίκας Ωμοπλάτη Χωρίς Γλουτένη 160γρ', '', '', NULL, 25, 198, '700', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1923, 'Septona Παιδικό Σαμπουάν Κορίτσια 500ml', '', '', NULL, 21, 198, '701', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1924, 'Septona Σερβιέτες Sensitive Ultra Plus Night 8τεμ', '', '', NULL, 24, 158, '702', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(1925, 'Adoro Βούτυρο 250γρ', '', '', NULL, 25, 164, '703', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1926, 'CIF Spray Κουζίνας 500ml', '', '', NULL, 22, 129, '704', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1927, 'Νουνού Γάλα Light Μερίδες Διχ 10Χ15γρ', '', '', NULL, 25, 123, '705', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1928, 'Agrino Ρύζι Basmati Χ Γλουτ 500γρ', '', '', NULL, 25, 186, '706', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1929, 'Κύκνος Τοματοπολτός 200γρ', '', '', NULL, 25, 183, '709', 'ee0022e7b1b34eb2b834ea334cda52e7', '5aba290bf919489da5810c6122f0bc9b'),
(1930, 'Ruffles Barbeque 130γρ', '', '', NULL, 25, 190, '710', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(1931, 'Μύλοι Αγίου Γεωργίου Easy Bake Μειγ Muffin 500γρ', '', '', NULL, 25, 165, '711', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(1932, 'Philadelphia Τυρί Light 200γρ', '', '', NULL, 25, 192, '712', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1933, 'Gillette Venus Ξυρ Γυν Ανταλ 4τεμ', '', '', NULL, 24, 146, '713', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(1934, 'Καραμολέγκος Ψωμί Τόστ Δέκα Χωριάτικο 500γρ', '', '', NULL, 25, 194, '714', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1935, 'Καραμολέγκος Παξαμάς Σικαλης 400γρ', '', '', NULL, 25, 209, '715', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(1936, 'Akis Καλαμποκάλευρο 500γρ', '', '', NULL, 25, 161, '716', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1937, 'Λάπα Νεαρού Μοσχ Α/Ο Νωπή Εισ', '', '', NULL, 25, 218, '717', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1938, 'Nivea Γαλάκτωμα Καθαρισμού 200ml', '', '', NULL, 24, 149, '718', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(1939, 'Maggi Noodles Γεύση Κοτόπουλο 60γρ', '', '', NULL, 25, 168, '719', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eef696c0f874603a59aed909e1b4ce2'),
(1940, 'Όλυμπος Γιαούρτι Στραγγ 10% Λ 3Χ200γρ', '', '', NULL, 25, 126, '720', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1941, 'Μέλισσα Κριθαράκι Μέτριο 500γρ', '', '', NULL, 25, 169, '721', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1942, 'Dr Beckmann Καθαριστικο Φουρνου 375ml', '', '', NULL, 22, 129, '722', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1943, 'Παπαδοπούλου Κριτσίνια Μακεδ Ολ Αλ 200γρ', '', '', NULL, 25, 209, '723', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(1944, 'Μεβγάλ Τριμμένο Σκληρό Τυρί 200γρ', '', '', NULL, 25, 192, '724', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1945, 'Alfa Κιχι Παραδοσιακή Πίτα Με Τυρί 800γρ', '', '', NULL, 25, 205, '725', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(1946, '3 Άλφα Φασόλια Χονδρά Εισαγωγής 500γρ', '', '', NULL, 25, 178, '726', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(1947, 'Δέλτα Ρόφημα Advance Υψ Παστ Μπουκ 1λιτ', '', '', NULL, 25, 123, '727', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1948, 'Μιμίκος Κοτόπουλο Φιλ Μπούτ Νωπό Τυποπ 650γρ', '', '', NULL, 25, 175, '728', 'ee0022e7b1b34eb2b834ea334cda52e7', '463e30b829274933ab7eb8e4b349e2c5'),
(1949, '3 Άλφα Ρύζι Γλασσέ 500γρ', '', '', NULL, 25, 186, '729', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(1950, 'Εύρηκα Bright Ενισχυτικό Πλύσης Πολυκαθαριστικό Λεκέδων 500g', '', '', NULL, 22, 121, '730', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1951, 'Ροδόπη Γιαούρτι Πρόβειο Βιο 240γρ', '', '', NULL, 25, 126, '731', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1');
INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(1952, 'Leerdammer Τόστ Light 10 φέτες 175γρ', '', '', NULL, 25, 192, '733', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1953, 'Τσίπουρα Υδατ Ελλην Β 200/300 Μεσογ', '', '', NULL, 25, 213, '734', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(1954, 'Εβόλ Γάλα Παστερ Αγελαδ Βιολ 1λιτ', '', '', NULL, 25, 123, '735', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1955, 'Χρυσή Ζύμη Κρουασάν Βουτύρου 300γρ', '', '', NULL, 25, 172, '736', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(1956, 'Fa Αφρόλ Yoghurt Van Honey 750m', '', '', NULL, 24, 125, '737', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1957, 'Μήλα Στάρκιν Εισ', '', '', NULL, 25, 220, '738', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(1958, 'Μύλοι Αγίου Γεωργίου Αλεύρι Για Όλες Τις Χρ 1κιλ', '', '', NULL, 25, 161, '739', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(1959, 'Δωδώνη Γιαούρτι Στραγγιστό 8% 1κιλ', '', '', NULL, 25, 126, '740', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(1960, 'Τσανός Μουστοκούλουρα 300γρ', '', '', NULL, 25, 187, '741', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(1961, 'Calgon Αποσκληρυντικό Νερού Πλυντηρίου Ρουχων Gel 1.5λιτ', '', '', NULL, 22, 121, '742', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1962, 'Παπαδοπούλου Krispies Ολικής Χωρίς Ζάχαρη 200γρ', '', '', NULL, 25, 198, '743', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1963, 'Χυμός Ρόδι/Μηλ/Καρ Χριστοδούλου 1λιτ', '', '', NULL, 23, 138, '744', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(1964, 'Νουνού Γάλα Family 3,6% 1λιτ', '', '', NULL, 25, 123, '745', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(1965, 'Παπαδημητρίου Balsamico Βιολογικό Καλαμάτας 250ml', '', '', NULL, 25, 181, '746', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(1966, 'Νουνού Κρέμα Γάλακτος Πλήρης 2Χ330ml', '', '', NULL, 25, 176, '747', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(1967, 'Μέλισσα Κριθαράκι Χονδρό 500γρ', '', '', NULL, 25, 169, '748', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(1968, 'Topine Υγρό Επιφ Red Pine 1λιτ', '', '', NULL, 22, 129, '749', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1969, 'Calgon Ταμπλέτες 15τεμ', '', '', NULL, 22, 129, '751', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1970, 'Flora Maργαρίνη Soft 60% Λιπ 225γρ', '', '', NULL, 25, 164, '752', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1971, 'Swiffer Dusters 5τεμ+Χειρολαβή', '', '', NULL, 22, 133, '753', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(1972, 'Fairy Υγρό Απορρυπαντικό Πιάτων Power Spray 375ml', '', '', NULL, 22, 121, '754', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(1973, 'Septona Σαμπουάν Και Αφρόλουτρο Βρεφικό Με Αλοη 500ml', '', '', NULL, 21, 121, '755', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(1974, 'Coca Cola Zero 330ml', '', '', NULL, 23, 139, '756', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(1975, 'Ζωγράφος Μακαρόνια Διαίτης Ν6 500γρ', '', '', NULL, 25, 198, '758', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(1976, 'Ντομάτες Εγχ Υπαιθρ Τσαμπί ', '', '', NULL, 25, 219, '759', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1977, 'Κρίς Κρίς Τόστιμο Ψωμί Τόστ Σταρένιο 800γρ', '', '', NULL, 25, 194, '760', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(1978, 'Lurpak Βούτυρο Ανάλατο 250γρ', '', '', NULL, 25, 164, '762', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(1979, 'Στεργίου Κρουασάν Βιέννης Με Κρέμα Σοκολάτα 120γρ', '', '', NULL, 25, 189, '763', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(1980, 'Παπαδοπούλου Φρυγανιές Χωριάτικες 240γρ', '', '', NULL, 25, 210, '764', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a483dd538ecd4ce0bdbba36e99ab5eb1'),
(1981, 'Μάσκες Προστ Προσώπου 50τεμ', '', '', NULL, 27, 222, '765', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(1982, 'Μάσκα προσώπου 10τεμ 1 χρήση', '', '', NULL, 27, 222, '766', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(1983, 'Lux Aφρόλ Magical Beauty 700ml', '', '', NULL, 24, 125, '767', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(1984, 'Fina Τυρί Φέτες 10% Λιπ 175γρ', '', '', NULL, 25, 192, '768', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(1985, 'Zewa Deluxe Χαρτί Υγείας 3 Φύλλα 8τεμ', '', '', NULL, 22, 130, '769', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(1986, 'Viakal Υγρό Καθαρισμού Κατά Των Αλάτων 500ml', '', '', NULL, 22, 129, '770', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(1987, 'Αγγουράκια Κιλ Τυπ Νειλ – Τυπ Κνωσ', '', '', NULL, 25, 219, '771', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1988, 'Lavazza Καφές Rossa Espresso 250γρ', '', '', NULL, 25, 173, '772', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(1989, 'Καρότα Εγχ ', '', '', NULL, 25, 219, '773', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1990, 'Purina One Γατ/Φή Ξηρά Βοδ/Σιτ 800γρ', '', '', NULL, 28, 223, '774', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(1991, 'Κοτοπουλα Ολοκληρα Νωπα Χυμα Τ.65% Π.Α.Ελλην', '', '', NULL, 25, 214, '775', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(1992, 'Pampers Πάνες Μωρού Premium Care Nο 6 13+κιλ 38τεμ', '', '', NULL, 21, 122, '776', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(1993, 'Ντομάτες Εγχ Υδροπ Κατ  Β.  ', '', '', NULL, 25, 219, '777', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(1994, 'Nan Optipro Γάλα Τρίτης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 21, 219, '778', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(1995, 'Σπάλα Νεαρού Μοσχ Α/Ο Νωπή Εισ', '', '', NULL, 25, 218, '779', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(1996, 'Παυλίδης Μερέντα 360γρ', '', '', NULL, 25, 199, '780', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(1997, 'Παυλίδης Κουβερτούρα Κλασ 125γρ', '', '', NULL, 25, 166, '781', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1998, 'Παυλίδης Γκοφρέτα Υγείας 34γρ', '', '', NULL, 25, 166, '782', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(1999, 'Δέλτα Γάλα Ελαφρύ 1λιτ', '', '', NULL, 25, 123, '783', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2000, 'Intermed Reval Plus Gel Χεριών Lollipop 75ml', '', '', NULL, 26, 221, '784', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(2001, 'Veet Κρύο Κερι Ταινίες Προσώπου 20τεμ', '', '', NULL, 24, 146, '785', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2002, 'Campari Bitter Aπεριτίφ 700ml', '', '', NULL, 23, 137, '786', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2003, 'Ferrero Kinder Σοκολ 2πλη 16τεμ Χ Γλουτ 200γρ', '', '', NULL, 25, 198, '787', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2004, 'Klinex Καθ Πατώματος Λεμόνι 1λιτ', '', '', NULL, 22, 129, '788', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2005, 'Πορτοκάλια Βαλέντσια Εισ Ε/Ζ', '', '', NULL, 25, 220, '789', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2006, 'Ρεπάνη Μοσχοφίλερο Λευκός Οίνος 750ml', '', '', NULL, 23, 136, '790', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(2007, 'Ντομάτες Εγχ Υπαιθρ Α ', '', '', NULL, 25, 219, '791', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2008, 'Ajax Καθαριστικό Ultra 7 Φυσ Σαπούνι 1λιτ', '', '', NULL, 22, 129, '792', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2009, 'Lenor Μαλακτικό Gold Orchid 26πλ', '', '', NULL, 22, 129, '793', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2010, 'Ίον Σοκοφρέτα Σοκολ Υγείας 38γρ', '', '', NULL, 25, 166, '794', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2011, 'Orzene Condit Μπύρας Κανον Μαλλ 250ml', '', '', NULL, 24, 125, '795', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2012, 'Rio Mare Τόνος Νερόυ 2Χ160γρ', '', '', NULL, 25, 174, '796', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(2013, 'Life Φρουτοπ Κρανμπ/Ρασμπ/Μπλουμπ 1lt', '', '', NULL, 23, 138, '797', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2014, 'Παπαδοπούλου Παξιμαδάκια Σίτου 200γρ', '', '', NULL, 25, 209, '798', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2015, 'Δέλτα Γιαούρτι Μικ Οικ Φαρμ 2% 2Χ200γρ', '', '', NULL, 25, 126, '799', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2016, 'Hellmann\'s Σαλάτα Φάρμα Κηπ 250γρ', '', '', NULL, 25, 201, '800', 'ee0022e7b1b34eb2b834ea334cda52e7', '4f205aaec31746b89f40f4d5d845b13e'),
(2017, 'Skip Duo Καψ Πλυντ Ρούχ Active Clean 578γρ', '', '', NULL, 22, 121, '801', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2018, 'Υφαντής Γαλοπούλα Καπνιστή 160γρ', '', '', NULL, 25, 162, '802', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2019, 'Ντομάτες Τσαμπί Υδροπ Εγχ  Α', '', '', NULL, 25, 219, '803', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2020, 'Autan Family Care Spray 100ml', '', '', NULL, 22, 132, '804', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(2021, 'Αύρα Νερό Μεταλ Μπλουμ 330ml', '', '', NULL, 23, 135, '805', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(2022, 'Τσίπουρα Υδατ Καθαρ Ελλην  Α 300/400 Μεσογ Συσκ/Νη', '', '', NULL, 25, 213, '806', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2023, 'Trata Σαρδέλα Πικάντικη 100γρ', '', '', NULL, 25, 174, '807', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(2024, 'Tsakiris Πατατάκια Ρίγανη 72γρ', '', '', NULL, 25, 190, '808', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(2025, 'Ajax Άσπρος Σίφουνας Λεμόνι 1000ml', '', '', NULL, 22, 129, '809', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2026, 'Νουνού Γάλα Σκόνη Frisolac 1ης Βρεφ Ηλικίας 800γρ', '', '', NULL, 21, 129, '810', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2027, 'Kleenex Χαρτί Υγείας 2 Φύλλα 12τεμ', '', '', NULL, 22, 130, '811', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(2028, 'Παπαδοπούλου Μπισκότα Μιράντα Ν16 250γρ 12τεμ', '', '', NULL, 25, 207, '812', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(2029, 'Martini Bianco Απεριτίφ 1λιτ', '', '', NULL, 23, 137, '813', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2030, 'Axe Αποσμ Σπρέυ Dark Temptation 150ml', '', '', NULL, 24, 140, '814', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(2031, 'Hellmann\'s Μαγιονέζα 450ml', '', '', NULL, 25, 206, '815', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(2032, 'Υφαντής Ζαμπόν Μπούτι Βραστό Σε Φέτες 160γρ', '', '', NULL, 25, 162, '816', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2033, 'Agrino Ρύζι Parboiled Bella Χ Γλουτ 500γρ', '', '', NULL, 25, 186, '817', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(2034, 'Νίκας Σαλαμι Αέρος Συκευασμενο 100γρ', '', '', NULL, 25, 162, '818', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2035, 'Ferrero Rocher Πραλίνες 16τεμ 200γρ', '', '', NULL, 25, 166, '819', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2036, 'Elvive Color Vive Γαλακτ Μαλ 200ml', '', '', NULL, 24, 143, '820', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(2037, 'Αλλατίνη Κέικ Κακάο Με Κομμάτια Σοκολάτας 400γρ', '', '', NULL, 25, 170, '821', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(2038, 'Σολομός Νωπός Φιλετ/νος Με Δέρμα Υδ Νορβ/Εισαγ  Β.Α Ατλ Ε/Ζ', '', '', NULL, 25, 213, '822', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2039, 'Μύλοι Αγίου Γεωργίου Καλαμποκάλευρο 500γρ', '', '', NULL, 25, 161, '823', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2040, 'Knorr Ζωμός Κότας Σπιτικός 112γρ', '', '', NULL, 25, 182, '824', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(2041, 'Proderm Ενυδατική Κρέμα Sleep Easy 150ml', '', '', NULL, 21, 124, '825', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(2042, 'Palmolive Υγρό Πιάτων Regular 500ml', '', '', NULL, 22, 121, '826', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2043, 'Palmolive Υγρό Πιάτων Λεμόνι 500ml', '', '', NULL, 22, 121, '827', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2044, 'Scotch Brite Σύρμα Πράσινο Κουζίνας', '', '', NULL, 22, 133, '828', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(2045, 'Dettol Υγρό Καθαριστικό Αντιβακτηριδιακό Κουζινας 500ml Με Ενεργο Οξυγονο Power & Pure', '', '', NULL, 22, 129, '829', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2046, 'Μηλοκλέφτης Μηλίτης 330ml', '', '', NULL, 23, 134, '830', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2047, 'Almiron-2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 21, 134, '831', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2048, 'Υφαντής Παριζακι Γαλοπούλας 330γρ', '', '', NULL, 25, 162, '832', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2049, 'Noxzema Αφρός Ξυρισ Xtr Sens 300ml', '', '', NULL, 24, 153, '833', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(2050, '3 Άλφα Φακές Ψιλές Εισαγωγής 500γρ', '', '', NULL, 25, 178, '834', 'ee0022e7b1b34eb2b834ea334cda52e7', '50e8a35122854b2b9cf0e97356072f94'),
(2051, 'Bref Wc Power Active Αρωματικό Τουαλέτας Πεύκο 50γρ', '', '', NULL, 22, 129, '835', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2052, 'Barilla Λαζάνια Με Αυγά 500γρ', '', '', NULL, 25, 169, '836', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2053, 'Gliss Condition Ultimate Color 200ml', '', '', NULL, 24, 143, '837', '8e8117f7d9d64cf1a931a351eb15bd69', 'cf079c66251342b690040650104e160f'),
(2054, 'Παπαδοπούλου Ψωμί Τόστ Plus Σίτου 700γρ', '', '', NULL, 25, 194, '838', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(2055, 'McCain Πατάτες Tradition Σακ 1κλ', '', '', NULL, 25, 202, '839', 'ee0022e7b1b34eb2b834ea334cda52e7', '5c5e625b739b4f19a117198efae8df21'),
(2056, 'Μίσκο Μακαρόνια Ν6 500γρ', '', '', NULL, 25, 169, '840', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2057, 'Misko Ταλιατέλλες Σιμιγδ 500γρ', '', '', NULL, 25, 169, '841', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2058, 'Milner Τυρί Φέτες 175γρ', '', '', NULL, 25, 192, '842', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2059, 'Aim Οδ/τσα 2-6 Παιδική', '', '', NULL, 24, 147, '843', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(2060, 'Haribo Goldbaren Καραμ Ζελίνια Αρκουδ 100γρ', '', '', NULL, 25, 180, '844', 'ee0022e7b1b34eb2b834ea334cda52e7', '7cfe21f0f1944b379f0fead1c8702099'),
(2061, 'Γιώτης Ανθός Ορύζης 150γρ', '', '', NULL, 21, 128, '845', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(2062, 'Λεμόνια Εγχ', '', '', NULL, 25, 220, '846', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2063, 'Ultrex Σαμπουάν Γυναικ Κανον 360ml', '', '', NULL, 24, 125, '848', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2064, 'Φάγε Μιγμ Tριμ 4 Τυρ 200γρ', '', '', NULL, 25, 192, '849', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2065, 'Φάγε Τυρί Flair Cottage 225γρ', '', '', NULL, 25, 192, '850', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2066, 'Τσίπουρα Υδατ Ελλην Α 300/400 Μεσογ', '', '', NULL, 25, 213, '851', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2067, 'Γιώτης Κρέμα Παιδικη Φαρίν Λακτέ Μπισκότο 300γρ', '', '', NULL, 21, 128, '852', '8016e637b54241f8ad242ed1699bf2da', '7e86994327f64e3ca967c09b5803966a'),
(2068, 'Fytro Σόγια Κιμάς 400γρ', '', '', NULL, 25, 198, '853', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2069, 'Lurpak Soft Αλατισμένο 225γρ', '', '', NULL, 25, 164, '854', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(2070, 'Αττική Μέλι 1κιλ', '', '', NULL, 25, 199, '855', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(2071, 'Μεβγάλ Only 2% Et Συρτ 3Χ200γρ', '', '', NULL, 25, 126, '856', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2072, 'Schar Mix B Αλεύρι Για Ψωμί 1κιλ', '', '', NULL, 25, 161, '857', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2073, 'Καρπούζια Εγχ', '', '', NULL, 25, 220, '858', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2074, 'Ροδόπη Αριάνι 1,7% 1λιτ', '', '', NULL, 25, 123, '859', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2075, 'Νίκας Γαλοπ Καπνισ + Gouda Τυρί Light Φετ 280γρ', '', '', NULL, 25, 162, '860', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2076, 'Μάννα Παξιμάδια Κριθαρένιο 800γρ', '', '', NULL, 25, 209, '861', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2077, 'Στήθος Φιλέτο Κοτ Ελλην. Νωπό Ε/Ζ Χύμα ', '', '', NULL, 25, 214, '863', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(2078, 'Nan Optipro Γάλα Τρίτης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 21, 214, '864', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2079, 'Ferrero Kinder Delice Κέικ 39γρ', '', '', NULL, 25, 170, '865', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(2080, 'Always Σερβ Ultra Platinum Night 12τεμ', '', '', NULL, 24, 158, '866', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2081, 'Meritο Spray Σιδερώματος 500ml', '', '', NULL, 22, 129, '867', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2082, 'Βλάχας Γάλα Εβαπορέ Πλήρες 410γρ', '', '', NULL, 25, 123, '868', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2083, 'Παπαδοπούλου Ψωμί Σίτου Φυσ Προζύμι 700γρ', '', '', NULL, 25, 194, '869', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(2084, 'Quanto Μαλακτ Μη Συμπ Μπλε 2λιτ', '', '', NULL, 22, 129, '870', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2085, 'Λεμόνια Εισ', '', '', NULL, 25, 220, '871', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2086, 'Μεβγάλ Κεφίρ 500ml', '', '', NULL, 25, 123, '872', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2087, 'Colgate Οδ/τσα Ext Clean Med Twin Pack', '', '', NULL, 24, 147, '873', '8e8117f7d9d64cf1a931a351eb15bd69', '6db091264f494c86b9cf22a562593c82'),
(2088, 'Silvo Γυαλιστικό Ασημικών 150ml', '', '', NULL, 22, 129, '874', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2089, 'Tsakiris Πατατάκια Αλάτι 120γρ', '', '', NULL, 25, 190, '875', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(2090, 'Λουξ Πορτοκαλάδα Ανθρ 330ml', '', '', NULL, 23, 139, '876', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2091, 'Nivea Visage Ημερ Kρ Απαλ Ενυδ Spf15 50ml', '', '', NULL, 24, 149, '877', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(2092, 'Στεργίου Κρουασάνάκια Με Γέμιση Πραλίνα 300γρ', '', '', NULL, 25, 189, '879', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(2093, 'Swiffer Dusters Αντ/κα 10τεμ', '', '', NULL, 22, 129, '880', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2094, 'Sol Ηλιέλαιο 1λιτ', '', '', NULL, 25, 177, '881', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2095, 'Septona Παιδικό Αφρόλουτρο & Σαμπουάν Αγορια 750ml', '', '', NULL, 21, 177, '882', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2096, 'Φλώρα Αραβοσιτέλαιο 1λιτ', '', '', NULL, 25, 177, '883', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2097, 'Ήπειρος Τυρί Ελαφρύ Σε Άλμη 400γρ', '', '', NULL, 25, 192, '884', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2098, 'Dove Αποσμ Σπρέυ 150ml', '', '', NULL, 24, 140, '885', '8e8117f7d9d64cf1a931a351eb15bd69', '35410eeb676b4262b651997da9f42777'),
(2099, 'Disaronno Λικέρ 700ml', '', '', NULL, 23, 137, '886', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2100, 'Danone Activia Επιδ Γιαουρ Καρυδ/Βρώμη 2Χ200γρ', '', '', NULL, 25, 126, '887', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2101, 'Κουρτάκη Ρετσίνα 500ml', '', '', NULL, 23, 136, '888', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(2102, 'Παν Κρέμα Βαλσάμικο 250ml', '', '', NULL, 25, 181, '889', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(2103, 'Λουμίδης Καφές Ελληνικός 96γρ', '', '', NULL, 25, 173, '890', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(2104, 'Dettol Υγρό Πολυκαθαριστικό Αντιβακτηριδιακό 500ml Sparkling Lemon & Lime Burst Power & Fresh', '', '', NULL, 22, 129, '891', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2105, 'Μύλοι Αγίου Γεωργίου Αλεύρι Για Πίτσα 1κιλ', '', '', NULL, 25, 161, '892', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2106, 'Johnson Baby Βρεφικό Σαμπουάν Αντλιά 300ml', '', '', NULL, 21, 161, '893', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2107, 'Αρνιά Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ Ε/Ζ', '', '', NULL, 25, 215, '894', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(2108, 'Johnnie Walker Ουίσκι Κόκκινο 0,7λιτ', '', '', NULL, 23, 137, '895', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2109, 'Pedigree Denta Stix Med Σκύλου 180γρ', '', '', NULL, 28, 224, '896', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(2110, 'Purina Gold Gourmet Γατ/Φή Μους Ψάρι 85γρ', '', '', NULL, 28, 223, '897', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(2111, 'Τοπ Ξύδι Κοκκίνου Κρασιού 350ml', '', '', NULL, 25, 181, '898', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(2112, 'Μάκβελ Μακαρόνια Σπαγγέτι Ν6 500γρ', '', '', NULL, 25, 169, '899', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2113, 'Δέλτα Ρόφημα Advance 80% Λιγ Λακτ 1λιτ', '', '', NULL, 25, 123, '900', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2114, 'Ήρα Αλάτι Μαγειρικό 1kg', '', '', NULL, 25, 196, '901', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(2115, 'Πορτοκ Βαλέντσια  Κατ Α Εγχ Ε/Ζ', '', '', NULL, 25, 220, '902', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2116, 'Σολομός Νωπός Φέτα Μ/Δ & Μ/Ο Υδ Νορβ/Εισαγ  Β.Α Ατλ Συσκ/Νοσ', '', '', NULL, 25, 213, '903', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2117, 'Neomat Σκόνη Πλυντηρίου Ρούχων Άγριο Τριαντάφυλλο 45μεζ', '', '', NULL, 22, 121, '904', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2118, 'Nestle Cheerios 375γρ', '', '', NULL, 25, 200, '905', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(2119, 'Babylino Sensitive No4+ Econ 9-20κιλ 46τεμ', '', '', NULL, 21, 122, '906', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2120, 'Sani Pants N2 Medium 14τεμ', '', '', NULL, 24, 148, '907', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(2121, 'Durex Προφυλακτικά Jeans 12τεμ', '', '', NULL, 24, 157, '908', '8e8117f7d9d64cf1a931a351eb15bd69', '7cfab59a5d9c4f0d855712290fc20c7f'),
(2122, 'Vapona Σκοροκτόνα Φύλλα 20τμχ', '', '', NULL, 22, 132, '909', 'd41744460283406a86f8e4bd5010a66d', '8f98818a7a55419fb42ef1d673f0bb64'),
(2123, 'Μεβγάλ Topino Απαχο Γάλα Κακάο 310ml', '', '', NULL, 25, 123, '910', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2124, 'Κρίς Κρίς Ψωμί Τόστ Μπρίος 400γρ', '', '', NULL, 25, 194, '911', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(2125, 'Alfa Ζύμη Για Πίτσα 600γρ', '', '', NULL, 25, 172, '912', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2126, 'Το Μάννα Παξιμάδι Κρίθινο 400γρ', '', '', NULL, 25, 209, '914', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2127, 'Όλυμπος Φυσ Χυμός Μηλ Πορτ Kaρότο 1λιτ', '', '', NULL, 23, 138, '915', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2128, 'Κεραμάρη Μάννα Αλεύρι Για Πίτες 1κιλ', '', '', NULL, 25, 161, '916', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2129, 'Όλυμπος Γιαούρτι Στρ 2% Freelact 2Χ170γρ', '', '', NULL, 25, 198, '917', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2130, 'Knorr Κυβοι Λαχανικών 120γρ', '', '', NULL, 25, 182, '918', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(2131, 'Όλυμπος Φυσικός Χυμός Πορτ 500ml', '', '', NULL, 23, 138, '919', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2132, 'Alfa Κασερόπιτα Πηλίου Κατεψυγμένη 850γρ', '', '', NULL, 25, 205, '920', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2133, 'Γιαννιώτη Φύλλο Χωριατ Νωπό 500γρ', '', '', NULL, 25, 172, '921', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2134, 'Τσίπουρα Υδατ Ελλην G 400/600 Μεσογ', '', '', NULL, 25, 213, '922', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2135, 'Ίον Σοκοφρέτα Γάλακτος 38γρ', '', '', NULL, 25, 166, '923', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2136, 'Κύκνος Τοματοχυμός 390ml', '', '', NULL, 25, 195, '924', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(2137, 'Neslac Επιδόρπιο Γάλακτος Βανίλια 4Χ100γρ', '', '', NULL, 21, 195, '925', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2138, 'Βλάχας Γάλα Εβαπορέ Ελαφρύ 410γρ', '', '', NULL, 25, 123, '926', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2139, 'Υφαντής Μπουκιές Κοτόπουλο Κτψ 500γρ', '', '', NULL, 25, 211, '927', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(2140, 'Pillsbury Φυλλο Ζύμης Για Τάρτα 600γρ', '', '', NULL, 25, 172, '928', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2141, '7 Days Παξιμαδάκια Mini Κλασική Γεύση Bake Rolls 160γρ', '', '', NULL, 25, 209, '929', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2142, 'Friskies Γατ/Φή Πατέ Κοτ/Λαχ 400γρ', '', '', NULL, 28, 223, '930', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(2143, 'Johnson Baby Βρεφικό Σαμπουάν Χαμομήλι 300ml', '', '', NULL, 21, 223, '931', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2144, 'Uncle Bens Ρύζι 10 λεπτά 4Χ125γρ', '', '', NULL, 25, 186, '932', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(2145, 'Tide Alpine Απορ Χεριού Σκόνη 450γρ', '', '', NULL, 22, 121, '933', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2146, 'Coca Cola Πλαστ 4Χ500ml', '', '', NULL, 23, 139, '934', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2147, 'Zewa Χαρτομάντηλα Soft/Strong 90τμχ', '', '', NULL, 22, 130, '935', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(2148, 'Dettol Αντιβ/κό Σπρέι 500ml', '', '', NULL, 26, 221, '936', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(2149, 'Coca Cola Light 330ml', '', '', NULL, 23, 139, '937', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2150, 'Ίον Σοκοφρέτα Γάλακτ Με Φουντούκ 38γρ', '', '', NULL, 25, 166, '938', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2151, 'Nestle Fitness Μπαρες Δημητριακών Crunchy Caramel 6X23.5γρ', '', '', NULL, 25, 177, '939', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2152, 'Παπαδοπούλου Μπισκότα Πτι Μπερ Ν16 225γ 16τεμ', '', '', NULL, 25, 207, '940', 'ee0022e7b1b34eb2b834ea334cda52e7', '35cce434592f489a9ed37596951992b3'),
(2153, 'Danone Activia Επιδ Γιαουρ Τραγ Απόλ 3Χ200γρ', '', '', NULL, 25, 126, '941', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2154, 'Μεβγάλ Topino Απαχο Γάλα Κακάο 450ml', '', '', NULL, 25, 123, '942', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2155, 'Παυλίδης Kiss Σοκολάτα Γάλ Φράουλα 27,5γρ', '', '', NULL, 25, 166, '943', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2156, 'Στάμου Γιαούρτι Πρόβειο Παραδ 240γρ', '', '', NULL, 25, 126, '944', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2157, 'Pampers Πάνες Μωρού Premium Pants Nο 5 12-17κιλ 34τεμ', '', '', NULL, 21, 122, '945', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2158, 'Head & Shoulders Σαμπουάν Total Care 300ml', '', '', NULL, 24, 125, '946', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2159, 'Kellogg\'s Corn Flakes 375γρ', '', '', NULL, 25, 200, '947', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(2160, 'Χρυσή Ζύμη Χορτοπίτα Σπιτική 850γρ', '', '', NULL, 25, 205, '948', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2161, 'Airwick Αντ/Κο Freshmatic Βαν/Ορχιδ 250ml', '', '', NULL, 22, 131, '949', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(2162, 'Don Simon Kρασί Sangria Χαρτ 1λιτ', '', '', NULL, 23, 136, '950', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(2163, 'Tasty Poppers Classic Ποπ Κορν 81γρ', '', '', NULL, 25, 191, '951', 'ee0022e7b1b34eb2b834ea334cda52e7', '8851b315e2f0486180be07facbc3b21f'),
(2164, 'COVER 50τεμ Μάσκ Με Λάστιχο 1 Χρήση', '', '', NULL, 27, 222, '952', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(2165, 'Skip Σκόνη Spring Fresh 45μεζ', '', '', NULL, 22, 121, '953', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2166, 'Μπρόκολα Πράσινα Εισ', '', '', NULL, 25, 219, '955', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2167, '7 Days Bake Rolls Pizza 160γρ', '', '', NULL, 25, 187, '956', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(2168, '3 Άλφα Ρύζι Γλασέ 1κιλ', '', '', NULL, 25, 186, '957', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(2169, 'Ready2U Μάσκες Προστ Προσώπου 50τεμ', '', '', NULL, 27, 222, '958', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(2170, 'COVER 10τεμ Μάσκ Με Λάστιχο 1 Χρήση', '', '', NULL, 27, 222, '959', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(2171, 'Τρικαλινό Τυρί Φάγε Ελαφ.Φετ.200γρ', '', '', NULL, 25, 192, '960', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2172, 'Dettol Κρεμ Relax Αντ/κο 750ml', '', '', NULL, 26, 221, '961', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(2173, 'Κορπή Νερό 6χ0,5ml', '', '', NULL, 23, 135, '963', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(2174, 'Σπάλα Βόειου/Ο Νωπή Εισ', '', '', NULL, 25, 218, '964', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(2175, 'Klinex Υγρό Απορρυπαντικό Ρούχων Fresh Clean 40μεζ', '', '', NULL, 22, 121, '965', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2176, 'Μινέρβα Χωριό Eλαιόλαδο Εξαιρ Παρθ 4λιτ', '', '', NULL, 25, 177, '967', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2177, 'Παπαδοπούλου Κριτσίνια Σουσάμι 130γρ', '', '', NULL, 25, 209, '968', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2178, 'Νίκας Σαλάμι Αέρος 72 Πικάντ Χ Γλ 165γρ', '', '', NULL, 25, 162, '969', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2179, 'Cutty Sark Ουίσκι 0,7λιτ', '', '', NULL, 23, 137, '970', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2180, 'Σολομός Νωπός Φέτα Μ/Δ & Μ/Ο  Υδ Νορβ/Εισαγ  Β.Α Ατλ Ε/Ζ', '', '', NULL, 25, 213, '971', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2181, 'Μεβγάλ Creme Καραμελέ 150γρ', '', '', NULL, 25, 167, '972', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(2182, 'Γιώτης Αλεύρι Φαρίνα Ολικής Άλεσης 500γρ', '', '', NULL, 25, 161, '973', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2183, 'Ελιά Βόειου Α/Ο Νωπή Εισ', '', '', NULL, 25, 218, '974', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(2184, 'Pemα Ψωμί Σικ Ολ Άλεσης 500γρ', '', '', NULL, 25, 194, '975', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(2185, 'Μπανάνες Dole Εισ', '', '', NULL, 25, 220, '976', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2186, 'Νεκταρίνια Εγχ', '', '', NULL, 25, 220, '977', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2187, 'Μήλα Φουτζι Εγχ ', '', '', NULL, 25, 220, '978', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2188, 'Bonne Maman Μαρμελάδα Βερικ Χ Γλ 370γρ', '', '', NULL, 25, 198, '979', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2189, 'Πορτοκ Μερλίν - Λανε Λειτ- Ναβελ Λειτ Εγχ Χυμ Συσκ/Να', '', '', NULL, 25, 220, '980', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2190, 'Pampers Πάνες Premium Care Nο 4 8-14 κιλ 52τεμ', '', '', NULL, 21, 122, '981', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2191, 'O.B. Ταμπόν Original Normal 16τμχ', '', '', NULL, 24, 158, '982', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2192, 'Νίκας Μπέικον Καπνιστό Συσκευασμένο 100γρ', '', '', NULL, 25, 162, '983', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2193, 'Dixan Σκόνη Πλυντ 42πλ 2,31γρ', '', '', NULL, 22, 121, '984', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2194, 'Ρεπάνη Αγιωργίτικος Ερυθρός Οίνος 750ml', '', '', NULL, 23, 136, '985', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(2195, 'Lurpak Soft Μειωμέν Λιπαρ Ανάλ 225γρ', '', '', NULL, 25, 164, '986', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(2196, 'Libresse Σερβιέτες Invisible Normal 10τεμ', '', '', NULL, 24, 158, '987', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2197, 'Haig Ουίσκι 0,7λιτ', '', '', NULL, 23, 137, '988', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2198, 'Ariel Υγρές Καψ 3σε1 Κανονικό 24πλ', '', '', NULL, 22, 121, '989', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2199, 'Ούζο 12 0,7λιτ', '', '', NULL, 23, 137, '990', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2200, 'Life Φρουτοποτό Πορτοκ/Μηλ/Καροτ 1λιτ', '', '', NULL, 23, 138, '991', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2201, 'Φάγε Total Γιαούρτι Στραγγιστό 1κιλ', '', '', NULL, 25, 126, '992', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2202, 'Dove Σαπούνι 100γρ', '', '', NULL, 24, 156, '993', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(2203, 'Peppa Pig Φρουτοποτό Τροπ Φτούτα 250ml', '', '', NULL, 23, 138, '994', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2204, 'Κρασί Της Παρέας Λευκό 1λιτ', '', '', NULL, 23, 136, '995', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(2205, 'Μεβγάλ Κρεμα Σοκολάτα 150γρ', '', '', NULL, 25, 167, '996', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(2206, 'Μεβγάλ Ανθότυρο Τυποπ 300γρ', '', '', NULL, 25, 192, '997', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2207, 'Καλλιμάνης Πέρκα Φιλέτο 595γρ', '', '', NULL, 25, 203, '998', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(2208, 'Ίον Σοκολάτα Γάλακτος 100γρ', '', '', NULL, 25, 166, '999', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2209, 'Creta Farms Εν Ελλάδι Κοτομπουκιές Κτψ 400γρ', '', '', NULL, 25, 211, '1000', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(2210, 'Soupline Mistral Μαλακτικό 13πλ', '', '', NULL, 22, 129, '1001', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2211, 'Glade Αντ/Κο Αποσμ Χώρου Λεβάντα', '', '', NULL, 22, 131, '1002', 'd41744460283406a86f8e4bd5010a66d', '21051788a9ff4d5d9869d526182b9a5f'),
(2212, 'Κανάκι Tυροπιτάκια Κουρού 800γρ', '', '', NULL, 25, 205, '1003', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2213, 'Χρυσή Ζύμη Σφολιάτα 850γρ', '', '', NULL, 25, 172, '1004', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2214, 'Sanitas Αλουμινόχαρτο 30μ', '', '', NULL, 22, 133, '1006', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(2215, 'Λουμίδης Καφές Ελληνικός 490γρ', '', '', NULL, 25, 173, '1007', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(2216, 'Everyday Σερβ Extr Long/Ultra Plus Sens 10τεμ', '', '', NULL, 24, 158, '1008', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2217, 'Everyday Σερβ Super/Ultra Plus Hyp 18 τεμ', '', '', NULL, 24, 158, '1009', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2218, 'Όλυμπος Γάλα Freelact 1λιτ Χ.Λακτ', '', '', NULL, 25, 123, '1010', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2219, 'Everyday Σερβ/Κια Norm All Cotton 24τεμ', '', '', NULL, 24, 158, '1011', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2220, 'Λακώνια Φυσ Χυμός Πορτοκάλι 250ml', '', '', NULL, 23, 138, '1012', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2221, 'Coca Cola 500ml', '', '', NULL, 23, 139, '1013', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2222, 'Κατσίκια Νωπά Ελλην Γαλ Ολοκλ Χ/Κ Χ/Σ ', '', '', NULL, 25, 216, '1015', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(2223, 'Gillette Fusion Proglide 5+1 Ανταλ', '', '', NULL, 24, 146, '1016', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2224, 'Υφαντής Χάμπουργκερ Top Burger 70γρ', '', '', NULL, 25, 211, '1017', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(2225, 'Friskies Γατ/Φή Πατέ Μοσχάρι 400γρ', '', '', NULL, 28, 223, '1018', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(2226, 'Twix Σοκολάτα Μπισκότο 50γρ', '', '', NULL, 25, 166, '1019', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2227, 'Γιώτης Sanilac 2 Γάλα Σε Σκόνη Δεύτερης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 21, 166, '1020', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2228, 'Υφαντής Μπέικον Καπνιστό Χ Γλουτ 100γρ', '', '', NULL, 25, 198, '1021', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2229, 'Everyday Σερβ Norm/Ultra Plus Hyp 18τεμ', '', '', NULL, 24, 158, '1022', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2230, 'Gillette Blue Ii Plus Slalom Sensit 5τεμ', '', '', NULL, 24, 146, '1023', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2231, 'Nivea Κρ Ημέρας Ξηρ/Ευαίσθ Επιδ SPF15 50ml', '', '', NULL, 24, 149, '1024', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(2232, 'Το Μάννα Παξιμάδια Λαδ Κυθήρων 500γρ', '', '', NULL, 25, 209, '1025', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2233, 'Όλυμπος Γάλα Ζωής Λευκό Υψ Παστ 1,5% Λ 1,5λιτ', '', '', NULL, 25, 123, '1026', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2234, 'Gillette Ξυρ Μηχ Mach 3 Turbo+Ανταλ', '', '', NULL, 24, 146, '1027', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2235, 'Ajax Kloron 2σε1 Λεμόνι 1λιτ', '', '', NULL, 22, 129, '1028', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2236, 'Φάγε Κεφαλοτύρι Τριμμένο 200γρ', '', '', NULL, 25, 192, '1029', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2237, 'Αρνιά Νωπά Ελλην Γαλ Ολοκλ Μ/Κ Μ/Σ ', '', '', NULL, 25, 215, '1031', 'ee0022e7b1b34eb2b834ea334cda52e7', '0936072fcb3947f3baf83e31bb5c1cab'),
(2238, 'Μάσκα Προσ 10τεμ 1 Χρήση', '', '', NULL, 27, 222, '1032', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(2239, 'Ζωγράφος Μαρμελ Φράουλ Φρουκτ 415γρ', '', '', NULL, 25, 199, '1034', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e397ddcfb34a4640a42b8fa5e999b8c8'),
(2240, 'Σαβόϊ Βούτυρο Τύπου Κερκύρας 250gr', '', '', NULL, 25, 164, '1035', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(2241, 'Vidal Αφρόλ White Musk 750ml', '', '', NULL, 24, 125, '1036', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2242, 'Misko Παραδ Χυλοπίτες Με Αυγά Μετσόβου 500γρ', '', '', NULL, 25, 169, '1037', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2243, 'Κατσέλης Κριτσίνια Μακεδονικά 200γρ', '', '', NULL, 25, 209, '1038', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2244, 'Όλυμπος Γάλα Επιλεγμ 1,5% Λ 1λιτ', '', '', NULL, 25, 123, '1039', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2245, 'Τσιλιλή Τσίπουρο Χ Γλυκάνισο 200ml', '', '', NULL, 23, 137, '1040', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2246, 'Green Cola 330ml', '', '', NULL, 23, 139, '1041', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2247, 'Βεργίνα Μπύρα 500ml', '', '', NULL, 23, 134, '1042', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2248, 'Pillsbury Ζύμη Κρουασάν 230γρ', '', '', NULL, 25, 172, '1043', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2249, 'Στεργίου Κέικ Ανάμικτο 400γρ', '', '', NULL, 25, 170, '1044', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(2250, 'Becel Pro Activ Ελαιόλαδο 35% Λιπ 250γρ', '', '', NULL, 25, 164, '1045', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(2251, 'Zewa Χαρ Υγείας Ultra Soft 8τεμ 912γρ', '', '', NULL, 22, 130, '1047', 'd41744460283406a86f8e4bd5010a66d', '034941f08ca34f7baaf5932427d7e635'),
(2252, 'Fouantre Γαλοπούλα Σε Φέτες 120γρ', '', '', NULL, 25, 162, '1048', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2253, 'Nestle Fitness 375γρ', '', '', NULL, 25, 200, '1049', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(2254, 'Nescafe Azera Καφές Espresso 100% Arabica 100γρ', '', '', NULL, 25, 173, '1050', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(2255, 'Ajax Υγρό Γενικού Καθαρισμού Kloron Lila 1λιτ', '', '', NULL, 22, 129, '1051', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2256, 'Nescafe Dolce Gusto Espresso Int Καψ 16x7γρ', '', '', NULL, 25, 173, '1052', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(2257, 'Λουξ Σόδα 330ml', '', '', NULL, 23, 139, '1053', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2258, 'Gillette Blue Ii Fixed Head 5τεμ', '', '', NULL, 24, 146, '1054', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2259, 'Γαύρος Νωπός Ελλην Μεσόγ Ολόκλ Ε/Ζ', '', '', NULL, 25, 212, '1055', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(2260, 'Green Cola 1,5λιτ', '', '', NULL, 23, 139, '1056', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2261, 'Larisa Μάσκα χειρουργική 5τεμ 1 χρήση 3ply', '', '', NULL, 27, 222, '1057', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(2262, 'Nivea Κρέμα Ξυρίσματος 100ml', '', '', NULL, 24, 153, '1058', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(2263, 'Μεβγάλ Harmony 1% Με Μέλι/Γκραν 164γρ', '', '', NULL, 25, 126, '1059', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2264, 'Ντομάτες Εισ Α', '', '', NULL, 25, 219, '1060', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2265, 'Kerrygold Τυρί Regato 270γρ', '', '', NULL, 25, 192, '1062', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2266, 'Ace Gentile Ενισχυτικό Πλύσης 1lt', '', '', NULL, 22, 129, '1063', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2267, 'Sensodyne Οδ/μα Repair/Protect 75ml', '', '', NULL, 24, 160, '1064', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(2268, 'Λακώνια Χυμός Νέκταρ Πορ/Μηλ/Βερ 250ml', '', '', NULL, 23, 138, '1065', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2269, 'Gordon\'s Τζιν 0,7λιτ', '', '', NULL, 23, 137, '1066', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2270, 'Gordons Space Τζιν Original 275ml', '', '', NULL, 23, 137, '1068', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2271, 'Heineken Μπύρα 4X500ml', '', '', NULL, 23, 134, '1069', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2272, 'Leerdammer Τυρί Τοστ Special 125γρ', '', '', NULL, 25, 192, '1070', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2273, 'Anatoli Πιπέρι Μαύρο Μύλος 45gr', '', '', NULL, 25, 196, '1071', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(2274, 'Δέλτα Γάλα Πλήρες 1λιτ', '', '', NULL, 25, 123, '1072', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2275, 'Kellogg\'s Special K Μπάρα Δημητριακών Με Ξηρούς Καρπούς Καρύδα Και Κασioυς 4Χ28γρ', '', '', NULL, 25, 200, '1073', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(2276, 'Tuborg Club Σόδα 500ml', '', '', NULL, 23, 139, '1074', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2277, 'Proderm Kids Αφρόλουτρο Χαμομήλι 700ml', '', '', NULL, 21, 139, '1075', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2278, 'Μεβγάλ Τριμμενη Μυζήθρα Ξηρή 200γρ', '', '', NULL, 25, 192, '1076', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2279, 'Coca Cola 250ml', '', '', NULL, 23, 139, '1077', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2280, 'Corona Μπύρα Extra 355ml', '', '', NULL, 23, 134, '1078', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2281, 'La Vache Qui Rit Τυρί Φέτες Light 200γρ', '', '', NULL, 25, 192, '1079', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2282, 'Ζωγράφος Φρουκτόζη 400γρ', '', '', NULL, 25, 208, '1080', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(2283, 'Ίον Σοκολάτα Γάλακτος Αμυγδάλου 100γρ', '', '', NULL, 25, 166, '1081', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2284, 'Ίον Σοκολάτα Αμυγδάλου 70γρ', '', '', NULL, 25, 166, '1082', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2285, 'Morfat Κρέμα Σαντιγύ Μετ 250γρ', '', '', NULL, 25, 165, '1083', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2286, 'Χρυσή Ζύμη Τυροπιτάκια 1κιλ', '', '', NULL, 25, 172, '1084', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2287, 'Friskies Σκυλ/Φή Ξηρ Κοτ/Λαχ 1,5κιλ', '', '', NULL, 28, 224, '1085', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(2288, 'Pampers Πάνες Premium Care Nο 3 5-9 κιλ 60τεμ', '', '', NULL, 21, 122, '1086', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2289, 'Στεργίου Μηλόπιτα Ατομική 105γρ', '', '', NULL, 25, 187, '1087', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(2290, 'Lurpak Βούτυρο Αναλ Αλουμ 125γρ', '', '', NULL, 25, 198, '1088', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2291, 'Ajax Τζαμ Crystal Clean Αντ/Κο 750ml', '', '', NULL, 22, 129, '1089', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2292, 'Φάγε Total Γιαούρτι 5% 200γρ', '', '', NULL, 25, 126, '1090', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1');
INSERT INTO `object_product` (`id`, `name`, `description`, `photourl`, `photo_DATA`, `category_id`, `subcategory_id`, `ekat_id`, `ekat_cat_id`, `ekat_sub_id`) VALUES
(2293, 'Φάγε Total Γιαούρτι 2% 3x200γρ', '', '', NULL, 25, 126, '1091', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2294, 'L\'Oreal Studio Line Fx Gel Extra Fix 150ml', '', '', NULL, 24, 153, '1093', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(2295, 'Rol Σκόνη Για Πλυσ Στο Χέρι 380γρ', '', '', NULL, 22, 121, '1094', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2296, 'Ajax Τζαμιών 450ml', '', '', NULL, 22, 129, '1095', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2297, 'Κανάκι Φύλλο Κρούστας Νωπό 450γρ', '', '', NULL, 25, 172, '1096', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2298, 'Amstel Μπύρα 4X500ml', '', '', NULL, 23, 134, '1097', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2299, 'Pom Pon Μαντηλ Ντεμακ Sensit 20τεμ', '', '', NULL, 24, 149, '1098', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(2300, 'Δέλτα Advance Επιδορπιο Λευκό 2χ150γρ', '', '', NULL, 25, 126, '1099', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2301, 'ΣΟΥΡΩΤΗ Μεταλλικό Νερό Ανθρ Λεμον 330ml ', '', '', NULL, 23, 135, '1100', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(2302, 'Gillette Gel Ξυρ Μοιsture 200ml', '', '', NULL, 24, 153, '1101', '8e8117f7d9d64cf1a931a351eb15bd69', 'e2f81e96f70e45fb9552452e381529d3'),
(2303, 'Νουνού Γάλα Εβαπορέ 400γρ', '', '', NULL, 25, 123, '1102', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2304, 'Κύκνος Τοματάκι Ψιλοκ Χαρτ Συσκ 370γρ', '', '', NULL, 25, 195, '1103', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(2305, 'Nestle Ρόφημα Γαλακτ Junior 2+ Rtd 1λιτ', '', '', NULL, 21, 195, '1105', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2306, 'Stella Artois Μπύρα 6x330ml', '', '', NULL, 23, 134, '1106', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2307, 'Ήρα Αλάτι Ψιλό 500γρ', '', '', NULL, 25, 196, '1107', 'ee0022e7b1b34eb2b834ea334cda52e7', '2ad2e93c1c0c41b4b9769fe06c149393'),
(2308, 'Μεβγάλ Παραδ Γιαούρτι Αιγοπρ Ελαφ 2Χ220γρ', '', '', NULL, 25, 126, '1108', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2309, 'Νουνού Κρέμα Γάλακτος Light 200ml', '', '', NULL, 25, 176, '1109', 'ee0022e7b1b34eb2b834ea334cda52e7', '4e4cf5616e0f43aaa985c1300dc7109e'),
(2310, 'Whiskas Γατ/Φή Πουλ Σε Σάλτσα 100γρ', '', '', NULL, 28, 223, '1110', '662418cbd02e435280148dbb8892782a', '926262c303fe402a8542a5d5cf3ac7eb'),
(2311, 'Γιώτης Mείγμα Παγωτού Καιμάκι 508γρ', '', '', NULL, 25, 165, '1111', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2312, 'Κολοκυθάκια Εγχ Με Ανθό', '', '', NULL, 25, 219, '1112', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2313, 'Μεβγάλ Only Lact Free 1,5% 1λτ', '', '', NULL, 25, 123, '1113', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2314, 'Skip Σκόνη Regular 45πλ', '', '', NULL, 22, 121, '1115', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2315, 'Almiron-1 Γάλα Σε Σκόνη Πρώτης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 21, 121, '1116', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2316, 'Βίκος Φυσικό Μεταλλικό Νερό 500ml', '', '', NULL, 23, 135, '1117', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(2317, 'Μάσκα Προσώπου Υφασμ 1τεμ', '', '', NULL, 27, 222, '1118', '2d5f74de114747fd824ca8a6a9d687fa', '79728a412a1749ac8315501eb77550f9'),
(2318, 'Veet Αποτριχωτική Κρέμα Κανον Επιδερμ 100ml', '', '', NULL, 24, 146, '1119', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2319, 'Μεβγάλ Κρέμα Βανίλια 150γρ', '', '', NULL, 25, 167, '1121', 'ee0022e7b1b34eb2b834ea334cda52e7', '509b949f61cc44f58c2f25093f7fc3eb'),
(2320, 'Κρι Κρι Σπιτικό Επιδόρπιο Γιαουρτιού 5% 1κιλ', '', '', NULL, 25, 126, '1122', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2321, 'Hellmann\'s Κέτσαπ 560γρ', '', '', NULL, 25, 206, '1124', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(2322, 'Amita Φρουτοποτό Πορ/Μηλ/Βερ 1λιτ', '', '', NULL, 23, 138, '1125', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2323, 'Wella Koleston Βαφή Μαλ Ν7/77', '', '', NULL, 24, 142, '1126', '8e8117f7d9d64cf1a931a351eb15bd69', '09f2e090f72c4487bc44e5ba4fcea466'),
(2324, 'Kit Kat Σοκολάτα 41,5γρ', '', '', NULL, 25, 166, '1127', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2325, 'Tasty Φουντούνια 105γρ', '', '', NULL, 25, 188, '1128', 'ee0022e7b1b34eb2b834ea334cda52e7', 'f87bed0b4b8e44c3b532f2c03197aff9'),
(2326, 'Ζωγράφος Καστανή Ζάχαρη 500γρ', '', '', NULL, 25, 208, '1129', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a885d8cd1057442c9092af37e79bf7a7'),
(2327, 'Agrino Ρύζι Φανσύ Για Γεμιστά Χ Γλουτ 500γρ', '', '', NULL, 25, 186, '1130', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(2328, 'Μαλαματίνα Ρετσίνα 500ml', '', '', NULL, 23, 136, '1131', 'a8ac6be68b53443bbd93b229e2f9cd34', '3d01f4ce48ad422b90b50c62b1f8e7f2'),
(2329, 'Pedigree Σκυλ/Φή Μοσχάρι 400γρ', '', '', NULL, 28, 224, '1132', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(2330, 'Dove Ντούς Deeply Nourisηing 750ml', '', '', NULL, 24, 125, '1133', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2331, 'Καλλιμάνης Χταπόδι Μικρό 595γρ', '', '', NULL, 25, 203, '1134', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(2332, 'Κλεοπάτρα Σαπούνι 125γρ', '', '', NULL, 24, 156, '1135', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(2333, 'L\'Oreal Excellence Βαφή Μαλ Ξανθό Ν7', '', '', NULL, 24, 142, '1136', '8e8117f7d9d64cf1a931a351eb15bd69', '09f2e090f72c4487bc44e5ba4fcea466'),
(2334, 'Πατάτες  Ελλ Κατ Β Ε/Ζ', '', '', NULL, 25, 219, '1137', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2335, 'Βιτάμ Μαργαρίνη Κλασικό 250γρ', '', '', NULL, 25, 164, '1138', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(2336, 'Chipita Frau Lisa Bάση Τούρτας Κακάο 400γρ', '', '', NULL, 25, 165, '1139', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2337, 'Pom Pon Eyes & Face Μαντηλάκια 20τεμ', '', '', NULL, 24, 149, '1140', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(2338, 'Τσιλιλή Τσίπουρο Χ Γλυκάνισο 700ml', '', '', NULL, 23, 137, '1141', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2339, 'Μήλα Στάρκιν Χύμα', '', '', NULL, 25, 220, '1142', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2340, 'Oral B Οδοντικό Νήμα Κηρωμένο 50τεμ', '', '', NULL, 24, 160, '1143', '8e8117f7d9d64cf1a931a351eb15bd69', '26e416b6efa745218f810c34678734b2'),
(2341, 'Μεβγάλ Παραδοσιακό Γιαούρτι Προβ 220γρ', '', '', NULL, 25, 126, '1144', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2342, 'Syoss Σαμπ Όγκο 750ml', '', '', NULL, 24, 125, '1145', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2343, 'Amstel Μπύρα 330ml', '', '', NULL, 23, 134, '1146', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2344, 'Babylino Sensitive No4 Econ 7-18κιλ 50τεμ', '', '', NULL, 21, 122, '1147', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2345, 'Κρι Κρι Γιαούρτι Στραγγιστό 2% 1κιλ', '', '', NULL, 25, 126, '1148', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2346, 'Χρυσά Αυγά Φρέσκα Αχυρώνα Medium 53-63γρ 6τεμ', '', '', NULL, 25, 163, '1149', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(2347, 'Fairy Υγρό Πιάτων Ultra Classic 400ml', '', '', NULL, 22, 121, '1150', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2348, 'Ariel Alpine Απορ Σκόνη 2,925γρ', '', '', NULL, 22, 121, '1151', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2349, 'Coca Cola 2Χ1,5λιτ', '', '', NULL, 23, 139, '1152', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2350, 'Sprite 6X330ml', '', '', NULL, 23, 139, '1153', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2351, 'Pedigree Schmackos Μπισκότα Σκύλου 43γρ', '', '', NULL, 28, 224, '1154', '662418cbd02e435280148dbb8892782a', '0c6e42d52765495dbbd06c189a4fc80f'),
(2352, 'Rio Mare Τόνος Λαδιού 2Χ160γρ', '', '', NULL, 25, 174, '1156', 'ee0022e7b1b34eb2b834ea334cda52e7', 'df10062ca2a04789bd43d18217008b5f'),
(2353, 'Danone Activia Επιδ Τραγαν Απολ Δημ 200γρ', '', '', NULL, 25, 126, '1157', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2354, 'Fix Hellas Mπύρα 330ml', '', '', NULL, 23, 134, '1158', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2355, 'Βλάχα Χυλοπιτάκι Με Αυγά 500γρ', '', '', NULL, 25, 169, '1159', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2356, 'Serkova Βότκα 37,5% 0,7λιτ', '', '', NULL, 23, 137, '1160', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2357, 'Alfa Λουκανικοπιτάκια Κουρού 800gr', '', '', NULL, 25, 205, '1161', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2358, 'Misko Τορτελίνι Με Τυρί 500γρ', '', '', NULL, 25, 169, '1162', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2359, 'Μίσκο Κριθαράκι Μέτριο 500γρ', '', '', NULL, 25, 169, '1163', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2360, 'Babylino Sensitive No3 Econ 4-9κιλ 56τεμ', '', '', NULL, 21, 122, '1164', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2361, 'Γιώτης Αλεύρι Φαρίνα Πορτοκαλί 500γρ', '', '', NULL, 25, 161, '1165', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2362, 'Παπαδημητρίου Κρεμά Βαλσαμ Χ Γλ 250ml', '', '', NULL, 25, 198, '1166', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2363, 'Φάγε Total Γιαούρτι Στραγγιστό 500γρ', '', '', NULL, 25, 126, '1167', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2364, 'Μεβγάλ Αριάνι 1,5% Χ Γλουτ 500ml', '', '', NULL, 25, 198, '1168', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2365, 'Μεβγάλ Γάλα «Κάθε Μέρα» 3.5% 1λιτ', '', '', NULL, 25, 123, '1169', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2366, 'Μεβγάλ Κεφίρ Lactose Free Με Ροδακ 500ml', '', '', NULL, 25, 123, '1170', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2367, 'Χωριό Ελαιόλαδο Κορωνεική Ποικ 1λιτ', '', '', NULL, 25, 177, '1171', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2368, 'Κορπή Νερό 6Χ1,5λιτ', '', '', NULL, 23, 135, '1172', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(2369, 'Nescafe Classic Στιγμιαίος Καφές 50γρ', '', '', NULL, 25, 173, '1173', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(2370, 'Μπάρμπα Στάθης Μπάμιες Extra 450γρ', '', '', NULL, 25, 204, '1174', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(2371, 'Everyday Σερβ Super/Ultra Plus Sens 18τεμ', '', '', NULL, 24, 158, '1175', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2372, 'Babycare Μωροπ/τες Αντ/κο 3Χ72τεμ', '', '', NULL, 21, 127, '1176', '8016e637b54241f8ad242ed1699bf2da', '92680b33561c4a7e94b7e7a96b5bb153'),
(2373, 'Mythos Μπύρα 330ml', '', '', NULL, 23, 134, '1177', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2374, 'Όλυμπος Φυσικός Χυμός Πορτοκάλι 1,5λιτ', '', '', NULL, 23, 138, '1178', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2375, 'Νουνού Γάλα Συμπ Μερίδες Διχ 10Χ15γρ', '', '', NULL, 25, 123, '1179', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2376, 'Δέλτα Advance Επιδ Αλεσμένα Δημητρ 2Χ150γρ', '', '', NULL, 25, 126, '1180', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2377, 'Κύκνος Χυμ Τομάτας Συμπ 500γρ', '', '', NULL, 25, 195, '1181', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(2378, '7 Days Τσουρεκάκι Κλασικό 75γρ', '', '', NULL, 25, 193, '1182', 'ee0022e7b1b34eb2b834ea334cda52e7', '0e1982336d8e4bdc867f1620a2bce3be'),
(2379, 'Dove Κρεμοσ/νο Ανταλ Regul 500ml', '', '', NULL, 24, 156, '1183', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(2380, 'Maggi Κύβοι Ζωμού Κότας 6λιτ 12τεμ', '', '', NULL, 25, 182, '1184', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(2381, 'Όλυμπος Βούτυρο Αγελ Πακ 250γρ', '', '', NULL, 25, 164, '1185', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a240e48245964b02ba73d1a86a2739be'),
(2382, 'Γιώτης Ανθός Αραβοσίτου Βανίλια 43γρ', '', '', NULL, 25, 165, '1186', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2383, 'Νουνού Τυρί Γκουντα Light 11% Φετ 175γρ', '', '', NULL, 25, 192, '1187', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2384, 'Κύκνος Κέτσαπ Χ Γλουτ 330γρ', '', '', NULL, 25, 198, '1188', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2385, 'Ωμέγα Special Ρύζι Basmati 1κιλ', '', '', NULL, 25, 186, '1189', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(2386, 'Kerrygold Τυρί Regato Τριμ.400γρ', '', '', NULL, 25, 192, '1190', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2387, '7 Days Κρουασάν Mini Κακάο 107γρ', '', '', NULL, 25, 189, '1191', 'ee0022e7b1b34eb2b834ea334cda52e7', '19c54e78d74d4b64afbb1fd124f01dfc'),
(2388, 'Persil Black Υγρό Απορ Πλυντ Ρούχ 12Μεζ 750ml', '', '', NULL, 22, 121, '1192', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2389, 'Νουνού Γάλα Σκόνη Frisomel 800γρ', '', '', NULL, 21, 121, '1193', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2390, 'Septona Σαμπουάν Και Αφρόλουτρο Βρεφικό Με Λεβαντα 500ml', '', '', NULL, 21, 121, '1194', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2391, 'Άλφα Μπύρα 500ml', '', '', NULL, 23, 134, '1195', 'a8ac6be68b53443bbd93b229e2f9cd34', '329bdd842f9f41688a0aa017b74ffde4'),
(2392, 'Αρκάδι Σαπούνι Πλάκα Πρασ 4Χ150γρ', '', '', NULL, 24, 156, '1196', '8e8117f7d9d64cf1a931a351eb15bd69', '9c86a88f56064f8588d42eee167d1f8a'),
(2393, 'Proderm Υγρό Απορ/κο 17μεζ 1250ml', '', '', NULL, 21, 156, '1197', '8016e637b54241f8ad242ed1699bf2da', '991276688c8c4a91b5524b1115122ec1'),
(2394, 'Vileda Style Κουβάς', '', '', NULL, 22, 133, '1199', 'd41744460283406a86f8e4bd5010a66d', 'b5d54a3d8dd045fb88d5c31ea794dcc5'),
(2395, 'Όλυμπος Τυρί Χωριάτικο Σε Άλμη 400γρ', '', '', NULL, 25, 192, '1200', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2396, 'Καρπούζια Μίνι Εγχ', '', '', NULL, 25, 220, '1201', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2397, 'Frulite Φρουτοπoτό Πορτ/Βερικ 500ml', '', '', NULL, 23, 138, '1203', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2398, 'Άλτις Παραδοσιακό Ελαιόλαδο Παρθένο 1λιτ', '', '', NULL, 25, 177, '1204', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2399, 'Nescafe Classic Στιγμιαίος Καφές 200γρ', '', '', NULL, 25, 173, '1205', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b89cb8dd198748dd8c4e195e4ab2168e'),
(2400, 'Παυλίδης Γκοφρέτα 3bit 31γρ', '', '', NULL, 25, 166, '1207', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2401, 'Finish All In 1 Καψ Πλυντ Πιάτ Max Regular 27τεμ', '', '', NULL, 22, 121, '1208', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2402, 'Gillette Fusion Αντ/κα Ξυραφ 4τεμ', '', '', NULL, 24, 146, '1209', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2403, 'Knorr Ζωμός Κότας 12 κυβ 120γρ', '', '', NULL, 25, 182, '1210', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(2404, 'Νουνού Γάλα Εβαπορέ Light 170γρ', '', '', NULL, 25, 123, '1211', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2405, 'Κοτόπουλα Νωπά Ολόκλ Τ.65% Μιμίκος  Π.Α.Ελλην Συσκ/Να', '', '', NULL, 25, 214, '1212', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(2406, 'Derby Ίον 38γρ', '', '', NULL, 25, 166, '1213', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2407, 'Άλτις Κλασσικό Ελαιόλαδο 2λιτ', '', '', NULL, 25, 177, '1214', 'ee0022e7b1b34eb2b834ea334cda52e7', '1e9187fb112749ff888b11fd64d79680'),
(2408, 'Dettol All In 1 Πράσινο Μήλο 500ml', '', '', NULL, 22, 129, '1215', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2409, 'Wella Flex Mousse Curles/Waves 200ml', '', '', NULL, 24, 150, '1216', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(2410, 'Ajax Uλιτra Υγρό Γενικού Καθαρισμού Λεμόνι 1λιτ', '', '', NULL, 22, 129, '1217', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2411, 'Ballantines Ουίσκι 0,7λιτ', '', '', NULL, 23, 137, '1218', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2412, 'Klinex Σκόνη Πλυντηρίου Ρούχων Original 44μεζ', '', '', NULL, 22, 121, '1219', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2413, 'Svelto Gel Υγρό Πιάτων Με Ξύδι 500ml', '', '', NULL, 22, 121, '1220', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2414, 'Almiron-3 Γάλα Σε Σκόνη Τρίτης Βρεφικής Ηλικίας 800γρ', '', '', NULL, 21, 121, '1221', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2415, 'Λαιμός Χοιρινός Μ/Ο Νωπός Εισ', '', '', NULL, 25, 217, '1222', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(2416, 'Soupline Συμπυκνωμένο Μαλακτικό Ρούχων Λεβάντα 28μεζ', '', '', NULL, 22, 121, '1223', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2417, 'Κρεμμύδια Ξανθά Ξερά Εισ', '', '', NULL, 25, 219, '1224', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2418, 'Nestle Nesquik Ρόφημα Σακούλα 400γρ', '', '', NULL, 25, 185, '1225', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(2419, 'Dettol Απολυμαντικό Για Ρούχα', '', '', NULL, 22, 129, '1226', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2420, 'Γιώτης Super Mousse Κακ 234γρ', '', '', NULL, 25, 165, '1227', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2421, 'Barilla Μακαρ Linguine Bavette Ν13 500γρ', '', '', NULL, 25, 169, '1228', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2422, 'Alfa Πίτσα Μαργαρίτα Κατεψυγμένη 730γρ', '', '', NULL, 25, 171, '1229', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa'),
(2423, 'Γιώτης Φρουιζελέ Φράουλα 2X100γρ', '', '', NULL, 25, 165, '1230', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2424, 'Ariel Alpine Υγρές Καψ 3σε1 24πλ', '', '', NULL, 22, 121, '1231', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2425, 'Pampers Active Baby No4+ 10-15κιλ 16τεμ', '', '', NULL, 21, 122, '1233', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2426, 'Pummaro Κέτσαπ 500γρ', '', '', NULL, 25, 206, '1234', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ce4802b6c9f44776a6e572b3daf93ab1'),
(2427, 'Κιλότο Βόειου Α/Ο Νωπό Εισ', '', '', NULL, 25, 218, '1235', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(2428, 'Ντομάτες Εγχ Υπαιθρ Β ', '', '', NULL, 25, 219, '1236', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2429, 'Hansaplast Φυσική Ελαφρόπετρα', '', '', NULL, 24, 144, '1237', '8e8117f7d9d64cf1a931a351eb15bd69', 'a610ce2a98a94ee788ee5f94b4be82c2'),
(2430, 'Ariel Υγρό Απορρυπαντικό Ρούχων Alpine 28μεζ', '', '', NULL, 22, 121, '1238', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2431, 'Babylino Πάνες Μωρού Sensitive 9-20 κιλ Nο 4+ 19τεμ', '', '', NULL, 21, 122, '1239', '8016e637b54241f8ad242ed1699bf2da', 'e0efaa1776714351a4c17a3a9d412602'),
(2432, 'Κρις Κρις Ψωμί Τοστ Σταρένιο 700gr', '', '', NULL, 25, 194, '1240', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(2433, 'Veet Κρέμα Για Ευαίσθ Επιδ 100ml', '', '', NULL, 24, 146, '1241', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2434, 'Maggi Μείγμα Λαχανικών Νοστιμιά Σε Σκόνη 130γρ', '', '', NULL, 25, 182, '1242', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(2435, 'Dettol Spray Γενικού Καθαρισμού Υγιεινή Και Ασφάλεια Λεμόνι Μέντα 500ml', '', '', NULL, 22, 129, '1243', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2436, 'Pummaro Χυμός Τομάτα Πιο Συμπ/Νος 520γρ', '', '', NULL, 25, 195, '1244', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(2437, 'Kellogg’s Δημητριακά Corn Flakes 375γρ', '', '', NULL, 25, 200, '1245', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(2438, 'Γιώτης Κακάο 125γρ', '', '', NULL, 25, 185, '1246', 'ee0022e7b1b34eb2b834ea334cda52e7', '2d711ee19d17429fa7f964d56fe611db'),
(2439, 'Μεβγάλ Παραδοσιακό Γιαούρτι Κατσικ 220γρ', '', '', NULL, 25, 126, '1247', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2440, 'Johnson\'s Baby Αφρόλουτρο Μπλε 750ml', '', '', NULL, 21, 126, '1248', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2441, 'Misko Μακαρόνια Σπαγγέτι Ν5 500γρ', '', '', NULL, 25, 169, '1249', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2442, 'Μπάρπα Στάθης Τομάτα Στον Τρίφτη 500γρ', '', '', NULL, 25, 195, '1250', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(2443, 'Στεργίου Κέικ Ανάμεικτο 80γρ', '', '', NULL, 25, 170, '1251', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(2444, 'Κοτοπουλα Ολοκληρα Νωπα Τ.65% Πινδος Π.Α.Ελλην Συσκ/Να', '', '', NULL, 25, 214, '1252', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(2445, 'Ferrero Kinder Γάλακτοφέτες 5Χ140γρ', '', '', NULL, 25, 166, '1253', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2446, 'Bref Power Active Wc Block Ωκεαν 50γρ', '', '', NULL, 22, 129, '1254', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2447, 'Κανάκι Φύλλο Κρούστας 450γρ', '', '', NULL, 25, 172, '1255', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2448, 'Νουνού Γάλα Εβαπορέ Light 400γρ', '', '', NULL, 25, 123, '1256', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2449, 'Knorr Ζωμός Σπιτικός Φρεσκ Λαχανικ 4Χ28γρ', '', '', NULL, 25, 182, '1257', 'ee0022e7b1b34eb2b834ea334cda52e7', '3935d6afbf50454595f1f2b99285ce8c'),
(2450, 'Φάγε Γιαούρτι Αγελάδος 2% Λ 3X200γρ', '', '', NULL, 25, 126, '1258', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2451, 'Μπρόκολα Πράσινα Εγχ', '', '', NULL, 25, 219, '1260', 'ee0022e7b1b34eb2b834ea334cda52e7', '9bc82778d6b44152b303698e8f72c429'),
(2452, 'Καραμολέγκος Ψωμί Τοστ Σταρένιο Μίνι 340g', '', '', NULL, 25, 194, '1261', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c928573dd7bc4b7894d450eadd7f5d18'),
(2453, 'Κρι Κρι Γιαούρτι Στραγγιστό 10% 1κιλ', '', '', NULL, 25, 126, '1262', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2454, 'Κοκκινόψαρο  Κτψ Εισ Ε/Ζ', '', '', NULL, 25, 203, '1263', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(2455, 'Λαιμός Χοιρινός Μ/Ο Νωπός Ελλ', '', '', NULL, 25, 217, '1264', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a73f11a7f08b41c081ef287009387579'),
(2456, 'Καλλιμάνης Καλαμαράκι Κομ Καθαρ 595γρ', '', '', NULL, 25, 203, '1265', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(2457, 'Cool Hellas Χυμός Πορτοκαλ Συμπ 1λιτ', '', '', NULL, 23, 138, '1266', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2458, 'Υφαντής Γαλοπούλα Βραστή 160γρ', '', '', NULL, 25, 162, '1267', 'ee0022e7b1b34eb2b834ea334cda52e7', 'be04eae3ca484928a86984d73bf3cc3a'),
(2459, 'Χρυσά Αυγά Ελληνικά Βιολ 6τ Medium 348γρ', '', '', NULL, 25, 163, '1268', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(2460, 'Μπάρμπα Στάθης Αρακάς Λαδερός 1κιλ', '', '', NULL, 25, 204, '1269', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d084e8eab4945cdb4563d7ff49f0dc3'),
(2461, 'Όλυμπος Γάλα Ζωής Λευκό Ελαφρύ Παστ 1λιτ', '', '', NULL, 25, 123, '1270', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2462, 'Sani Lady Sensitive Super N5 10τεμ', '', '', NULL, 24, 148, '1271', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(2463, 'Dirollo Τυρί Cottage 2,2% Λιπ 225γρ', '', '', NULL, 25, 192, '1272', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2464, 'Ίον Σοκολάτα Γάλακτος 45γρ', '', '', NULL, 25, 166, '1273', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2465, 'Κοτόπουλα Νωπά Ολόκλ Τ.65% Π.Α.Ελλην Συσκ/Να', '', '', NULL, 25, 214, '1274', 'ee0022e7b1b34eb2b834ea334cda52e7', '8ef82da99b284c69884cc7f3479df1ac'),
(2466, 'Αύρα Φυσικό Μεταλλικό Νερό 1.5λιτ', '', '', NULL, 23, 135, '1275', 'a8ac6be68b53443bbd93b229e2f9cd34', 'bc4d21162fbd4663b0e60aa9bd65115e'),
(2467, 'Μεβγάλ Harmony 1% Ανανάς 3Χ200γρ', '', '', NULL, 25, 126, '1276', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2468, 'Μίνι Babybel Διχτάκι 6τεμ 120γρ', '', '', NULL, 25, 192, '1277', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2469, 'Γιώτης Αλεύρι Φαρίνα Κόκκινη 500γρ', '', '', NULL, 25, 161, '1278', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c761cd8b18a246eb81fb21858ac10093'),
(2470, 'Γιώτης Τούρτα Μιλφέιγ 532γρ', '', '', NULL, 25, 165, '1279', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2471, 'Γιώτης Κρέμα Ζαχαροπλ Μιλφέιγ 170γρ', '', '', NULL, 25, 165, '1280', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2472, 'Pummaro Χυμός Τομάτα Κλασικός 3Χ250γρ', '', '', NULL, 25, 195, '1281', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a02951b1c083449b9e7fab2fabd67198'),
(2473, '3 Άλφα Ρύζι Νυχάκι Ελληνικό 500γρ', '', '', NULL, 25, 186, '1282', 'ee0022e7b1b34eb2b834ea334cda52e7', '5d0be05c3b414311bcda335b036202f1'),
(2474, 'Εβόλ Γιαούρτι Κατσικίσιο Βιολ 190γρ', '', '', NULL, 25, 126, '1283', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2475, 'Danone Activia Επιδ Γιαουρ Ακτιν 2Χ200γρ', '', '', NULL, 25, 126, '1284', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2476, 'Veet Ταινίες Κρύο Κερί 20τεμ', '', '', NULL, 24, 146, '1286', '8e8117f7d9d64cf1a931a351eb15bd69', '2df01835007545a880dc43f69b5cae07'),
(2477, 'Botanic Therapy Σαμπουάν Επανόρθ 400ml', '', '', NULL, 24, 125, '1287', '8e8117f7d9d64cf1a931a351eb15bd69', '46b02b6b4f4c4d5d8a0efe21d0981027'),
(2478, 'Μεβγάλ Στραγγιστό Γιαούρτι 2% 3Χ200γρ', '', '', NULL, 25, 126, '1288', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2479, 'Sani Υποσέντονα Fresh Maxi Plus 15τεμ', '', '', NULL, 24, 148, '1289', '8e8117f7d9d64cf1a931a351eb15bd69', '0bf072374a8e4c40b915e4972990a417'),
(2480, 'Απαλαρίνα Λικέρ Μαστίχα 500ml', '', '', NULL, 23, 137, '1291', 'a8ac6be68b53443bbd93b229e2f9cd34', '08f280dee57c4b679be0102a8ba1343b'),
(2481, 'Quaker Νιφ Βρώμης Ολ Άλεσης Μεταλ 500γρ', '', '', NULL, 25, 200, '1292', 'ee0022e7b1b34eb2b834ea334cda52e7', '916a76ac76b3462baf2db6dc508b296b'),
(2482, 'Omo Σκόνη 425γρ', '', '', NULL, 22, 121, '1293', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2483, 'Skip Υγρό Πλ Παν/Μικρ 26πλ 910ml', '', '', NULL, 22, 121, '1294', 'd41744460283406a86f8e4bd5010a66d', 'e60aca31a37a40db8a83ccf93bd116b1'),
(2484, 'Πέρκα Φιλέτο Κτψ Εισ Ε/Ζ ', '', '', NULL, 25, 203, '1296', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(2485, 'Μεβγάλ Γάλα Αγελ Λευκό 3,5% Λιπ 2λιτ', '', '', NULL, 25, 123, '1297', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2486, 'Κατσίκια Νωπά Ελλην Γαλ Τεμ Χ/Κ Χ/Σ Ε/Ζ', '', '', NULL, 25, 216, '1298', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd3385ff161f0423aa364017d4413fa77'),
(2487, 'Nan Optipro 1 Γάλα Σε Σκόνη Πρώτης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 21, 216, '1299', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2488, 'Ava Υγρό Πιάτων Ξύδι/Μήλο/Μέντα 430ml', '', '', NULL, 22, 129, '1300', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2489, 'Always Σερβ Night 9τεμ', '', '', NULL, 24, 158, '1301', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2490, 'Υφαντής Hot Dog Nuggets Κοτόπουλου 500γρ', '', '', NULL, 25, 211, '1302', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(2491, 'Υφαντής Ferano Προσούτο Χ Γλουτ 80γρ', '', '', NULL, 25, 198, '1303', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2492, 'Μέλισσα Σπαγγέτι Ολικής Άλεσης 500γρ', '', '', NULL, 25, 169, '1304', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2493, 'Frulite Σαγκουίνι/Μανταρίνι 1λιτ', '', '', NULL, 23, 138, '1305', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2494, 'Δέλτα Smart Επιδ Γιαουρ Φραουλ 2Χ145γρ +1δώρο', '', '', NULL, 25, 126, '1306', 'ee0022e7b1b34eb2b834ea334cda52e7', '0364b4be226146699140e81a469d04a1'),
(2495, 'L\'Oreal Κρέμα Προσ Καν/Μικτ Επιδ 3 Φρον 50ml', '', '', NULL, 24, 149, '1307', '8e8117f7d9d64cf1a931a351eb15bd69', '5a2a0575959c40d6a46614ab99b2d9af'),
(2496, 'Dorodo Τυρί Τριμμ Φακ 80γρ', '', '', NULL, 25, 192, '1308', 'ee0022e7b1b34eb2b834ea334cda52e7', '4c73d0eccd1e4dde8bb882e436a64ebb'),
(2497, 'Chicco Βρέφική Κρέμα Συγκάματος 100ml', '', '', NULL, 21, 124, '1309', '8016e637b54241f8ad242ed1699bf2da', 'ddb733df68324cfc8469c890b32e716d'),
(2498, 'Καραμολέγκος Παξαμάς Κρίθινος 600γρ', '', '', NULL, 25, 209, '1310', 'ee0022e7b1b34eb2b834ea334cda52e7', 'bcebd8cc2f554017864dbf1ce0069ac5'),
(2499, 'Γιώτης Sanilac 1 Γάλα Σε Σκόνη Πρώτης Βρεφικής Ηλικίας 400γρ', '', '', NULL, 21, 209, '1311', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2500, 'Dettol Αντιβ Υγρό Κρεμοσ Ευαίσθ Επιδερμ Αντ/κο 250ml', '', '', NULL, 26, 221, '1312', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6', '8f1b83b1ab3e4ad1a62df8170d1a0a25'),
(2501, 'Παπαδημητρίου Κρέμα Balsamico Με Ρόδι Με Στέβια 250ml', '', '', NULL, 25, 198, '1313', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b1866f1365a54e2d84c28ad2ca7ab5af'),
(2502, 'Στεργίου Λουκουμάς 4τεμ 340γρ', '', '', NULL, 25, 187, '1314', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47b5f0016f4f0eb79e3a4b932f7577'),
(2503, 'Όλυμπος Γάλα Βιολ Υψηλ Παστ 3,7% Λ 1λιτ', '', '', NULL, 25, 123, '1315', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2504, 'Iglo Fish Sticks 300γρ', '', '', NULL, 25, 203, '1316', 'ee0022e7b1b34eb2b834ea334cda52e7', '7ca5dc60dd00483897249e0f8516ee91'),
(2505, 'Γαύρος Νωπός Καθαρ Απεντ/νος Ελλην Μεσογ Συσ/Νος', '', '', NULL, 25, 212, '1317', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(2506, 'Υφαντής Κεφτεδάκια Κτψ 500γρ', '', '', NULL, 25, 211, '1318', 'ee0022e7b1b34eb2b834ea334cda52e7', '9b7795175cbc4a6d9ca37b8ee9bf5815'),
(2507, 'Γιώτης Ρυζόγαλο Στιγμής 105γρ', '', '', NULL, 25, 165, '1320', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2508, '7 Days Swiss Roll Κακάο 200γρ', '', '', NULL, 25, 170, '1321', 'ee0022e7b1b34eb2b834ea334cda52e7', 'e63b2caa8dd84e6ea687168200859baa'),
(2509, 'Fanta Πορτοκαλάδα 1,5λιτ', '', '', NULL, 23, 139, '1322', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2510, 'Γιώτης Κουβερτούρα Σε Σταγόνες 100γρ', '', '', NULL, 25, 166, '1323', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2511, 'Μεβγάλ Γάλα Αγελ Λευκό Light 1,5% 500ml', '', '', NULL, 25, 123, '1324', 'ee0022e7b1b34eb2b834ea334cda52e7', 'b3992eb422c2495ca02dd19de9d16ad1'),
(2512, 'Χρυσά Αυγά Φρέσκα Medium 53/63 γρ.τεμ', '', '', NULL, 25, 163, '1325', 'ee0022e7b1b34eb2b834ea334cda52e7', '6d2babbc7355444ca0d27633207e4743'),
(2513, 'Misko Μακαρόνια Για Παστίτσιο Ν2 500γρ', '', '', NULL, 25, 169, '1326', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2514, 'Χρυσή Ζύμη Μπουγάτσα Θεσ/Κης Κρέμα 850γρ', '', '', NULL, 25, 205, '1327', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2515, 'Τοπ Κρέμα Βαλσάμικο Με Λεμόνι & Μέλι 200ml', '', '', NULL, 25, 181, '1328', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(2516, 'Σολομός Νωπός Φιλετ/νος Με Δέρμα Υδ Νορβ/Εισαγ  Β.Α Ατλ Συσκ/νος', '', '', NULL, 25, 213, '1330', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2517, 'Παπαδημητρίου Balsamico Με Μέλι 250ml', '', '', NULL, 25, 181, '1331', 'ee0022e7b1b34eb2b834ea334cda52e7', '5dca69b976c94eccbf1341ee4ee68b95'),
(2518, 'Tuborg Σόδα 330ml', '', '', NULL, 23, 139, '1332', 'a8ac6be68b53443bbd93b229e2f9cd34', '3010aca5cbdc401e8dfe1d39320a8d1a'),
(2519, 'Cheetos Pacotinia 114γρ', '', '', NULL, 25, 190, '1333', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ec9d10b5d68c4d8b8998d51bf6d67188'),
(2520, 'Johnson Baby Βρεφικό Σαμπουάν Αντλιά 500ml', '', '', NULL, 21, 190, '1334', '8016e637b54241f8ad242ed1699bf2da', '3d0c29b055f8417eb1c679fbfdc37da0'),
(2521, 'Τσίπουρα Υδατ  Καθαρ Ελλην G 400/600 Μεσογ Συσκ/Νη', '', '', NULL, 25, 213, '1335', 'ee0022e7b1b34eb2b834ea334cda52e7', '3d22916b908b40b385bebe4b478cf107'),
(2522, 'Πορτοκ Μερλίν - Λανε Λειτ- Ναβελ Λειτ Κατ Α Εγχ Ε/Ζ', '', '', NULL, 25, 220, '1336', 'ee0022e7b1b34eb2b834ea334cda52e7', 'ea47cc6b2f6743169188da125e1f3761'),
(2523, 'Όλυμπος Φυσικός Χυμός Πορτοκάλι 1λιτ', '', '', NULL, 23, 138, '1337', 'a8ac6be68b53443bbd93b229e2f9cd34', '4f1993ca5bd244329abf1d59746315b8'),
(2524, 'Crunch Σοκολάτα Λευκή 100γρ Χωρίς Γλουτένη', '', '', NULL, 25, 166, '1338', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2525, 'Klinex Χλωρίνη Classic 2λιτ', '', '', NULL, 22, 129, '1339', 'd41744460283406a86f8e4bd5010a66d', '3be81b50494d4b5495d5fea3081759a6'),
(2526, 'Misko Ολικής Άλεσης Μακαρόνια Σπαγγέτι Ν6 500γρ', '', '', NULL, 25, 169, '1341', 'ee0022e7b1b34eb2b834ea334cda52e7', '0c347b96540a427e9823f321861ce58e'),
(2527, 'Καραμολέγκος Πίτες Για Σουβλ Σταρεν 10τεμ 820γρ', '', '', NULL, 25, 205, '1342', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2528, 'Wella Flex Mousse Ultra Strong 200ml', '', '', NULL, 24, 150, '1343', '8e8117f7d9d64cf1a931a351eb15bd69', '5935ab588fa444f0a71cc424ad651d12'),
(2529, 'Alfa Μπουγάτσα Θες/νίκης Κρέμα 800γρ', '', '', NULL, 25, 172, '1344', 'ee0022e7b1b34eb2b834ea334cda52e7', 'd1315c04b3d64aed93472e41d6e5a6f8'),
(2530, 'Γιώτης Μείγμα Για Κρέπες 300γρ', '', '', NULL, 25, 165, '1345', 'ee0022e7b1b34eb2b834ea334cda52e7', 'a1a1c2c477b74504b58ad847f7e0c8e1'),
(2531, 'Σαρδέλλες Νωπές Ελλην Μεσογ Ε/Ζ', '', '', NULL, 25, 212, '1346', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c487e038079e407fb1a356599c2aec3e'),
(2532, 'Alfa Φύλλο Χωριάτικο Κιχι Κτψ 750γρ', '', '', NULL, 25, 205, '1347', 'ee0022e7b1b34eb2b834ea334cda52e7', '1eb56e6ffa2a449296fb1acc7b714cc5'),
(2533, 'Everyday Σερβ Norm/Ultra Plus Sens 18τεμ', '', '', NULL, 24, 158, '1348', '8e8117f7d9d64cf1a931a351eb15bd69', '2bce84e7df694ab1b81486aa2baf555d'),
(2534, 'Γιώτης Sanilac 3 Γάλα Σκόνη 400γρ', '', '', NULL, 21, 158, '1349', '8016e637b54241f8ad242ed1699bf2da', 'fc71b59318b5410d8ed9da8b42904d77'),
(2535, 'Nestle Smarties Κουφετάκια Σοκολ 38γρ', '', '', NULL, 25, 166, '1350', 'ee0022e7b1b34eb2b834ea334cda52e7', 'dca17e0bfb4e469c93c011f8dc8ab512'),
(2536, 'Κιλότο Βόειου Α/Ο Νωπό Ελλ Εκτρ Άνω Των 5 Μην', '', '', NULL, 25, 218, '1352', 'ee0022e7b1b34eb2b834ea334cda52e7', 'c2ce05f4653c4f4fa8f39892bbb98960'),
(2537, 'Χρυσή Ζύμη Πίτσα Μαργαρίτα 2X470γρ', '', '', NULL, 25, 171, '1353', 'ee0022e7b1b34eb2b834ea334cda52e7', '3f38edda7854447a837956d64a2530fa');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_shop`
--

DROP TABLE IF EXISTS `object_shop`;
CREATE TABLE IF NOT EXISTS `object_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `address` varchar(255) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `active_offer` tinyint(1) DEFAULT 0,
  `latitude` decimal(10,7) DEFAULT 0.0000000,
  `longitude` decimal(10,7) DEFAULT 0.0000000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5182 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_shop`
--

TRUNCATE TABLE `object_shop`;
--
-- Άδειασμα δεδομένων του πίνακα `object_shop`
--

INSERT INTO `object_shop` (`id`, `name`, `address`, `description`, `active_offer`, `latitude`, `longitude`) VALUES
(5155, 'Αρισμαρί & Μέλι', '', 'supermarket', 0, '38.0240842', '23.8055564'),
(5156, 'Παλία Αγορά Τρόφιμα', '', 'convenience', 0, '38.0236250', '23.7864978'),
(5157, 'Mini Market', 'Βασ. Γεωργίου Β 11', 'convenience', 0, '38.0208411', '23.7775027'),
(5158, 'Σκλαβενίτης', 'Κηφισίας 7', 'supermarket', 0, '37.9875008', '23.7620167'),
(5159, 'Ψιλικά', 'Πανόρμου 12', 'convenience', 0, '37.9883574', '23.7582721'),
(5160, 'Κατσογιάννης', 'Λαμίας', 'supermarket', 0, '37.9889045', '23.7602338'),
(5161, 'Mini Market1', 'Λαμίας 24', 'convenience', 0, '37.9890495', '23.7591570'),
(5162, 'Μασούτης', 'Λαμίας', 'supermarket', 0, '37.9886895', '23.7603626'),
(5163, 'Mini Market2', '', 'convenience', 0, '37.9889262', '23.7630400'),
(5164, 'Mini Market3', '', 'convenience', 0, '37.9893308', '23.7621603'),
(5165, 'African Asian food matket', '', 'convenience', 0, '37.9888139', '23.7633409'),
(5166, 'Tindahan NG Bayan', '', 'convenience', 0, '37.9877045', '23.7580536'),
(5167, 'Mini Market4', 'Πανόρμου 34', 'convenience', 0, '37.9908687', '23.7595339'),
(5168, 'Ανατολίτικη Αύρα, Μπαχαρικά -Βότανα', '', 'convenience', 0, '38.0273294', '23.8429315'),
(5169, 'Η Μικρή Αγορά (MiniMarket)', '', 'convenience', 0, '38.0273022', '23.8429942'),
(5170, 'Bazaar', 'supermarket', '', 0, '38.0237165', '23.8037239'),
(5171, 'Market In', 'Μεταμορφώσεως', 'supermarket', 0, '38.0256943', '23.8231777'),
(5172, 'Mini Market5', '', 'convenience', 0, '38.0105910', '23.7950829'),
(5173, 'AB city supermarket', '', 'convenience', 0, '38.0111206', '23.7944046'),
(5174, 'Ισιδώρα', 'Ύδρας', 'convenience', 0, '38.0194653', '23.8429315'),
(5175, 'Ok! Anytime markets', '', 'supermarket', 0, '38.0200100', '23.8035107'),
(5176, 'Μασούτης 2', '', 'supermarket', 0, '38.0104033', '23.8009731'),
(5177, 'Mini Market6', '25ης Μαρτίου 20-22', 'convenience', 0, '38.0197310', '23.7961284'),
(5178, 'Mini Market7', 'Ψαρών', 'convenience', 0, '38.0164028', '23.7979668'),
(5179, 'Small Market', '', 'Εθνικής Αντιστάσεως', 0, '38.0157496', '23.7925468'),
(5180, 'Mini Market8', 'Μπιζανίου', 'convenience', 0, '38.0135562', '23.7950614'),
(5181, 'Mini Market9', 'Διονύσου 18', 'convenience', 0, '38.0208465', '23.8081298');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_subcategory`
--

DROP TABLE IF EXISTS `object_subcategory`;
CREATE TABLE IF NOT EXISTS `object_subcategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text DEFAULT '',
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `ekat_id` varchar(255) DEFAULT NULL,
  `ekat_cat_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`name`),
  KEY `object_subcategory_category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_subcategory`
--

TRUNCATE TABLE `object_subcategory`;
--
-- Άδειασμα δεδομένων του πίνακα `object_subcategory`
--

INSERT INTO `object_subcategory` (`id`, `name`, `description`, `category_id`, `category_name`, `ekat_id`, `ekat_cat_id`) VALUES
(121, 'Απορρυπαντικά', '', 21, '', 'e60aca31a37a40db8a83ccf93bd116b1', 'd41744460283406a86f8e4bd5010a66d'),
(122, 'Πάνες', '', 21, '', 'e0efaa1776714351a4c17a3a9d412602', '8016e637b54241f8ad242ed1699bf2da'),
(123, 'Γάλα', '', 21, '', 'b3992eb422c2495ca02dd19de9d16ad1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(124, 'Περιποιήση σώματος', '', 21, '', 'ddb733df68324cfc8469c890b32e716d', '8016e637b54241f8ad242ed1699bf2da'),
(125, 'Σαμπουάν - Αφρόλουτρα', '', 21, '', '46b02b6b4f4c4d5d8a0efe21d0981027', '8e8117f7d9d64cf1a931a351eb15bd69'),
(126, 'Γιαούρτια', '', 21, '', '0364b4be226146699140e81a469d04a1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(127, 'Μωρομάντηλα', '', 21, '', '92680b33561c4a7e94b7e7a96b5bb153', '8016e637b54241f8ad242ed1699bf2da'),
(128, 'Βρεφικές τροφές', '', 21, '', '7e86994327f64e3ca967c09b5803966a', '8016e637b54241f8ad242ed1699bf2da'),
(129, 'Είδη γενικού καθαρισμού', '', 22, '', '3be81b50494d4b5495d5fea3081759a6', 'd41744460283406a86f8e4bd5010a66d'),
(130, 'Χαρτικά', '', 22, '', '034941f08ca34f7baaf5932427d7e635', 'd41744460283406a86f8e4bd5010a66d'),
(131, 'Αποσμητικά Χώρου', '', 22, '', '21051788a9ff4d5d9869d526182b9a5f', 'd41744460283406a86f8e4bd5010a66d'),
(132, 'Εντομoκτόνα - Εντομοαπωθητικά', '', 22, '', '8f98818a7a55419fb42ef1d673f0bb64', 'd41744460283406a86f8e4bd5010a66d'),
(133, 'Είδη κουζίνας - Μπάνιου', '', 22, '', 'b5d54a3d8dd045fb88d5c31ea794dcc5', 'd41744460283406a86f8e4bd5010a66d'),
(134, 'Μπύρες', '', 23, '', '329bdd842f9f41688a0aa017b74ffde4', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(135, 'Εμφιαλωμένα νερά', '', 23, '', 'bc4d21162fbd4663b0e60aa9bd65115e', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(136, 'Κρασιά', '', 23, '', '3d01f4ce48ad422b90b50c62b1f8e7f2', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(137, 'Ποτά', '', 23, '', '08f280dee57c4b679be0102a8ba1343b', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(138, 'Χυμοί', '', 23, '', '4f1993ca5bd244329abf1d59746315b8', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(139, 'Αναψυκτικά - Ενεργειακά Ποτά', '', 23, '', '3010aca5cbdc401e8dfe1d39320a8d1a', 'a8ac6be68b53443bbd93b229e2f9cd34'),
(140, 'Αποσμητικά', '', 24, '', '35410eeb676b4262b651997da9f42777', '8e8117f7d9d64cf1a931a351eb15bd69'),
(141, 'Βαμβάκια', '', 24, '', 'af538008f3ab40989d67f971e407a85c', '8e8117f7d9d64cf1a931a351eb15bd69'),
(142, 'Βαφές μαλλιών', '', 24, '', '09f2e090f72c4487bc44e5ba4fcea466', '8e8117f7d9d64cf1a931a351eb15bd69'),
(143, 'Κρέμες μαλλιών', '', 24, '', 'cf079c66251342b690040650104e160f', '8e8117f7d9d64cf1a931a351eb15bd69'),
(144, 'Λοιπά προϊόντα', '', 24, '', 'a610ce2a98a94ee788ee5f94b4be82c2', '8e8117f7d9d64cf1a931a351eb15bd69'),
(145, 'Υγρομάντηλα', '', 24, '', 'f4d8a256e3944c05a3e7b8904b863882', '8e8117f7d9d64cf1a931a351eb15bd69'),
(146, 'Ξυριστικά - Αποτριχωτικά', '', 24, '', '2df01835007545a880dc43f69b5cae07', '8e8117f7d9d64cf1a931a351eb15bd69'),
(147, 'Οδοντόβουρτσες', '', 24, '', '6db091264f494c86b9cf22a562593c82', '8e8117f7d9d64cf1a931a351eb15bd69'),
(148, 'Πάνες ενηλίκων', '', 24, '', '0bf072374a8e4c40b915e4972990a417', '8e8117f7d9d64cf1a931a351eb15bd69'),
(149, 'Περιποίηση προσώπου', '', 24, '', '5a2a0575959c40d6a46614ab99b2d9af', '8e8117f7d9d64cf1a931a351eb15bd69'),
(150, 'Προϊόντα μαλλιών', '', 24, '', '5935ab588fa444f0a71cc424ad651d12', '8e8117f7d9d64cf1a931a351eb15bd69'),
(151, 'Κρέμα ημέρας', '', 24, '', 'de77af9321844b1f863803f338f4a0c2', '8e8117f7d9d64cf1a931a351eb15bd69'),
(152, 'Κρέμα Σώματος', '', 24, '', 'c44b50bef9674aaeb06b578122bf4445', '8e8117f7d9d64cf1a931a351eb15bd69'),
(153, 'Αντρική περιποίηση', '', 24, '', 'e2f81e96f70e45fb9552452e381529d3', '8e8117f7d9d64cf1a931a351eb15bd69'),
(154, 'Επίδεσμοι', '', 24, '', '1b59d5b58fb04816b8f6a74a4866580a', '8e8117f7d9d64cf1a931a351eb15bd69'),
(155, 'Κρέμες ενυδάτωσης', '', 24, '', 'fefa136c714945a3b6bcdcb4ee9e8921', '8e8117f7d9d64cf1a931a351eb15bd69'),
(156, 'Κρεμοσάπουνα - Σαπούνι', '', 24, '', '9c86a88f56064f8588d42eee167d1f8a', '8e8117f7d9d64cf1a931a351eb15bd69'),
(157, 'Προφυλακτικά', '', 24, '', '7cfab59a5d9c4f0d855712290fc20c7f', '8e8117f7d9d64cf1a931a351eb15bd69'),
(158, 'Σερβιέτες', '', 24, '', '2bce84e7df694ab1b81486aa2baf555d', '8e8117f7d9d64cf1a931a351eb15bd69'),
(159, 'Στοματικά διαλύματα', '', 24, '', '181add033f2d4d95b46844abf619dd30', '8e8117f7d9d64cf1a931a351eb15bd69'),
(160, 'Στοματική υγιεινή', '', 24, '', '26e416b6efa745218f810c34678734b2', '8e8117f7d9d64cf1a931a351eb15bd69'),
(161, 'Αλεύρι - Σιμιγδάλι', '', 25, '', 'c761cd8b18a246eb81fb21858ac10093', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(162, 'Αλλαντικά', '', 25, '', 'be04eae3ca484928a86984d73bf3cc3a', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(163, 'Αυγά', '', 25, '', '6d2babbc7355444ca0d27633207e4743', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(164, 'Βούτυρο - Μαργαρίνη', '', 25, '', 'a240e48245964b02ba73d1a86a2739be', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(165, 'Είδη Ζαχαροπλαστικής', '', 25, '', 'a1a1c2c477b74504b58ad847f7e0c8e1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(166, 'Γλυκά/Σοκολάτες', '', 25, '', 'dca17e0bfb4e469c93c011f8dc8ab512', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(167, 'Επιδόρπια', '', 25, '', '509b949f61cc44f58c2f25093f7fc3eb', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(168, 'Έτοιμα γεύματα/Σούπες', '', 25, '', '1eef696c0f874603a59aed909e1b4ce2', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(169, 'Ζυμαρικά', '', 25, '', '0c347b96540a427e9823f321861ce58e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(170, 'Γλυκά/Κέικ', '', 25, '', 'e63b2caa8dd84e6ea687168200859baa', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(171, 'Κατεψυγμένα/Πίτσες', '', 25, '', '3f38edda7854447a837956d64a2530fa', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(172, 'Κατεψυγμένα/Φύλλα - Βάσεις', '', 25, '', 'd1315c04b3d64aed93472e41d6e5a6f8', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(173, 'Καφέδες', '', 25, '', 'b89cb8dd198748dd8c4e195e4ab2168e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(174, 'Κονσέρβες', '', 25, '', 'df10062ca2a04789bd43d18217008b5f', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(175, 'Τυποποιημένα κρεατικά', '', 25, '', '463e30b829274933ab7eb8e4b349e2c5', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(176, 'Κρέμες γάλακτος', '', 25, '', '4e4cf5616e0f43aaa985c1300dc7109e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(177, 'Λάδι', '', 25, '', '1e9187fb112749ff888b11fd64d79680', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(178, 'Όσπρια', '', 25, '', '50e8a35122854b2b9cf0e97356072f94', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(179, 'Παγωτά', '', 25, '', 'bc66b1d812374aa48d6878730497ede7', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(180, 'Καραμέλες - Τσίχλες', '', 25, '', '7cfe21f0f1944b379f0fead1c8702099', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(181, 'Ξύδι', '', 25, '', '5dca69b976c94eccbf1341ee4ee68b95', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(182, 'Κύβοι', '', 25, '', '3935d6afbf50454595f1f2b99285ce8c', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(183, 'Πελτές τομάτας', '', 25, '', '5aba290bf919489da5810c6122f0bc9b', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(184, 'Πουρές', '', 25, '', 'f6007309d91c4410adf000ffd5e8129e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(185, 'Ροφήματα', '', 25, '', '2d711ee19d17429fa7f964d56fe611db', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(186, 'Ρύζι', '', 25, '', '5d0be05c3b414311bcda335b036202f1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(187, 'Σνάκς/Αρτοσκευάσματα', '', 25, '', 'ea47b5f0016f4f0eb79e3a4b932f7577', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(188, 'Σνάκς/Γαριδάκια', '', 25, '', 'f87bed0b4b8e44c3b532f2c03197aff9', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(189, 'Σνάκς/Κρουασάν', '', 25, '', '19c54e78d74d4b64afbb1fd124f01dfc', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(190, 'Σνάκς/Πατατάκια', '', 25, '', 'ec9d10b5d68c4d8b8998d51bf6d67188', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(191, 'Σνάκς/Ποπ κορν', '', 25, '', '8851b315e2f0486180be07facbc3b21f', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(192, 'Τυριά', '', 25, '', '4c73d0eccd1e4dde8bb882e436a64ebb', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(193, 'Φούρνος/Τσουρέκια', '', 25, '', '0e1982336d8e4bdc867f1620a2bce3be', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(194, 'Φούρνος/Ψωμί', '', 25, '', 'c928573dd7bc4b7894d450eadd7f5d18', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(195, 'Χυμός τομάτας', '', 25, '', 'a02951b1c083449b9e7fab2fabd67198', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(196, 'Μπαχαρικά', '', 25, '', '2ad2e93c1c0c41b4b9769fe06c149393', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(197, 'Σνάκς/Μπάρες - Ράβδοι', '', 25, '', 'df433029824c4b4194b6637db26f69eb', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(198, 'Ειδική διατροφή', '', 25, '', 'b1866f1365a54e2d84c28ad2ca7ab5af', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(199, 'Γλυκά αλλείματα', '', 25, '', 'e397ddcfb34a4640a42b8fa5e999b8c8', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(200, 'Δημητριακά', '', 25, '', '916a76ac76b3462baf2db6dc508b296b', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(201, 'Έτοιμα γεύματα/Σαλάτες', '', 25, '', '4f205aaec31746b89f40f4d5d845b13e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(202, 'Κατεψυγμένα/Πατάτες', '', 25, '', '5c5e625b739b4f19a117198efae8df21', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(203, 'Κατεψυγμένα/Ψάρια', '', 25, '', '7ca5dc60dd00483897249e0f8516ee91', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(204, 'Κατεψυγμένα/Λαχανικά', '', 25, '', '6d084e8eab4945cdb4563d7ff49f0dc3', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(205, 'Κατεψυγμένα/Πίτες', '', 25, '', '1eb56e6ffa2a449296fb1acc7b714cc5', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(206, 'Σάλτσες - Dressings', '', 25, '', 'ce4802b6c9f44776a6e572b3daf93ab1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(207, 'Σνάκς/Μπισκότα', '', 25, '', '35cce434592f489a9ed37596951992b3', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(208, 'Ζάχαρη - Υποκατάστατα ζάχαρης', '', 25, '', 'a885d8cd1057442c9092af37e79bf7a7', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(209, 'Φούρνος/Παξιμάδια', '', 25, '', 'bcebd8cc2f554017864dbf1ce0069ac5', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(210, 'Φούρνος/Φρυγανίες', '', 25, '', 'a483dd538ecd4ce0bdbba36e99ab5eb1', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(211, 'Κατεψυγμένα/Κρεατικά', '', 25, '', '9b7795175cbc4a6d9ca37b8ee9bf5815', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(212, 'Φρέσκα/Αφρόψαρο', '', 25, '', 'c487e038079e407fb1a356599c2aec3e', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(213, 'Φρέσκα/Ψάρι', '', 25, '', '3d22916b908b40b385bebe4b478cf107', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(214, 'Φρέσκα/Κοτόπουλο', '', 25, '', '8ef82da99b284c69884cc7f3479df1ac', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(215, 'Φρέσκα/Αρνί', '', 25, '', '0936072fcb3947f3baf83e31bb5c1cab', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(216, 'Φρέσκα/Κατσίκι', '', 25, '', 'd3385ff161f0423aa364017d4413fa77', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(217, 'Φρέσκα/Χοιρινό', '', 25, '', 'a73f11a7f08b41c081ef287009387579', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(218, 'Φρέσκα/Μοσχάρι', '', 25, '', 'c2ce05f4653c4f4fa8f39892bbb98960', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(219, 'Φρέσκα/Λαχανικά', '', 25, '', '9bc82778d6b44152b303698e8f72c429', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(220, 'Φρέσκα/Φρούτα', '', 25, '', 'ea47cc6b2f6743169188da125e1f3761', 'ee0022e7b1b34eb2b834ea334cda52e7'),
(221, 'Αντισηπτικά', '', 26, '', '8f1b83b1ab3e4ad1a62df8170d1a0a25', 'e4b4de2e31fc43b7b68a0fe4fbfad2e6'),
(222, 'Μάσκες Προσώπου', '', 27, '', '79728a412a1749ac8315501eb77550f9', '2d5f74de114747fd824ca8a6a9d687fa'),
(223, 'Pet shop/Τροφή γάτας', '', 28, '', '926262c303fe402a8542a5d5cf3ac7eb', '662418cbd02e435280148dbb8892782a'),
(224, 'Pet shop/Τροφή σκύλου', '', 28, '', '0c6e42d52765495dbbd06c189a4fc80f', '662418cbd02e435280148dbb8892782a');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `object_user`
--

DROP TABLE IF EXISTS `object_user`;
CREATE TABLE IF NOT EXISTS `object_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `longitude` decimal(10,7) DEFAULT 0.0000000,
  PRIMARY KEY (`id`,`username`),
  UNIQUE KEY `email` (`email`,`password`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Εκκαθάριση του πίνακα πριν την εισαγωγή `object_user`
--

TRUNCATE TABLE `object_user`;
--
-- Άδειασμα δεδομένων του πίνακα `object_user`
--

INSERT INTO `object_user` (`id`, `username`, `password`, `email`, `last_session_id`, `name`, `first_name`, `last_name`, `date_creation`, `address`, `latitude`, `longitude`) VALUES
(17, 'ilias2', '1234', 'elangelis2@yahoo.gr', '', '', '', '', '2023-08-24 01:25:54', '', '0.0000000', '0.0000000'),
(18, 'mpou', '1234!', 'kouper2@yahoo.gr', '', '', '', '', '2023-08-24 01:25:54', '', '0.0000000', '0.0000000'),
(19, 'test', '12344', 'testmails2@yahoo.gr', '', '', '', '', '2023-08-24 01:25:54', '', '0.0000000', '0.0000000'),
(20, 'ilias2', '12345', 'kati2@yahoo.gr', '', '', '', '', '2023-08-24 01:25:54', '', '0.0000000', '0.0000000');

--
-- Δείκτες `object_user`
--
DROP TRIGGER IF EXISTS `OnAfterInsert_CreateUserScoreRecord`;
DELIMITER $$
CREATE TRIGGER `OnAfterInsert_CreateUserScoreRecord` AFTER INSERT ON `object_user` FOR EACH ROW BEGIN
    INSERT INTO Archive_score_TOTAL (user_id,score) VALUES(new.id,0);
END
$$
DELIMITER ;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `archive_product_history`
--
ALTER TABLE `archive_product_history`
  ADD CONSTRAINT `Archive_Product_History_product_id` FOREIGN KEY (`product_id`) REFERENCES `object_product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Archive_Product_History_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `object_shop` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_product_mesitimi`
--
ALTER TABLE `archive_product_mesitimi`
  ADD CONSTRAINT `Archive_Product_MesiTimi_product_id` FOREIGN KEY (`product_id`) REFERENCES `object_product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_score_month`
--
ALTER TABLE `archive_score_month`
  ADD CONSTRAINT `Archive_score_MONTH_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_score_total`
--
ALTER TABLE `archive_score_total`
  ADD CONSTRAINT `Archive_score_TOTAL_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_token_month`
--
ALTER TABLE `archive_token_month`
  ADD CONSTRAINT `Archive_token_MONTH_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_token_total`
--
ALTER TABLE `archive_token_total`
  ADD CONSTRAINT `Archive_token_TOTAL_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_user_actions`
--
ALTER TABLE `archive_user_actions`
  ADD CONSTRAINT `Archive_user_actions_offer_id` FOREIGN KEY (`offer_id`) REFERENCES `object_offer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Archive_user_actions_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `archive_user_score_history`
--
ALTER TABLE `archive_user_score_history`
  ADD CONSTRAINT `Archive_user_score_history_offer_id` FOREIGN KEY (`offer_id`) REFERENCES `object_offer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Archive_user_score_history_user_id` FOREIGN KEY (`user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Archive_user_score_history_user_likes_id` FOREIGN KEY (`user_likes_id`) REFERENCES `archive_user_actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `object_offer`
--
ALTER TABLE `object_offer`
  ADD CONSTRAINT `object_offer_creation_user_id` FOREIGN KEY (`creation_user_id`) REFERENCES `object_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `object_offer_product_id` FOREIGN KEY (`product_id`) REFERENCES `object_product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `object_offer_shop_id` FOREIGN KEY (`shop_id`) REFERENCES `object_shop` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `object_product`
--
ALTER TABLE `object_product`
  ADD CONSTRAINT `object_product_category_id` FOREIGN KEY (`category_id`) REFERENCES `object_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `object_product_subcategory_id` FOREIGN KEY (`subcategory_id`) REFERENCES `object_subcategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Περιορισμοί για πίνακα `object_subcategory`
--
ALTER TABLE `object_subcategory`
  ADD CONSTRAINT `object_subcategory_category_id` FOREIGN KEY (`category_id`) REFERENCES `object_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Συμβάντα
--
DROP EVENT IF EXISTS `EndMonth_TokenBank`$$
CREATE DEFINER=`root`@`localhost` EVENT `EndMonth_TokenBank` ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-31 20:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL EndMonth_UpdateAllUserScore()$$

DROP EVENT IF EXISTS `StartMonth_TokenBank`$$
CREATE DEFINER=`root`@`localhost` EVENT `StartMonth_TokenBank` ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-01 00:00:01' ON COMPLETION NOT PRESERVE ENABLE DO CALL StartMonth_UpdateTokenBankAvailableTokens()$$

DROP EVENT IF EXISTS `Update_and_DeleteOffers`$$
CREATE DEFINER=`root`@`localhost` EVENT `Update_and_DeleteOffers` ON SCHEDULE EVERY 1 DAY STARTS '2023-07-29 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL Update_DeleteExistingOffers()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
