
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



