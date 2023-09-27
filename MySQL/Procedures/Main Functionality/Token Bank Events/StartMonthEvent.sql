DROP EVENT IF EXISTS StartMonth_TokenBank;

CREATE EVENT IF NOT EXISTS StartMonth_TokenBank ON SCHEDULE EVERY 1 MONTH STARTS '2023-08-01 00:00:01' 
ON COMPLETION NOT PRESERVE ENABLE 
DO CALL StartMonth_UpdateTokenBankAvailableTokens();



-- FINAL


DELIMITER ;
DROP PROCEDURE IF EXISTS StartMonth_UpdateTokenBankAvailableTokens;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS StartMonth_UpdateTokenBankAvailableTokens()
BEGIN

    SELECT COUNT(*) INTO @user_count FROM object_user;
    IF (@user_count IS NULL)THEN
        SET @user_count=0;
    END IF;



    SET @tokenAVAILABLE=0;
    SET @tokenTOTAL=0;

    IF (@user_count>0)THEN
        SET @tokenTOTAL=@user_count*100;
        SET @tokenAVAILABLE=FLOOR((80/100)*@tokenTOTAL);
    END IF;

    INSERT INTO Archive_token_BANK (users_count,token_TOTAL,token_AVAILABLE,date_created,datetime_created) VALUES (@user_count,@tokenTOTAL,@tokenAVAILABLE,CURRENT_DATE,CURRENT_TIMESTAMP);

END $$

DELIMITER ;