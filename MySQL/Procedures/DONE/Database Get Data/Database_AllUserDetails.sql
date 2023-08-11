


DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllUserDetails;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllUserDetails()
BEGIN

    SELECT  u.id            AS user_id,
            u.name          AS name,
            u.username      AS username,
            u.password      AS password,
            u.email         AS email,
            u.first_name    AS firstname,
            u.last_name     AS lastname,
            u.date_creation AS creationdate,
            u.address       AS address,
            u.latitude      AS latitude,
            u.longitude     AS longitude,
            s.score         AS total_score

     FROM object_user AS u
     LEFT JOIN Archive_score_TOTAL AS s ON s.user_id=u.id;
    
END$$

DELIMITER ;


