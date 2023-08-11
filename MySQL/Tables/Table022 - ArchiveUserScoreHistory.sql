
-- FINAL

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

