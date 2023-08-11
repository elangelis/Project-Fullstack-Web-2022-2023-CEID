


-- FINAL   

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
    FOREIGN KEY (category_id,ekat_cat_id) REFERENCES category(id,ekat_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION,

    CONSTRAINT object_product_subcategory_id
    FOREIGN KEY (subcategory_id,ekat_sub_id) REFERENCES subcategory(id,ekat_id)
    ON UPDATE NO ACTION ON DELETE NO ACTION

    
);
