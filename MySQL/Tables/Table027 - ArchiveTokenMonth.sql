
-- FINAL

DROP TABLE IF EXISTS Archive_token_MONTH;

CREATE TABLE IF NOT EXISTS Archive_token_MONTH
(
    id INT NULL AUTO_INCREMENT,
    
    user_id INT NOT NULL,
    token INTEGER UNSIGNED NULL DEFAULT 0,
    
    date_created DATE NULL DEFAULT CURRENT_DATE,
    month_start DATE NULL,
    month_end DATE NULL,        
    month INTEGER NULL,
    year INTEGER NULL,


    PRIMARY KEY (id),


    CONSTRAINT Archive_token_MONTH_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
    
);

DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchivetokenMONTH_ModifyDatesCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchivetokenMONTH_ModifyDatesCurrentRecord BEFORE INSERT
ON Archive_token_MONTH FOR EACH ROW  
BEGIN

    SET @month_start =   DATE_SUB(CURRENT_DATE, INTERVAL DAYOFMONTH(CURRENT_DATE)-1 DAY);
    SET @month_end   =   LAST_DAY(CURRENT_DATE);
    SET @month       =   MONTH(CURRENT_DATE);
    SET @year        =   YEAR(CURRENT_DATE);

    SET new.month_start=@month_start;
    SET new.month_end=@month_end;
    SET new.month=@month;
    SET new.year=@year;
    SET new.date_created=CURRENT_DATE;

END$$

DELIMITER ;


DELIMITER ;  
DROP TRIGGER IF EXISTS OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal;

DELIMITER $$ 
CREATE TRIGGER OnAfterInsertArchiveTokenMonth_InsertUpdateTokenTotal AFTER INSERT
ON Archive_token_MONTH FOR EACH ROW  
BEGIN

    SET @count=0;
    SELECT COUNT(*) INTO @count FROM Archive_token_TOTAL WHERE user_id=new.user_id;
    -- check if record exists
    IF (@count IS NOT NULL AND @count>0) THEN
        -- modify previous one
        SELECT SUM(tokens) INTO @prev_tokens FROM Archive_token_TOTAL WHERE user_id=new.user_id;
        
        SET @new_tokens=@prev_tokens+new.token;
        
        UPDATE Archive_token_TOTAL SET tokens=@new_score WHERE user_id=new.user_id;

    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_token_TOTAL (user_id,tokens)VALUES(new.user_id,new.token);
    
    END IF;

END$$

DELIMITER ;