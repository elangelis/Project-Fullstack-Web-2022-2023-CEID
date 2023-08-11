DELIMITER ;

DROP PROCEDURE IF EXISTS UpdateUserScore_SetDefaultScore;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS UpdateUserScore_SetDefaultScore()
BEGIN

    SET @user_maxid=0;
    SET @user_minid=0;
    SET @user_counter=0;

    SELECT MAX(user.id) INTO @user_maxid FROM user;
    SELECT MIN(user.id) INTO @user_minid FROM user;
    SET @user_counter=@user_minid;


    WHILE (@user_counter<=@user_maxid) DO

        SELECT user_score_sum,user_score_month,user_token_sum,user_token_month INTO @OLD_scoreTOTAL,@OLD_score_month,@OLD_tokenTOTAL,@OLD_token_month FROM user
        WHERE id=@user_counter;


        SET @OLD_scoreTOTAL=@OLD_scoreTOTAL+@OLD_score_month;
        SET @OLD_tokenTOTAL=@OLD_tokenTOTAL+@OLD_token_month;
        SET @OLD_token_month=0;
        SET @OLD_score_month=0;

        @user_counter=@user_counter+1;
    END WHILE;

END$$

DELIMITER ;

CALL UpdateUserScore_SetDefaultScore();