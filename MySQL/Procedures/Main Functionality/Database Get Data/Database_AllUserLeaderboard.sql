
DELIMITER ;
DROP PROCEDURE IF EXISTS Database_AllUserLeaderboard;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_AllUserLeaderboard()
BEGIN

    SELECT 	u.username                                              as username,
    		CONCAT( u.first_name, " ", u.last_name )                as full_name,
            u.date_creation                                         as date_created,
            IFNULL(s.score,0)                                       as total_score,
            COUNT(o.id)                                             as offers,
			( SELECT COUNT(*) FROM archive_user_actions as a WHERE user_id = u.id AND type = 1 )                    as likes,
			( SELECT COUNT(*) FROM archive_user_actions as a WHERE user_id = u.id AND type = 2 )                    as dislikes,
            IFNULL( (SELECT token FROM Archive_token_MONTH as tm WHERE tm.user_id = u.id AND tm.month_start<=CURRENT_DATE AND tm.month_end>=CURRENT_DATE),0)    as current_tokens,
            IFNULL(( SELECT tokens FROM Archive_token_TOTAL as tt WHERE tt.user_id = u.id),0)                                                                   as total_tokens
            
			      
    FROM object_user as u
    INNER JOIN archive_score_total   as s on s.user_id=u.id
	LEFT  JOIN object_offer          	as o on o.creation_user_id=u.id
    GROUP BY u.id
    ORDER BY total_score DESC;


END$$
DELIMITER ;

CALL Database_AllUserLeaderboard();