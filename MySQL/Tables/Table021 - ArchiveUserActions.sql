-- FINAL

DROP TABLE IF EXISTS Archive_user_actions;

SET @@sql_mode = 'STRICT_TRANS_TABLES'; 

CREATE TABLE IF NOT EXISTS Archive_user_actions
(
    id INT NULL AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    offer_id INTEGER NOT NULL,
    date DATE NULL DEFAULT CURRENT_TIMESTAMP,

    type ENUM ('like','dislike') NOT NULL,

    PRIMARY KEY (id),

    CONSTRAINT Archive_user_actions_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT Archive_user_actions_offer_id
    FOREIGN KEY (offer_id) REFERENCES object_offer(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION

);


DELIMITER ;
DROP TRIGGER IF EXISTS OnBeforeInsertUserActions_ModifyDateCurrentRecord;

DELIMITER $$   
CREATE TRIGGER OnBeforeInsertUserActions_ModifyDateCurrentRecord BEFORE INSERT  
ON Archive_user_actions FOR EACH ROW  
BEGIN
    SET new.date=CURRENT_TIMESTAMP;
END$$
DELIMITER ;



DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsertUserActions_InsertIntoUserScoreHistory;

DELIMITER $$   
CREATE TRIGGER OnAfterInsertUserActions_InsertIntoUserScoreHistory AFTER INSERT  
ON Archive_user_actions FOR EACH ROW  
BEGIN
    IF (new.type=1) THEN
        INSERT INTO Archive_user_score_history (user_id,offer_id,user_likes_id,date,score) 
            VALUES(new.user_id,new.offer_id,new.id,CURRENT_TIMESTAMP,5);
    ELSEIF (new.type=2) THEN
        INSERT INTO Archive_user_score_history (user_id,offer_id,user_likes_id,date,score) 
            VALUES(new.user_id,new.offer_id,new.id,CURRENT_TIMESTAMP,-1);
    END IF;
END$$ 

DELIMITER ; 



DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterUpdateUserActions_UpdateIntoUserScoreHistory;

DELIMITER $$   
CREATE TRIGGER OnAfterUpdateUserActions_UpdateIntoUserScoreHistory AFTER UPDATE  
ON Archive_user_actions FOR EACH ROW  
BEGIN

    IF (new.type<>old.type AND new.type=1) THEN
    	SET @score=6;
    	UPDATE Archive_user_score_history SET date=CURRENT_TIMESTAMP,score=@score WHERE offer_id=new.offer_id AND user_id=new.user_id;
    ELSEIF (new.type<>old.type AND new.type=2) THEN
        SET @score=(-6);
        UPDATE Archive_user_score_history SET date=CURRENT_TIMESTAMP,score=@score WHERE offer_id=new.offer_id AND user_id=new.user_id;
    END IF;

END$$ 

DELIMITER ; 

DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterUpdateUserActions_UpdateIntoUserScoreHistory;

DELIMITER $$   
CREATE TRIGGER OnAfterUpdateUserActions_UpdateIntoUserScoreHistory BEFORE DELETE  
ON Archive_user_actions FOR EACH ROW  
BEGIN
    
    SELECT id,score INTO @oldlikeid,@score FROM Archive_user_score_history where user_id=old.user_id AND user_likes_id=old.id;

    IF (@oldlikeid IS NOT NULL)THEN
        SET @newscore=0-@score;
        INSERT INTO Archive_user_score_history (user_id,score,date,offer_id,user_likes_id) VALUES (old.user_id,@newscore,CURRENT_DATE,old.offer_id,old.id);
    END IF;

END$$ 

DELIMITER ; 