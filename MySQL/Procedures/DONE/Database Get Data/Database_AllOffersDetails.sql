
DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllOffersDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllOffersDetails()
BEGIN



SELECT 	o.id                    as offer_id,
        o.shop_id               as shop_id,
        s.name                  as shop_name,
        s.latitude              as latitude,
        s.longitude             as longitude,
        o.product_id            as product_id,
        p.name                  as product_name,
        o.product_price         as product_price,
        o.criteria_A            as criteriaA,
        o.criteria_B            as criteriaB,
        o.creation_date         as date,
        o.likes                 as likes,
        o.dislikes              as dislikes,
        o.has_stock             as stock,
        p.category_id           as category_id,
        p.subcategory_id        as subcategory_id,
        cat.name                as category_name,
        sub.name                as subcategory_name

FROM object_offer as o
INNER JOIN object_product as p ON p.id=o.product_id
INNER JOIN object_shop as s ON s.id=o.shop_id
INNER JOIN object_category as cat ON cat.id=p.category_id
INNER JOIN object_subcategory as sub ON sub.id=p.subcategory_id
GROUP BY o.id;


END$$

DELIMITER ;