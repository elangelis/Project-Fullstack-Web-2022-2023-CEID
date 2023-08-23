-- DROP ALL TABLES

DROP TABLE IF EXISTS Archive_token_BANK;        
DROP TABLE IF EXISTS Archive_score_MONTH;
DROP TABLE IF EXISTS Archive_score_TOTAL;
DROP TABLE IF EXISTS Archive_token_MONTH;
DROP TABLE IF EXISTS Archive_token_TOTAL;
DROP TABLE IF EXISTS object_admin;
DROP TABLE IF EXISTS Archive_Product_MesiTimi;
DROP TABLE IF EXISTS Archive_user_score_history;
DROP TABLE IF EXISTS Archive_Product_History;
DROP TABLE IF EXISTS Archive_user_actions;
DROP TABLE IF EXISTS object_offer;
DROP TABLE IF EXISTS object_product;
DROP TABLE IF EXISTS object_shop;
DROP TABLE IF EXISTS object_subcategory;
DROP TABLE IF EXISTS object_category;
DROP TABLE IF EXISTS object_user;


SET @@sql_mode = 'STRICT_TRANS_TABLES'; 

-- DROP DATABASE webproject2022;
-- CREATE DATABASE IF NOT EXISTS webproject2022;
-- USE webproject2022;

DROP TABLE IF EXISTS object_user;
CREATE TABLE object_user
(

    id INTEGER NULL AUTO_INCREMENT,
    username VARCHAR (255) NOT NULL DEFAULT '',
    password VARCHAR (255) NOT NULL DEFAULT '',
    email VARCHAR (255) NOT NULL DEFAULT '',
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
    

DROP TABLE IF EXISTS object_admin;

CREATE TABLE  object_admin
(
    id VARCHAR(255)  NULL DEFAULT '',
    username VARCHAR(255)  NULL DEFAULT '',
    password VARCHAR(255)  NULL DEFAULT '',
    email VARCHAR(255)  NULL DEFAULT '',
    name VARCHAR(255)  NULL DEFAULT '',
    first_name VARCHAR(255)  NULL DEFAULT '',
    last_name VARCHAR(255)  NULL DEFAULT '',

    PRIMARY KEY (id,name)
);

insert into object_admin (username,password,email) values("admin","admin","admin");


DROP TABLE IF EXISTS object_category;
CREATE TABLE IF NOT EXISTS object_category
(
    id INT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL DEFAULT '',
    description VARCHAR(255) NULL DEFAULT '',
    -- ekatanalotis
    ekat_id VARCHAR(255) NULL DEFAULT '',

    PRIMARY KEY(id)
);



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



DROP TABLE IF EXISTS Archive_score_TOTAL;
CREATE TABLE IF NOT EXISTS Archive_score_TOTAL
(
    id INT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    score INTEGER UNSIGNED NULL DEFAULT 0,

    PRIMARY KEY (id),

    CONSTRAINT Archive_score_TOTAL_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);



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

DROP TABLE IF EXISTS Archive_token_TOTAL;
CREATE TABLE IF NOT EXISTS Archive_token_TOTAL
(
    id INT AUTO_INCREMENT,
    user_id INT NOT NULL,
    token INTEGER UNSIGNED DEFAULT 0,

    PRIMARY KEY (id),

    CONSTRAINT Archive_token_TOTAL_user_id
    FOREIGN KEY (user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);


DROP TABLE IF EXISTS object_subcategory;
CREATE TABLE IF NOT EXISTS object_subcategory
(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (255) NOT NULL DEFAULT '',
    description TEXT (255) NULL DEFAULT '',
    
    -- categories
    category_id INT NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    
    -- ekatanalotis
    ekat_id VARCHAR(255) NULL,
    ekat_cat_id VARCHAR(255) NULL,
    
    PRIMARY KEY(id,name),

    CONSTRAINT object_subcategory_category_id
    FOREIGN KEY (category_id,category_name,ekat_cat_id) REFERENCES object_category(id,name,ekat_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);



DROP TABLE IF EXISTS object_product;
CREATE TABLE IF NOT EXISTS object_product
(
    id INT NULL AUTO_INCREMENT,
    name VARCHAR (255) NOT NULL DEFAULT '',
    description TEXT (255) NULL DEFAULT '',
    -- photo
    photourl TEXT(255) NULL DEFAULT '',
    photo_DATA  LONGBLOB NULL DEFAULT NULL,
    -- categories
    category_id INT NOT NULL DEFAULT 0,
    subcategory_id INT NOT NULL DEFAULT 0,
    -- ekatanalotis
    ekat_id VARCHAR(255)  NULL DEFAULT '',
    ekat_cat_id VARCHAR(255)  NULL DEFAULT '',
    ekat_sub_id VARCHAR(255)  NULL DEFAULT '',

    PRIMARY KEY(id,name),

    CONSTRAINT object_product_category_id
    FOREIGN KEY (category_id) REFERENCES object_category(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT object_product_subcategory_id
    FOREIGN KEY (subcategory_id) REFERENCES object_subcategory(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);



CREATE TABLE object_offer
(
    id INT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    product_id INT NOT NULL,
    has_stock BOOLEAN NULL DEFAULT TRUE,
    creation_date DATE NULL DEFAULT CURRENT_DATE,
    expiration_date DATE NULL,
    criteria_A BOOL NULL DEFAULT FALSE,
    criteria_B BOOL NULL DEFAULT FALSE,
    creation_user_id INT NULL,
    likes INT  NULL DEFAULT 0,
    dislikes INT NULL DEFAULT 0,
    product_price DECIMAL(7,2) NOT NULL,

    PRIMARY KEY (id),

    CONSTRAINT object_offer_shop_id
    FOREIGN KEY (shop_id) REFERENCES object_shop(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT object_offer_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT object_offer_creation_user_id
    FOREIGN KEY (creation_user_id) REFERENCES object_user(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);




DROP TABLE IF EXISTS Archive_Product_MesiTimi;
CREATE TABLE IF NOT EXISTS Archive_Product_MesiTimi
(
    id INT NULL AUTO_INCREMENT,
    product_id INTEGER NOT NULL,
    mesi_timi DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL ,

    PRIMARY KEY (id),

    CONSTRAINT Archive_Product_MesiTimi_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);



DROP TABLE IF EXISTS Archive_user_actions;
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
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT Archive_user_actions_offer_id
    FOREIGN KEY (offer_id) REFERENCES object_offer(id)
    ON UPDATE CASCADE ON DELETE CASCADE
);




DROP TABLE IF EXISTS Archive_user_score_history;
CREATE TABLE IF NOT EXISTS Archive_user_score_history
(

     id INT NOT NULL AUTO_INCREMENT,
     user_id INTEGER NOT NULL,
     offer_id INTEGER NOT NULL,
     user_likes_id INTEGER DEFAULT NULL,
     date DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP),
     score INTEGER,

     PRIMARY KEY (id),

     CONSTRAINT Archive_user_score_history_user_id
     FOREIGN KEY (user_id) REFERENCES object_user(id)
     ON UPDATE NO ACTION ON DELETE NO ACTION,

     CONSTRAINT Archive_user_score_history_offer_id
     FOREIGN KEY (offer_id) REFERENCES object_offer(id)
     ON UPDATE NO ACTION ON DELETE NO ACTION,

     CONSTRAINT Archive_user_score_history_user_likes_id
     FOREIGN KEY (user_likes_id) REFERENCES Archive_user_actions(id)
     ON UPDATE NO ACTION ON DELETE NO ACTION
);



DROP TABLE IF EXISTS Archive_Product_History;
CREATE TABLE IF NOT EXISTS Archive_Product_History
(
    id INT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    product_id INTEGER NOT NULL,
    product_price DECIMAL(10,2) NOT NULL,
    date DATE NULL DEFAULT CURRENT_DATE,

    PRIMARY KEY (id),

    CONSTRAINT Archive_Product_History_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT Archive_Product_History_shop_id
    FOREIGN KEY (shop_id) REFERENCES object_shop(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION
);


