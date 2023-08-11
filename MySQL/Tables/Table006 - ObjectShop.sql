

-- FINAL   

DROP TABLE IF EXISTS object_shop;


CREATE TABLE object_shop
(
    id INTEGER NULL AUTO_INCREMENT,
    name VARCHAR (255) NULL DEFAULT '',
    address VARCHAR (255) NULL DEFAULT '',
    description VARCHAR (255) NULL DEFAULT '',
    active_offer BOOLEAN NULL DEFAULT FALSE,

    latitude DECIMAL(10,7) NULL DEFAULT 0,
    longitude DECIMAL(10,7) NULL DEFAULT 0,

    PRIMARY KEY(id),
    UNIQUE KEY(name)
);

