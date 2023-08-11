DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `F_GetOffersProductUser`()
SELECT 	o.id,
		o.shop_id,
        o.product_id,
        o.product_price,
        o.criteriaA,
        o.criteriaB,
        o.creation_date,
        o.likes,
        o.dislikes,
        o.has_stock,
        p.name as productname,
        p.photo as productphoto,
        u.name as userfullname,
        u.username as username,
        u.user_score_sum as userscore
FROM object_offer as o
INNER JOIN object_product as p ON p.id=o.product_id
INNER JOIN object_user AS u ON o.creation_user_id=u.id$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `F_ShopItemCategory`(IN `in_category_name` VARCHAR(255))
BEGIN
	SELECT	shop.id,
    		shop.name,
            shop.address,
            shop.description,
            shop.has_Offer,
            shop.latitude,
            shop.longitude 
    FROM shop 
    INNER JOIN offer ON offer.shop_id=shop.id
    INNER JOIN product ON product.id=offer.product_id
    INNER JOIN subcategory ON subcategory.id=product.subcategory_id
    INNER JOIN category ON category.id=subcategory.category_id
    WHERE shop.has_Offer=TRUE AND offer.IsActive=FALSE AND category.name=in_category_name
    GROUP BY shop.id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `F_ShopName`(IN `in_shop_name` CHAR(255))
BEGIN
    SELECT id,name,address,description,has_Offer,latitude,longitude 
    FROM shop 
    WHERE name=in_shop_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `F_ShopNameAndOffer`(IN `in_shop_name` CHAR(255))
BEGIN
    SELECT id,name,address,description,has_Offer,latitude,longitude 
    FROM shop 
    WHERE has_Offer=TRUE AND name=in_shop_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `F_ShopOffer`()
BEGIN
    SELECT id,name,address,description,has_Offer,latitude,longitude 
    FROM shop 
    WHERE has_Offer=TRUE;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `I_ShopGetOffers`(IN `in_shop_id` INT)
BEGIN
    SELECT  shop.name AS shop_name,
    		shop.latitude AS latitude,
            shop.longitude AS longitude,
            product.id AS product_id, 
            product.name AS product_name,
            offer.product_price AS product_price,
            offer.mesi_timi_day_critiria as criteriaA,
            offer.mesi_timi_week_critiria as criteriaB,
            offer.creation_date AS date,
            offer.likes as likes,
            offer.dislikes as dislikes,
            offer.has_stock as stock
    FROM offer
    INNER JOIN product ON product.id = offer.id
    INNER JOIN shop ON shop.id = offer.shop_id
    WHERE offer.shop_id = in_shop_id;
END$$
DELIMITER ;
