  
 -- //----------------------------------object user-----------------------------------//
 -- //--------------------------------------------------------------------------------//
 -- //--------------------------------------------------------------------------------//
 
DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsertUser_CreateUserScoreRecord;

DELIMITER $$   
CREATE TRIGGER OnAfterInsert_CreateUserScoreRecord AFTER INSERT ON object_user FOR EACH ROW  
BEGIN
    INSERT INTO Archive_score_TOTAL (user_id,score) VALUES(new.id,0);
END$$ 


 -- //----------------------------------object offer----------------------------------//
 -- //--------------------------------------------------------------------------------//
 -- //--------------------------------------------------------------------------------//

                    -- Modify expiration Date
DELIMITER ;
DROP TRIGGER IF EXISTS OnBeforeInsertOffer_ModifyExpiratioDate;

DELIMITER $$   
CREATE TRIGGER OnBeforeInsertOffer_ModifyExpiratioDate BEFORE INSERT ON object_offer FOR EACH ROW  
BEGIN
     SET new.expiration_date=DATE_ADD(new.creation_date,INTERVAL 7 DAY);
END$$ 


     
                    -- Update shop that has active offer
DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsertOffer_UpdateShopHasOffer;

DELIMITER $$   
CREATE TRIGGER OnAfterInsertOffer_UpdateShopHasOffer AFTER INSERT ON object_offer FOR EACH ROW  
BEGIN
     UPDATE object_shop SET active_offer=TRUE WHERE id=new.shop_id;
END $$


                    --  Insert into product History or Delete Previous Record And Insert New

DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsertOffer_InsertIntoProductHistory;
DELIMITER $$   
CREATE TRIGGER OnAfterInsertOffer_InsertIntoProductHistory AFTER INSERT  
ON object_offer FOR EACH ROW  
BEGIN

     SET @historyexists=0;

     SELECT COUNT(*) INTO @historyexists FROM Archive_Product_History as ph
     WHERE ph.date=CURRENT_DATE AND ph.product_id = new.product_id AND ph.shop_id = new.shop_id;

     IF (@historyexists=0 or @historyexists IS NULL)THEN
          INSERT INTO Archive_Product_History (shop_id,product_id,date,product_price)
               VALUES(new.shop_id,new.product_id,CURRENT_DATE,new.product_price);

     ELSEIF(@historyexists>0)THEN
          UPDATE Archive_Product_History SET product_price=new.product_price WHERE date=CURRENT_DATE AND product_id = new.product_id AND shop_id = new.shop_id;
     END IF;
END$$ 
                    --  Insert into product History or Delete Previous Record And Insert New

DELIMITER ;  
DROP TRIGGER IF EXISTS OnAfterUpdateOffer_InsertIntoProductHistory;
DELIMITER $$ 
CREATE TRIGGER OnAfterUpdateOffer_InsertIntoProductHistory AFTER UPDATE ON object_offer FOR EACH ROW  
BEGIN

     SET @historyexists=0;

     SELECT COUNT(*) INTO @historyexists FROM Archive_Product_History as ph
     WHERE ph.date=CURRENT_DATE AND ph.product_id = new.product_id AND ph.shop_id = new.shop_id;

     IF (@historyexists=0 or @historyexists IS NULL)THEN
          INSERT INTO Archive_Product_History (shop_id,product_id,date,product_price)
               VALUES(new.shop_id,new.product_id,CURRENT_DATE,new.product_price);

     ELSEIF(@historyexists>0)THEN
               UPDATE Archive_Product_History SET product_price=new.product_price WHERE date=CURRENT_DATE AND product_id = new.product_id AND shop_id = new.shop_id;
     END IF;
END$$ 



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