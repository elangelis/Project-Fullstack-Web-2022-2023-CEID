


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
            IFNULL((SELECT score FROM archive_score_TOTAL as st WHERE st.user_id=u.id LIMIT 1),0) AS total_score

     FROM object_user AS u;
    
END$$

DELIMITER ;

CALL Database_AllUserDetails();
