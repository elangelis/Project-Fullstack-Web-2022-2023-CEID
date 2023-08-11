
-- FINAL

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

    isAdmin BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (id,name)
);
