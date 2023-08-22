

-- FINAL



DELIMITER ;
DROP PROCEDURE IF EXISTS ChangeOfferStockStatus;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ChangeOfferStockStatus(IN in_offer_id INTEGER,IN Available BOOLEAN)
BEGIN
    SET @COUNT=NULL;
    SELECT COUNT(*) INTO @COUNT FROM object_offer WHERE id=in_offer_id;
    IF(@COUNT IS NOT NULL AND @COUNT>0)THEN
        UPDATE object_offer SET has_stock=Available WHERE id=in_offer_id;
    END IF;
END$$
DELIMITER ;

CALL ChangeOfferStockStatus(100,FALSE);