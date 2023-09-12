


DROP PROCEDURE IF EXISTS Database_AllUserLikes;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllUserLikes(IN userid INTEGER)
BEGIN
     IF(userid IS NOT NULL AND userid!=0)THEN
          SELECT	ua.id                    as action_id,
                    ua.offer_id              as offer_id,
                    ua.date                  as date,
                    ua.type                  as action,
                    off.product_price        as product_price,
                    sh.name                  as shop_name,
                    IFNULL(sh.address,0)     as shop_address,
                    uc.username              as offer_user

          FROM object_user AS u
          INNER JOIN archive_user_actions    as ua     ON ua.user_id  =    u.id
          INNER JOIN object_offer            as off    ON off.id      =    ua.offer_id
          INNER JOIN object_shop             as sh     ON sh.id       =    off.shop_id
          INNER JOIN object_user             as uc     ON uc.id       =    off.creation_user_id
          WHERE u.id=1;
     END IF;
     
END$$
DELIMITER ;

CALL Database_AllUserLikes(1);