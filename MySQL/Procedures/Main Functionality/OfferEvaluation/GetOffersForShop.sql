
DROP PROCEDURE IF EXISTS F_GetOffersProductUser;


DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS F_GetOffersProductUser()
BEGIN

     SELECT 	o.id,
		o.shop_id,
          o.product_id,
          o.product_price,
          o.criteria_A,
          o.criteria_B,
          o.creation_date,
          o.likes,
          o.dislikes,
          o.has_stock,
          p.name as productname,
          p.photourl as photo_url,
          IFNULL(p.photo_DATA,"empty") as photoBlob,
          u.name as userfullname,
          u.username as username,
          IFNULL((SELECT score FROM archive_score_TOTAL as st WHERE st.user_id=u.id LIMIT 1),0) AS  userscore

     FROM object_offer as o
     INNER JOIN object_product as p ON p.id=o.product_id
     INNER JOIN object_user AS u ON o.creation_user_id=u.id;

END$$

DELIMITER ;
CALL F_GetOffersProductUser();