
-- FINAL

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



DELIMITER ;  
DROP TRIGGER IF EXISTS OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord;

DELIMITER $$ 
CREATE TRIGGER OnBeforeInsertArchiveProductHistory_ModifyDateCurrentRecord BEFORE INSERT
ON Archive_Product_History FOR EACH ROW  
BEGIN

    SET new.date=CURRENT_DATE;

END$$

DELIMITER ;





