
-- FINAL

DROP TABLE IF EXISTS object_category;


CREATE TABLE IF NOT EXISTS object_category
(
    id INT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL DEFAULT '',
    description VARCHAR(255) NULL DEFAULT '',
    
    -- ekatanalotis
    ekat_id VARCHAR(255) NULL DEFAULT '',

    PRIMARY KEY(id,name,ekat_id)
);


