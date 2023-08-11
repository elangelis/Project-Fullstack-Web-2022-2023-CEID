
DELIMITER ;
DROP PROCEDURE IF EXISTS Database_UserScores;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS Database_UserScores(IN userid INTEGER)
BEGIN

    SELECT  sm.score as current_score,
            tm.token as current_token,
            st.score as total_score,
            tt.token as total_token

    FROM object_user as u
    INNER JOIN Archive_score_MONTH as sm ON sm.user_id=u.id AND sm.month_start<=CURRENT_DATE AND sm.month_end>=CURRENT_DATE
    INNER JOIN Archive_token_MONTH as tm ON tm.user_id=u.id AND tm.month_start<=CURRENT_DATE AND tm.month_end>=CURRENT_DATE
    INNER JOIN Archive_score_TOTAL as st ON st.user_id=u.id
    INNER JOIN Archive_token_TOTAL as tt ON tt.user_id=u.id
    WHERE u.id=userid;


END$$

DELIMITER ;

CALL Database_UserScores(1);