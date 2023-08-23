




DELIMITER ;
DROP PROCEDURE IF EXISTS UserScoreAndTokens;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS UserScoreAndTokens(IN userid INTEGER)
BEGIN
     IF(userid IS NOT NULL AND userid!=0)THEN
          SELECT    u.username               as  username,
                    u.password               as  password,
                    IFNULL(st.score,0)       as  score_total,
                    IFNULL(sm.score,0)       as  score_month,
                    IFNULL(tt.tokens,0)      as  tokens_total,
                    IFNULL(tm.token,0)       as  tokens_month

          FROM object_user as u
          LEFT JOIN archive_score_total as st ON st.user_id=userid 
          LEFT JOIN archive_score_month as sm ON sm.user_id=userid
          LEFT JOIN archive_token_total as tt ON tt.user_id=userid
          LEFT JOIN archive_token_month as tm ON tm.user_id=userid
          WHERE u.id=userid;
     END IF;
END$$
DELIMITER ;

CALL UserScoreAndTokens(1);