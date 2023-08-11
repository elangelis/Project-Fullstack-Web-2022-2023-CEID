DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `I_ShopGetOffers`(IN `in_shop_id` INT)
BEGIN
    SELECT  shop.name,
            product.id, 
            product.name,
            offer.product_price,
            offer.mesi_timi_day_critiria as 5ai,
            offer.mesi_timi_week_critiria as 5aii,
            offer.creation_date,
            offer.likes,
            offer.dislikes,
            offer.has_stock
    FROM offer
    INNER JOIN product ON product.id = offer.id
    INNER JOIN shop ON shop.id = offer.shop_id
    WHERE offer.shop_id = in_shop_id;
END$$
DELIMITER ;

