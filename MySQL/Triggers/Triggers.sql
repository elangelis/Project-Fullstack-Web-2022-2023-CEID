

--  object user


DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsert_CreateUserScoreRecord;

DELIMITER $$   
CREATE TRIGGER OnAfterInsert_CreateUserScoreRecord AFTER INSERT  
ON object_user FOR EACH ROW  
BEGIN
    INSERT INTO Archive_score_TOTAL (user_id,score) VALUES(new.id,0);
END$$ 
DELIMITER ; 

-- object offer


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


    -- archive user action


    
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

DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterUpdateUserActions_UpdateIntoUserScoreHistory;

DELIMITER $$   
CREATE TRIGGER OnAfterUpdateUserActions_UpdateIntoUserScoreHistory BEFORE DELETE  
ON Archive_user_actions FOR EACH ROW  
BEGIN
    
    SELECT id,score INTO @oldlikeid,@score FROM Archive_user_score_history where user_id=old.user_id AND user_likes_id=old.id;

    IF (@oldlikeid IS NOT NULL)THEN
        SET @newscore=0-@score;
        INSERT INTO Archive_user_score_history (user_id,score,date,offer_id,user_likes_id) VALUES (old.user_id,@newscore,CURRENT_DATE,old.offer_id,old.id);
    END IF;

END$$ 

DELIMITER ; 


-- archive product history




DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord BEFORE INSERT
ON Archive_Product_History FOR EACH ROW  
BEGIN

    SET new.date=CURRENT_DATE;

END$$

DELIMITER ;


-- archive token bank



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



-- archive score month



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


-- arcchive token month



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
        SELECT SUM(tokens) INTO @prev_tokens FROM Archive_token_TOTAL WHERE user_id=new.user_id;
        
        SET @new_tokens=@prev_tokens+new.token;
        
        UPDATE Archive_token_TOTAL SET tokens=@new_score WHERE user_id=new.user_id;

    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_token_TOTAL (user_id,tokens)VALUES(new.user_id,new.token);
    
    END IF;

END$$

DELIMITER ;











