
DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllUserOffers;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllUserOffers(IN in_user_id INTEGER)
BEGIN

    SELECT  o.id                    AS offer_id,
            o.shop_id               AS shop_id,
            s.name                   AS shop_name,
            o.product_id            AS product_id,
            p.name                AS product_name,
            o.has_stock             AS stock,
            o.creation_date         AS creation_date,
            o.expiration_date       AS expiration_date,
            o.creation_user_id      AS user_id,
            u.username               AS user_name,
            o.likes                 AS likes,
            o.dislikes              AS dislikes,
            o.product_price         AS offer_price
            
    FROM object_offer as o

    INNER JOIN object_shop      AS s    ON s.id     =   o.shop_id
    INNER JOIN object_product   AS p    ON p.id     =   o.product_id
    INNER JOIN object_user      AS u    ON u.id     =   o.creation_user_id
    
    WHERE o.creation_user_id    =   in_user_id
    GROUP BY o.id;
    
END$$

DELIMITER ;

CALL Database_AllUserOffers(1);