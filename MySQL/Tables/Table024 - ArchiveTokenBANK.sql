
-- FINAL


DROP TABLE IF EXISTS Archive_token_BANK;

CREATE TABLE IF NOT EXISTS Archive_token_BANK
(
    id INTEGER NULL AUTO_INCREMENT,
    users_count INTEGER NULL DEFAULT 0,
    token_TOTAL INTEGER NULL DEFAULT 0,
    token_AVAILABLE INTEGER NULL DEFAULT 0,

    date_created  DATE NULL DEFAULT (CURRENT_DATE),
    datetime_created DATETIME NULL DEFAULT (CURRENT_TIMESTAMP),
    
    month_start DATE  NULL,
    month_end DATE  NULL,        
    month INTEGER  NULL,
    year INTEGER  NULL,


    PRIMARY KEY(id,date_created)

);


DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveTokenBANK_ModifyDatesCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveTokenBANK_ModifyDatesCurrentRecord BEFORE INSERT
ON Archive_token_BANK FOR EACH ROW  
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
    SET new.datetime_created=CURRENT_TIMESTAMP;

END$$

DELIMITER ;