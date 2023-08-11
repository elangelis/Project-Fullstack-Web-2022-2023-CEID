
-- FINAL

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
    ON UPDATE CASCADE ON DELETE CASCADE

);
