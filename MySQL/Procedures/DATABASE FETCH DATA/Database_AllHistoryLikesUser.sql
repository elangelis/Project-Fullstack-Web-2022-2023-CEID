
DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllHistoryLikesUser;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllHistoryLikesUser(IN in_user_id INTEGER)
BEGIN

    SELECT  
            user_likes.user_id          AS user_id,
            u1.username                 AS user_name,
            user_likes.has_Like         AS was_like,
            user_likes.has_dislike      AS was_dislike,
            user_likes.action           AS action,
            user_likes.date             AS action_date,
            offer.id                    AS offer_id,
            offer.shop_id               AS shop_id,
            shop.name                   AS shop_name,
            offer.creation_user_id      AS publisher_id,
            offer.product_id            AS product_id,
            product.name                AS product_name,
            offer.expiration_date       AS offer_expir_date,
            offer.creation_date         AS offer_create_date,
            offer.has_stock             AS stock,
            offer.likes                 AS likes,
            offer.dislikes              AS dislikes,
            offer.product_price         AS offer_price,
            u2.id                       AS publisher_id,
            u2.username                 AS publisher_name
            
    
    FROM user_likes
    INNER JOIN offer ON offer.id=user_likes.offer_id
    INNER JOIN shop ON shop.id=offer.shop_id
    INNER JOIN product ON product.id=offer.product_id
    INNER JOIN user as u1 ON u1.id=user_likes.user_id
    INNER JOIN user as u2 ON u2.id=offer.creation_user_id
    WHERE user_likes.user_id=in_user_id;    
    
END$$

DELIMITER ;

CALL Database_AllHistoryLikesUser(1);