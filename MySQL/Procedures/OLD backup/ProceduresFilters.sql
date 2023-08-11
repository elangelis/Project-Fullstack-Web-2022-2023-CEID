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