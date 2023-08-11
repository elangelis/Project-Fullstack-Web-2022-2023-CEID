
-- FINAL


DROP TABLE IF EXISTS Archive_score_MONTH;

CREATE TABLE IF NOT EXISTS Archive_score_MONTH
(
    id INT NULL AUTO_INCREMENT,
    
    user_id INT NOT NULL,
    score INTEGER UNSIGNED  NULL DEFAULT 0,

    date_created DATE NULL DEFAULT CURRENT_DATE,
    
    month_start DATE  NULL,
    month_end DATE  NULL,        
    month INTEGER  NULL,
    year INTEGER  NULL,


    PRIMARY KEY (id),


    CONSTRAINT Archive_score_MONTH_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION


);



DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveScoreMonth_ModifyDatesCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveScoreMonth_ModifyDatesCurrentRecord BEFORE INSERT
ON Archive_score_MONTH FOR EACH ROW  
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

-- insert into Archive_score_MONTH(user_id,score)VALUES(1,19000);
-- insert into Archive_score_MONTH(user_id,score)VALUES(2,-200);


DELIMITER ;  
DROP TRIGGER IF EXISTS OnAfterInsertArchiveScoreMonth_InsertUpdateScoreTotal;

DELIMITER $$ 
CREATE TRIGGER OnAfterInsertArchiveScoreMonth_InsertUpdateScoreTotal AFTER INSERT
ON Archive_score_MONTH FOR EACH ROW  
BEGIN

    SET @count=0;
    SELECT COUNT(*) INTO @count FROM Archive_score_TOTAL WHERE user_id=new.user_id;
    -- check if record exists
    IF (@count IS NOT NULL AND @count>0) THEN
        -- modify previous one
        SELECT SUM(score) INTO @prev_score FROM Archive_score_TOTAL WHERE user_id=new.user_id;
        SET @new_score=@prev_score+new.score;
        UPDATE Archive_score_TOTAL SET score=@new_score WHERE user_id=new.user_id;
    ELSEIF(@count is NULL OR @count=0)THEN
        -- create new record
        INSERT INTO Archive_score_TOTAL (user_id,score)VALUES(new.user_id,new.score);
    END IF;

END$$

DELIMITER ;