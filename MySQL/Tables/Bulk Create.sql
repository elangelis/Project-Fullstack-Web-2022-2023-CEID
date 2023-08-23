-- DROP ALL TABLES

DROP TABLE IF EXISTS Archive_token_BANK;        
DROP TABLE IF EXISTS Archive_score_MONTH;
DROP TABLE IF EXISTS Archive_score_TOTAL;
DROP TABLE IF EXISTS Archive_token_MONTH;
DROP TABLE IF EXISTS Archive_token_TOTAL;
DROP TABLE IF EXISTS object_admin;
DROP TABLE IF EXISTS Archive_Product_MesiTimi;
DROP TABLE IF EXISTS Archive_user_score_history;
DROP TABLE IF EXISTS Archive_Product_History;
DROP TABLE IF EXISTS Archive_user_actions;
DROP TABLE IF EXISTS object_offer;
DROP TABLE IF EXISTS object_product;
DROP TABLE IF EXISTS object_shop;
DROP TABLE IF EXISTS object_subcategory;
DROP TABLE IF EXISTS object_category;
DROP TABLE IF EXISTS object_user;


SET @@sql_mode = 'STRICT_TRANS_TABLES'; 



--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_user----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//



-- FINAL TABLE001


DROP TABLE IF EXISTS object_user;

CREATE TABLE object_user
(

    id INTEGER NULL AUTO_INCREMENT,
    username VARCHAR (255) NOT NULL DEFAULT '',
    password VARCHAR (255) NOT NULL DEFAULT '',
    email VARCHAR (255) NOT NULL DEFAULT '',
    
    last_session_id VARCHAR (255) NULL DEFAULT '',

    name VARCHAR (255) NULL DEFAULT '',
    first_name VARCHAR (255) NULL  DEFAULT '',
    last_name VARCHAR (255) NULL DEFAULT '',

    date_creation DATETIME NULL DEFAULT CURRENT_TIMESTAMP,

    address VARCHAR (255) NULL DEFAULT '',

    latitude DECIMAL(10,7)  NULL DEFAULT 0,
    longitude DECIMAL(10,7)  NULL DEFAULT 0,

    PRIMARY KEY(id,username),
    UNIQUE KEY (email,password)
);

    
DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsert_CreateUserScoreRecord;

DELIMITER $$   
CREATE TRIGGER OnAfterInsert_CreateUserScoreRecord AFTER INSERT  
ON object_user FOR EACH ROW  
BEGIN
    INSERT INTO Archive_score_TOTAL (user_id,score) VALUES(new.id,0);
END$$ 
DELIMITER ; 


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_admin----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

-- FINAL    TABLE002

DROP TABLE IF EXISTS object_admin;

CREATE TABLE  object_admin
(
    id VARCHAR(255)  NULL DEFAULT '',
    username VARCHAR(255)  NULL DEFAULT '',
    password VARCHAR(255)  NULL DEFAULT '',
    email VARCHAR(255)  NULL DEFAULT '',

    name VARCHAR(255)  NULL DEFAULT '',
    first_name VARCHAR(255)  NULL DEFAULT '',
    last_name VARCHAR(255)  NULL DEFAULT '',

    isAdmin BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id,name)
);


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_category----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

-- FINAL TABLE003




DROP TABLE IF EXISTS object_category;


CREATE TABLE IF NOT EXISTS object_category
(
    id INT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL DEFAULT '',
    description VARCHAR(255) NULL DEFAULT '',
    
    -- ekatanalotis
    ekat_id VARCHAR(255) NULL DEFAULT '',

    PRIMARY KEY(id)

);






--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_subcategory----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

-- FINAL TABLE004



DROP TABLE IF EXISTS object_subcategory;

CREATE TABLE IF NOT EXISTS object_subcategory
(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (255) NOT NULL DEFAULT '',
    description TEXT (255) NULL DEFAULT '',
    
    -- categories
    category_id INT NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    
    -- ekatanalotis
    ekat_id VARCHAR(255) NULL,
    ekat_cat_id VARCHAR(255) NULL,
    
    PRIMARY KEY(id,name),

    CONSTRAINT object_subcategory_category_id
    FOREIGN KEY (category_id) REFERENCES object_category(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);



--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_product----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE005


DROP TABLE IF EXISTS object_product;

CREATE TABLE IF NOT EXISTS object_product
(
    id INT NULL AUTO_INCREMENT,
    name VARCHAR (255) NOT NULL DEFAULT '',
    description TEXT (255) NULL DEFAULT '',

    -- photo
    photourl TEXT(255) NULL DEFAULT '',
    photo_DATA  LONGBLOB NULL DEFAULT NULL,

    -- categories
    category_id INT NOT NULL DEFAULT 0,
    subcategory_id INT NOT NULL DEFAULT 0,
    

    -- ekatanalotis
    ekat_id VARCHAR(255)  NULL DEFAULT '',
    ekat_cat_id VARCHAR(255)  NULL DEFAULT '',
    ekat_sub_id VARCHAR(255)  NULL DEFAULT '',


    PRIMARY KEY(id,name),

    CONSTRAINT object_product_category_id
    FOREIGN KEY (category_id) REFERENCES object_category(id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT object_product_subcategory_id
    FOREIGN KEY (subcategory_id) REFERENCES object_subcategory(id)
    ON UPDATE CASCADE ON DELETE CASCADE

    
);


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_shop----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

-- FINAL    TABLE006

DROP TABLE IF EXISTS object_shop;


CREATE TABLE object_shop
(
    id INTEGER NULL AUTO_INCREMENT,
    name VARCHAR (255) NULL DEFAULT '',
    address VARCHAR (255) NULL DEFAULT '',
    description VARCHAR (255) NULL DEFAULT '',
    active_offer BOOLEAN NULL DEFAULT FALSE,

    latitude DECIMAL(10,7) NULL DEFAULT 0,
    longitude DECIMAL(10,7) NULL DEFAULT 0,

    PRIMARY KEY(id),
    UNIQUE KEY(name)
);





--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------object_offer----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE007

-- FINAL

CREATE TABLE object_offer
(
    id INT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    product_id INT NOT NULL,

    has_stock BOOLEAN NULL DEFAULT TRUE,

    creation_date DATE NULL DEFAULT CURRENT_DATE,
    expiration_date DATE NULL,
    criteria_A BOOL NULL DEFAULT FALSE,
    criteria_B BOOL NULL DEFAULT FALSE,

    creation_user_id INT NULL,

    likes INT  NULL DEFAULT 0,
    dislikes INT NULL DEFAULT 0,

    product_price DECIMAL(7,2) NOT NULL,

    PRIMARY KEY (id),

    CONSTRAINT object_offer_shop_id
    FOREIGN KEY (shop_id) REFERENCES object_shop(id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT object_offer_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT object_offer_creation_user_id
    FOREIGN KEY (creation_user_id) REFERENCES object_user(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);

    
    
    DELIMITER ;

    DROP TRIGGER IF EXISTS OnBeforeInsertOffer_ModifyExpirationDate;

    DELIMITER $$   
    CREATE TRIGGER IF NOT EXISTS OnBeforeInsertOffer_ModifyExpirationDate BEFORE INSERT  
    ON object_offer FOR EACH ROW  
    BEGIN
        SET new.expiration_date=DATE_ADD(new.creation_date,INTERVAL 7 DAY);

    END$$ 
    DELIMITER ; 


--  Update product history

    DELIMITER ;

    DROP TRIGGER IF EXISTS OnAfterInsertOffer_InsertIntoProductHistory;

    DELIMITER $$   
    CREATE TRIGGER IF NOT EXISTS OnAfterInsertOffer_InsertIntoProductHistory AFTER INSERT  
    ON object_offer FOR EACH ROW  
    BEGIN

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
    END$$ 
    DELIMITER ; 


    DELIMITER ;  
    DROP TRIGGER IF EXISTS OnAfterUpdateOffer_InsertIntoProductHistory;

    DELIMITER $$ 
    CREATE TRIGGER OnAfterUpdateOffer_InsertIntoProductHistory AFTER UPDATE
    ON object_offer FOR EACH ROW  
    BEGIN

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

    END$$ 
    DELIMITER ; 


--  Update Archive Product History


--  Update Archive user score history

    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterInsertOffer_InsertIntoUserScoreHistory;

    DELIMITER $$   
    CREATE TRIGGER OnAfterInsertOffer_InsertIntoUserScoreHistory AFTER INSERT  
    ON object_offer FOR EACH ROW  
    BEGIN


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
        
    END$$ 

    DELIMITER ; 


    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterUpdateOffer_InsertIntoUserScoreHistory;

    DELIMITER $$   
    CREATE TRIGGER OnAfterUpdateOffer_InsertIntoUserScoreHistory AFTER UPDATE  
    ON object_offer FOR EACH ROW  
    BEGIN

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
        
    END$$ 

    DELIMITER ; 

--  Update user score history


--  UPDATE shop has offer flag

    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterUpdateOffer_UpdateShopHasOffer;

    DELIMITER $$   
    CREATE TRIGGER OnAfterUpdateOffer_UpdateShopHasOffer AFTER UPDATE  
    ON object_offer FOR EACH ROW  
    BEGIN

        UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;

    END $$

    DELIMITER ;



    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterInsertOffer_UpdateShopHasOffer;

    DELIMITER $$   
    CREATE TRIGGER OnAfterInsertOffer_UpdateShopHasOffer AFTER INSERT  
    ON object_offer FOR EACH ROW  
    BEGIN

    UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;

    END $$
    DELIMITER ;



    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterDeleteOffer_UpdateShopHasOffer;

    DELIMITER $$   
    CREATE TRIGGER OnAfterDeleteOffer_UpdateShopHasOffer AFTER DELETE  
    ON object_offer FOR EACH ROW  
    BEGIN

        SET @count_offers=0;
        
        SELECT COUNT(*) INTO @count_offers FROM object_offer WHERE shop_id=old.shop_id;
        
        IF(@count_offers IS NULL OR @count_offers=0)THEN
            UPDATE object_shop SET active_offer=FALSE WHERE id=old.shop_id;
        ELSEIF(@count_offers IS NOT NULL AND @count_offers>0)THEN
            UPDATE object_shop SET active_offer=TRUE WHERE id=old.shop_id;
        END IF;

    END $$

    DELIMITER ;

--  UPDATE shop has offer flag


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_Product_MesiTimi----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE 012

DROP TABLE IF EXISTS Archive_Product_MesiTimi;

CREATE TABLE IF NOT EXISTS Archive_Product_MesiTimi
(
    id INT NULL AUTO_INCREMENT,
    product_id INTEGER NOT NULL,
    mesi_timi DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL ,


    PRIMARY KEY (id),

    CONSTRAINT Archive_Product_MesiTimi_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_user_actions----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//

-- FINAL    TABLE013

DROP TABLE IF EXISTS Archive_user_actions;

SET @@sql_mode = 'STRICT_TRANS_TABLES'; 

CREATE TABLE IF NOT EXISTS Archive_user_actions
(
    id INT NULL AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    offer_id INTEGER NOT NULL,
    date DATE NULL DEFAULT CURRENT_TIMESTAMP,

    type ENUM ('like','dislike') NOT NULL,

    PRIMARY KEY (id),

    CONSTRAINT Archive_user_actions_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT Archive_user_actions_offer_id
    FOREIGN KEY (offer_id) REFERENCES object_offer(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);


DELIMITER ;
DROP TRIGGER IF EXISTS OnBeforeInsertUserActions_ModifyDateCurrentRecord;

DELIMITER $$   
CREATE TRIGGER OnBeforeInsertUserActions_ModifyDateCurrentRecord BEFORE INSERT  
ON Archive_user_actions FOR EACH ROW  
BEGIN
    SET new.date=CURRENT_TIMESTAMP;
END$$
DELIMITER ;



DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsertUserActions_InsertIntoUserScoreHistory;

DELIMITER $$   
CREATE TRIGGER OnAfterInsertUserActions_InsertIntoUserScoreHistory AFTER INSERT  
ON Archive_user_actions FOR EACH ROW  
BEGIN
    IF (new.type=1) THEN
        INSERT INTO Archive_user_score_history (user_id,offer_id,user_likes_id,date,score) 
            VALUES(new.user_id,new.offer_id,new.id,CURRENT_TIMESTAMP,5);
    ELSEIF (new.type=2) THEN
        INSERT INTO Archive_user_score_history (user_id,offer_id,user_likes_id,date,score) 
            VALUES(new.user_id,new.offer_id,new.id,CURRENT_TIMESTAMP,-1);
    END IF;
END$$ 

DELIMITER ; 



DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterUpdateUserActions_UpdateIntoUserScoreHistory;

DELIMITER $$   
CREATE TRIGGER OnAfterUpdateUserActions_UpdateIntoUserScoreHistory AFTER UPDATE  
ON Archive_user_actions FOR EACH ROW  
BEGIN

    IF (new.type<>old.type AND new.type=1) THEN
    	SET @score=6;
    	UPDATE Archive_user_score_history SET date=CURRENT_TIMESTAMP,score=@score WHERE offer_id=new.offer_id AND user_id=new.user_id;
    ELSEIF (new.type<>old.type AND new.type=2) THEN
        SET @score=(-6);
        UPDATE Archive_user_score_history SET date=CURRENT_TIMESTAMP,score=@score WHERE offer_id=new.offer_id AND user_id=new.user_id;
    END IF;

END$$ 

DELIMITER ; 


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_user_score_history----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE014

DROP TABLE IF EXISTS Archive_user_score_history;

CREATE TABLE IF NOT EXISTS Archive_user_score_history
(

     id INT NOT NULL AUTO_INCREMENT,
     user_id INTEGER NOT NULL,

     offer_id INTEGER NOT NULL,
     user_likes_id INTEGER DEFAULT NULL,

     date DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),

     score INTEGER,

     PRIMARY KEY (id),

     CONSTRAINT Archive_user_score_history_user_id
     FOREIGN KEY (user_id) REFERENCES object_user(id)
     ON UPDATE CASCADE ON DELETE CASCADE,

     CONSTRAINT Archive_user_score_history_offer_id
     FOREIGN KEY (offer_id) REFERENCES object_offer(id)
     ON UPDATE CASCADE ON DELETE CASCADE,

     CONSTRAINT Archive_user_score_history_user_likes_id
     FOREIGN KEY (user_likes_id) REFERENCES Archive_user_actions(id)
     ON UPDATE CASCADE ON DELETE CASCADE

);




--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_Product_History----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE015

DROP TABLE IF EXISTS Archive_Product_History;

CREATE TABLE IF NOT EXISTS Archive_Product_History
(
    id INT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    product_id INTEGER NOT NULL,
    product_price DECIMAL(10,2) NOT NULL,
    date DATE NULL DEFAULT CURRENT_DATE,


    PRIMARY KEY (id),

    CONSTRAINT Archive_Product_History_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT Archive_Product_History_shop_id
    FOREIGN KEY (shop_id) REFERENCES object_shop(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);



DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord BEFORE INSERT
ON Archive_Product_History FOR EACH ROW  
BEGIN

    SET new.date=CURRENT_DATE;

END$$

DELIMITER ;




--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_token_BANK----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE016


DROP TABLE IF EXISTS Archive_token_BANK;

CREATE TABLE IF NOT EXISTS Archive_token_BANK
(
    id INTEGER NULL AUTO_INCREMENT,
    users_count INTEGER NULL DEFAULT 0,
    token_TOTAL INTEGER NULL DEFAULT 0,
    token_AVAILABLE INTEGER NULL DEFAULT 0,

    date_created  DATE NULL DEFAULT (CURRENT_DATE),
    datetime_created DATETIME NULL DEFAULT (CURRENT_TIMESTAMP),
    
    month_start DATE  NULL,
    month_end DATE  NULL,        
    month INTEGER  NULL,
    year INTEGER  NULL,


    PRIMARY KEY(id,date_created)

);


DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveTokenBANK_ModifyDatesCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveTokenBANK_ModifyDatesCurrentRecord BEFORE INSERT
ON Archive_token_BANK FOR EACH ROW  
BEGIN

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

END$$

DELIMITER ;








--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_score_MONTH----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE 017


DROP TABLE IF EXISTS Archive_score_MONTH;

CREATE TABLE IF NOT EXISTS Archive_score_MONTH
(
    id INT NULL AUTO_INCREMENT,
    
    user_id INT NOT NULL,
    score INTEGER UNSIGNED  NULL DEFAULT 0,

    date_created DATE NULL DEFAULT CURRENT_DATE,
    
    month_start DATE  NULL,
    month_end DATE  NULL,        
    month INTEGER  NULL,
    year INTEGER  NULL,


    PRIMARY KEY (id),


    CONSTRAINT Archive_score_MONTH_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE CASCADE ON DELETE CASCADE


);



DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveScoreMonth_ModifyDatesCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveScoreMonth_ModifyDatesCurrentRecord BEFORE INSERT
ON Archive_score_MONTH FOR EACH ROW  
BEGIN

    SET @month_start =   DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY);
    SET @month_end   =   LAST_DAY(CURRENT_DATE);
    SET @month       =   MONTH(CURRENT_DATE);
    SET @year        =   YEAR(CURRENT_DATE);

    SET new.month_start=@month_start;
    SET new.month_end=@month_end;
    SET new.month=@month;
    SET new.year=@year;
    SET new.date_created=CURRENT_DATE;

END$$

DELIMITER ;

-- insert into Archive_score_MONTH(user_id,score)VALUES(1,19000);
-- insert into Archive_score_MONTH(user_id,score)VALUES(2,-200);


DELIMITER ;  
DROP TRIGGER IF EXISTS OnAfterInsertArchiveScoreMonth_InsertUpdateScoreTotal;

DELIMITER $$ 
CREATE TRIGGER OnAfterInsertArchiveScoreMonth_InsertUpdateScoreTotal AFTER INSERT
ON Archive_score_MONTH FOR EACH ROW  
BEGIN

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

END$$

DELIMITER ;


--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_score_TOTAL----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//






-- FINAL    TABLE018


DROP TABLE IF EXISTS Archive_score_TOTAL;

CREATE TABLE IF NOT EXISTS Archive_score_TOTAL
(
    id INT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    score INTEGER UNSIGNED NULL DEFAULT 0,

    PRIMARY KEY (id),

    CONSTRAINT Archive_score_TOTAL_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);





--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_token_MONTH----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//


-- FINAL    TABLE019

DROP TABLE IF EXISTS Archive_token_MONTH;

CREATE TABLE IF NOT EXISTS Archive_token_MONTH
(
    id INT NULL AUTO_INCREMENT,
    
    user_id INT NOT NULL,
    token INTEGER UNSIGNED NULL DEFAULT 0,
    
    date_created DATE NULL DEFAULT CURRENT_DATE,
    month_start DATE NULL,
    month_end DATE NULL,        
    month INTEGER NULL,
    year INTEGER NULL,


    PRIMARY KEY (id),


    CONSTRAINT Archive_token_MONTH_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE CASCADE ON DELETE CASCADE
    
);

DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchivetokenMONTH_ModifyDatesCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchivetokenMONTH_ModifyDatesCurrentRecord BEFORE INSERT
ON Archive_token_MONTH FOR EACH ROW  
BEGIN

    SET @month_start =   DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY);
    SET @month_end   =   LAST_DAY(CURRENT_DATE);
    SET @month       =   MONTH(CURRENT_DATE);
    SET @year        =   YEAR(CURRENT_DATE);

    SET new.month_start=@month_start;
    SET new.month_end=@month_end;
    SET new.month=@month;
    SET new.year=@year;
    SET new.date_created=CURRENT_DATE;

END$$

DELIMITER ;


DELIMITER ;  
DROP TRIGGER IF EXISTS OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal;

DELIMITER $$ 
CREATE TRIGGER OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal AFTER INSERT
ON Archive_token_MONTH FOR EACH ROW  
BEGIN

    SET @count=0;
    SELECT COUNT(*) INTO @count FROM Archive_token_TOTAL WHERE user_id=new.user_id;
    -- check if record exists
    IF (@count IS NOT NULL AND @count>0) THEN
        -- modify previous one
        SELECT SUM(score) INTO @prev_tokens FROM Archive_token_TOTAL WHERE user_id=new.user_id;
        
        SET @new_tokens=@prev_tokens+new.token;
        
        UPDATE Archive_token_TOTAL SET score=@new_score WHERE user_id=new.user_id;

    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_token_TOTAL (user_id,token)VALUES(new.user_id,new.token);
    
    END IF;

END$$

DELIMITER ;
--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_token_TOTAL----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//




-- FINAL    TABLE020

DELIMITER ;
DROP TABLE IF EXISTS Archive_token_TOTAL;

CREATE TABLE IF NOT EXISTS Archive_token_TOTAL
(
    id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    tokens INTEGER UNSIGNED DEFAULT 0,

    PRIMARY KEY (id),

    CONSTRAINT Archive_token_TOTAL_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE CASCADE ON DELETE CASCADE

);


DELIMITER ;
--  //---------------------------------------------------------------------------------------------------------------------------------------//
--  //-----------------------------------------------------------Archive_Product_MesiTimi----------------------------------------------------------//
--  //---------------------------------------------------------------------------------------------------------------------------------------//




