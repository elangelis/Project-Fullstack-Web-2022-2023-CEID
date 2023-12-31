
-- FINAL

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


