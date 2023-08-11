
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