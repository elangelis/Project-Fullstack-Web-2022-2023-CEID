
-- FINAL

DROP TABLE IF EXISTS object_offer;

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
    score_sent BOOL NULL DEFAULT FALSE,

    likes INT  NULL DEFAULT 0,
    dislikes INT NULL DEFAULT 0,

    product_price DECIMAL(7,2) NOT NULL,

    PRIMARY KEY (id),

    CONSTRAINT object_offer_shop_id
    FOREIGN KEY (shop_id) REFERENCES object_shop(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT object_offer_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT object_offer_creation_user_id
    FOREIGN KEY (creation_user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION

);

    
    
    DELIMITER ;
    DROP TRIGGER IF EXISTS OnBeforeInsertOffer_ModifyExpiratioDate;

    DELIMITER $$   
    CREATE TRIGGER OnBeforeInsertOffer_ModifyExpiratioDate BEFORE INSERT  
    ON object_offer FOR EACH ROW  
    BEGIN
        SET new.expiration_date=DATE_ADD(new.creation_date,INTERVAL 7 DAY);

    END$$ 
    DELIMITER ; 


--  Update product history

    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterInsertOffer_InsertIntoProductHistory;

    DELIMITER $$   
    CREATE TRIGGER OnAfterInsertOffer_InsertIntoProductHistory AFTER INSERT  
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

        IF(new.score_sent IS NOT NULL AND new.score_sent=false)THEN
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
                SET new.score_sent=true;
            END IF;
        END IF;
        
    END$$ 

    DELIMITER ; 


    DELIMITER ;
    DROP TRIGGER IF EXISTS OnAfterUpdateOffer_InsertIntoUserScoreHistory;

    DELIMITER $$   
    CREATE TRIGGER OnAfterUpdateOffer_InsertIntoUserScoreHistory AFTER UPDATE  
    ON object_offer FOR EACH ROW  
    BEGIN

        IF(new.score_sent IS NOT NULL AND new.score_sent=false)THEN
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
                SET new.score_sent=TRUE;
            END IF;
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
    ON offer FOR EACH ROW  
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