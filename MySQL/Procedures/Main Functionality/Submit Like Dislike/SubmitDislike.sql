



-- FINAL

DELIMITER ;
DROP PROCEDURE IF EXISTS SubmitDislike;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS SubmitDislike(IN in_user_id INTEGER,IN in_offer_id INTEGER)
BEGIN

    SET @current_likes=NULL;
    SET @current_dislikes=NULL;
    SET @current_offerid=NULL;

    SET @userlike_id=NULL;


    SELECT dislikes,likes   INTO @current_dislikes, @current_likes          FROM object_offer         WHERE object_offer.id=in_offer_id;
    SELECT id,type          INTO @previousaction_id,@previousactiontype     FROM Archive_user_actions WHERE user_id=in_user_id AND offer_id=in_offer_id;


    IF(@current_likes IS NULL)THEN
        SET @current_likes=0;
    END IF;

    IF(@current_dislikes IS NULL)THEN
        SET @current_dislikes=0;
    END IF;

    
    IF(@previousaction_id IS NULL)THEN
        -- New record for User likes 
        INSERT INTO Archive_user_actions (user_id,offer_id,type,date) VALUES(in_user_id,in_offer_id,2,CURRENT_DATE);
        
        SET @current_dislikes=@current_dislikes+1;
        -- Update offer with one extra like and keep previous dislikes
        UPDATE object_offer SET likes=@current_likes,dislikes=@current_dislikes WHERE id=in_offer_id;

    ELSE
        
        IF(@previousactiontype=1)THEN
        -- Update previous Record of User Likes 
            UPDATE Archive_user_actions SET type=2 WHERE user_id=in_user_id AND offer_id=in_offer_id;
        
            SET @current_likes=@current_likes-1;
            SET @current_dislikes=@current_dislikes+1;
        
            UPDATE object_offer SET likes=@current_likes,dislikes=@current_dislikes WHERE id=in_offer_id;

        END IF;
    END IF;

END$$
DELIMITER ;
