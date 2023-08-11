
-- FINAL

DROP TABLE IF EXISTS Archive_Product_MesiTimi;

CREATE TABLE IF NOT EXISTS Archive_Product_MesiTimi
(
    id INT NULL AUTO_INCREMENT,
    product_id INTEGER NOT NULL,
    mesi_timi DECIMAL(10,2) NOT NULL,
    date DATE NOT NULL ,


    PRIMARY KEY (id),

    CONSTRAINT Archive_Product_History_product_id
    FOREIGN KEY (product_id) REFERENCES object_product(id)
    ON UPDATE NO ACTION ON DELETE NO ACTION

);
