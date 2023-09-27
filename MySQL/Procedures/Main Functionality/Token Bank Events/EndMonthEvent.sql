DROP EVENT IF EXISTS EndMonth_TokenBank;

CREATE EVENT IF NOT EXISTS EndMonth_TokenBank ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-31 20:00:00' 
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL EndMonth_UpdateAllUserScore();



DELIMITER ;
DROP PROCEDURE IF EXISTS EndMonth_UpdateAllUserScore;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS EndMonth_UpdateAllUserScore()
BEGIN

    SET @user_count=0;
    SELECT COUNT(*) INTO @user_count FROM object_user;
    SELECT MAX(id)  INTO @user_max_id FROM object_user;
    SELECT MIN(id)  INTO @user_min_id FROM object_user;
        
    SET @user_pointer=0;
    IF (@user_min_id IS NOT NULL) THEN
        SET @user_pointer=@user_min_id;
    END IF;

    SET @token_avail=0;
    SELECT token_AVAILABLE INTO @token_avail from Archive_token_BANK WHERE month_start=DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY) AND month_end=LAST_DAY(CURRENT_DATE);
        
    SET @score_month_TOTAL=0;
    SELECT SUM(score) INTO @score_month_TOTAL from Archive_user_score_history WHERE date>=DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY) AND date<=LAST_DAY(CURRENT_DATE);


    IF (@token_avail>0) THEN
        IF(@score_month_TOTAL>0)THEN
            WHILE (@user_pointer<@user_max_id) DO
    
                SET @user_score_percentage=0;
                SET @user_score_month=0;
                SET @user_token_TOTAL=0;

                SELECT SUM(score) INTO @user_score_month from Archive_user_score_history WHERE date>=DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY) AND date<=LAST_DAY(CURRENT_DATE) AND user_id=@user_pointer;

                IF (@user_score_month IS NOT NULL AND @user_score_month>0)THEN
                    
                    SET @user_score_percentage=@user_score_month/@score_month_TOTAL;

                    INSERT INTO Archive_score_MONTH (user_id,score) VALUES (@user_pointer,@user_score_month);

                    IF(@user_score_percentage>0)THEN
                       SET @user_token_TOTAL=ROUND(@token_avail*@user_score_percentage,0);

                        INSERT INTO Archive_token_MONTH (user_id,token) VALUES (@user_pointer,@user_token_TOTAL);
                    ELSE
                        INSERT INTO Archive_token_MONTH (user_id,token) VALUES (@user_pointer,@user_token_TOTAL);
                    END IF;
                
                END IF;
                SET @user_pointer=@user_pointer+1;
            END WHILE;
        END IF;
    END IF;
END $$

DELIMITER ;