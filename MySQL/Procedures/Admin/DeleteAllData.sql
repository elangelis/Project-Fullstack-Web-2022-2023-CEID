DELIMITER ;
DROP PROCEDURE IF EXISTS DeleteAllData;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS DeleteAllData()
BEGIN   

    DELETE FROM Archive_token_BANK;
    DELETE FROM Archive_score_MONTH;
    DELETE FROM Archive_score_TOTAL;
    DELETE FROM Archive_token_MONTH;
    DELETE FROM Archive_token_TOTAL;
    DELETE FROM object_admin;
    DELETE FROM Archive_Product_MesiTimi;
    DELETE FROM Archive_user_score_history;
    DELETE FROM Archive_Product_History;
    DELETE FROM Archive_user_actions;
    DELETE FROM object_offer;
    DELETE FROM object_product;
    DELETE FROM object_shop;
    DELETE FROM object_subcategory;
    DELETE FROM object_category;
    DELETE FROM object_user;

END$$
DELIMITER ;

CALL DeleteAllData();