-- FINAL 


DROP TABLE IF EXISTS object_user;

CREATE TABLE object_user
(

    id INTEGER NULL AUTO_INCREMENT,
    username VARCHAR (255) NOT NULL DEFAULT '',
    password VARCHAR (255) NOT NULL DEFAULT '',
    email VARCHAR (255) NOT NULL DEFAULT '',
    
    last_session_id VARCHAR (255) NULL DEFAULT '',

    name VARCHAR (255) NULL DEFAULT '',
    first_name VARCHAR (255) NULL  DEFAULT '',
    last_name VARCHAR (255) NULL DEFAULT '',

    date_creation DATETIME NULL DEFAULT CURRENT_TIMESTAMP,

    address VARCHAR (255) NULL DEFAULT '',

    latitude DECIMAL(10,7)  NULL DEFAULT 0,
    longitude DECIMAL(10,7)  NULL DEFAULT 0,

    PRIMARY KEY(id,username),
    UNIQUE KEY (email,password)
);

insert into object_user (username,password,email) values("ilias2","1234","elangelis2@yahoo.gr");

    
DELIMITER ;
DROP TRIGGER IF EXISTS OnAfterInsert_CreateUserScoreRecord;

DELIMITER $$   
CREATE TRIGGER OnAfterInsert_CreateUserScoreRecord AFTER INSERT  
ON object_user FOR EACH ROW  
BEGIN
    INSERT INTO Archive_score_TOTAL (user_id,score) VALUES(new.id,0);
END$$ 
DELIMITER ; 
