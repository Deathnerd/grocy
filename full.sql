-- BEGIN 0001.sql
CREATE TABLE products
(
    id                          INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                        TEXT    NOT NULL UNIQUE,
    description                 TEXT,
    location_id                 INTEGER NOT NULL,
    qu_id_purchase              INTEGER NOT NULL,
    qu_id_stock                 INTEGER NOT NULL,
    qu_factor_purchase_to_stock REAL    NOT NULL,
    barcode                     TEXT,
    min_stock_amount            INTEGER NOT NULL DEFAULT 0,
    default_best_before_days    INTEGER NOT NULL DEFAULT 0,
    row_created_timestamp       DATETIME         DEFAULT (datetime('now', 'localtime'))
);
-- END 0001.sql

-- BEGIN 0002.sql
CREATE TABLE locations
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0002.sql

-- BEGIN 0003.sql
CREATE TABLE quantity_units
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0003.sql

-- BEGIN 0004.sql
CREATE TABLE stock
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER NOT NULL,
    amount                INTEGER NOT NULL,
    best_before_date      DATE,
    purchased_date        DATE     DEFAULT (datetime('now', 'localtime')),
    stock_id              TEXT    NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0004.sql

-- BEGIN 0005.sql
CREATE TABLE stock_log
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER NOT NULL,
    amount                INTEGER NOT NULL,
    best_before_date      DATE,
    purchased_date        DATE,
    used_date             DATE,
    spoiled               INTEGER NOT NULL DEFAULT 0,
    stock_id              TEXT    NOT NULL,
    transaction_type      TEXT    NOT NULL,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);
-- END 0005.sql

-- BEGIN 0006.sql
INSERT INTO locations
    (name, description)
VALUES ('DefaultLocation', 'This is the first default location, edit or delete it');

INSERT INTO quantity_units
    (name, description)
VALUES ('DefaultQuantityUnit', 'This is the first default quantity unit, edit or delete it');

INSERT INTO products
(name, description, location_id, qu_id_purchase, qu_id_stock, qu_factor_purchase_to_stock)
VALUES ('DefaultProduct1', 'This is the first default product, edit or delete it', 1, 1, 1, 1);

INSERT INTO products
(name, description, location_id, qu_id_purchase, qu_id_stock, qu_factor_purchase_to_stock)
VALUES ('DefaultProduct2', 'This is the second default product, edit or delete it', 1, 1, 1, 1);
-- END 0006.sql

-- BEGIN 0007.sql
CREATE VIEW stock_missing_products
AS
SELECT p.id, MAX(p.name) AS name, p.min_stock_amount - IFNULL(SUM(s.amount), 0) AS amount_missing
FROM products p
         LEFT JOIN stock s
                   ON p.id = s.product_id
WHERE p.min_stock_amount != 0
GROUP BY p.id
HAVING IFNULL(SUM(s.amount), 0) < p.min_stock_amount;
-- END 0007.sql

-- BEGIN 0008.sql
CREATE VIEW stock_current
AS
SELECT product_id, SUM(amount) AS amount, MIN(best_before_date) AS best_before_date
FROM stock
GROUP BY product_id;
-- END 0008.sql

-- BEGIN 0009.sql
CREATE TABLE shopping_list
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER NOT NULL UNIQUE,
    amount                INTEGER NOT NULL DEFAULT 0,
    amount_autoadded      INTEGER NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);
-- END 0009.sql

-- BEGIN 0010.sql
CREATE TABLE habits
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    period_type           TEXT    NOT NULL,
    period_days           INTEGER,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0010.sql

-- BEGIN 0011.sql
CREATE TABLE habits_log
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    habit_id              INTEGER NOT NULL,
    tracked_time          DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0011.sql

-- BEGIN 0012.sql
CREATE VIEW habits_current
AS
SELECT habit_id, MAX(tracked_time) AS last_tracked_time
FROM habits_log
GROUP BY habit_id
-- END 0012.sql

-- BEGIN 0013.sql
CREATE TABLE batteries
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    used_in               TEXT,
    charge_interval_days  INTEGER NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);
-- END 0013.sql

-- BEGIN 0014.sql
CREATE TABLE battery_charge_cycles
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    battery_id            TEXT    NOT NULL,
    tracked_time          DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0014.sql

-- BEGIN 0015.sql
CREATE VIEW batteries_current
AS
SELECT battery_id, MAX(tracked_time) AS last_tracked_time
FROM battery_charge_cycles
GROUP BY battery_id;
-- END 0015.sql

-- BEGIN 0016.sql
ALTER TABLE shopping_list
    RENAME TO shopping_list_old;
-- END 0016.sql

-- BEGIN 0017.sql
CREATE TABLE shopping_list
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER,
    note                  TEXT,
    amount                INTEGER NOT NULL DEFAULT 0,
    amount_autoadded      INTEGER NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);
-- END 0017.sql

-- BEGIN 0018.sql
INSERT INTO shopping_list
    (product_id, amount, amount_autoadded, row_created_timestamp)
SELECT product_id, amount, amount_autoadded, row_created_timestamp
FROM shopping_list_old;
-- END 0018.sql

-- BEGIN 0019.sql
DROP TABLE shopping_list_old;
-- END 0019.sql

-- BEGIN 0020.sql
CREATE TABLE sessions
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    session_key           TEXT    NOT NULL UNIQUE,
    expires               DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0020.sql

-- BEGIN 0021.sql
DELETE
FROM locations
WHERE name = 'DefaultLocation';

DELETE
FROM quantity_units
WHERE name = 'DefaultQuantityUnit';

DELETE
FROM products
WHERE name = 'DefaultProduct1';

DELETE
FROM products
WHERE name = 'DefaultProduct2';
-- END 0021.sql

-- BEGIN 0022.sql
CREATE TABLE api_keys
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    api_key               TEXT    NOT NULL UNIQUE,
    expires               DATETIME,
    last_used             DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0022.sql

-- BEGIN 0023.sql
DELETE
FROM sessions;
-- END 0023.sql

-- BEGIN 0024.sql
ALTER TABLE sessions
    ADD COLUMN last_used DATETIME;
-- END 0024.sql

-- BEGIN 0025.sql
CREATE TABLE recipes
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE recipes_pos
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    recipe_id             INTEGER NOT NULL,
    product_id            INTEGER NOT NULL,
    amount                INTEGER NOT NULL DEFAULT 0,
    note                  TEXT,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);

CREATE VIEW recipes_fulfillment
AS
SELECT r.id                                                          AS recipe_id,
       rp.id                                                         AS recipe_pos_id,
       rp.product_id                                                 AS product_id,
       rp.amount                                                     AS recipe_amount,
       IFNULL(sc.amount, 0)                                          AS stock_amount,
       CASE WHEN IFNULL(sc.amount, 0) >= rp.amount THEN 1 ELSE 0 END AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - IFNULL(rp.amount, 0) < 0 THEN ABS(IFNULL(sc.amount, 0) - IFNULL(rp.amount, 0))
           ELSE 0 END                                                AS missing_amount,
       IFNULL(sl.amount, 0)                                          AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + IFNULL(sl.amount, 0) >= rp.amount THEN 1
           ELSE 0 END                                                AS need_fulfilled_with_shopping_list
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         LEFT JOIN (
    SELECT product_id, SUM(amount + amount_autoadded) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id;

CREATE VIEW recipes_fulfillment_sum
AS
SELECT r.id                                                 AS recipe_id,
       IFNULL(MIN(rf.need_fulfilled), 1)                    AS need_fulfilled,
       IFNULL(MIN(rf.need_fulfilled_with_shopping_list), 1) AS need_fulfilled_with_shopping_list,
       (SELECT COUNT(*)
        FROM recipes_fulfillment
        WHERE recipe_id = rf.recipe_id
          AND need_fulfilled = 0
          AND recipe_pos_id IS NOT NULL)                    AS missing_products_count
FROM recipes r
         LEFT JOIN recipes_fulfillment rf
                   ON rf.recipe_id = r.id
GROUP BY r.id;
-- END 0025.sql

-- BEGIN 0026.sql
CREATE TABLE users
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    username              TEXT    NOT NULL UNIQUE,
    first_name            TEXT,
    last_name             TEXT,
    password              TEXT    NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

DROP TABLE sessions;

CREATE TABLE sessions
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    session_key           TEXT    NOT NULL UNIQUE,
    user_id               INTEGER NOT NULL,
    expires               DATETIME,
    last_used             DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

-- END 0026.sql

-- BEGIN 0028.sql
ALTER TABLE habits_log
    ADD done_by_user_id INTEGER;

DROP TABLE api_keys;

CREATE TABLE api_keys
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    api_key               TEXT    NOT NULL UNIQUE,
    user_id               INTEGER NOT NULL,
    expires               DATETIME,
    last_used             DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0028.sql

-- BEGIN 0029.sql
ALTER TABLE stock
    ADD price DECIMAL(15, 2);

ALTER TABLE stock_log
    ADD price DECIMAL(15, 2);
-- END 0029.sql

-- BEGIN 0030.sql
ALTER TABLE quantity_units
    ADD name_plural TEXT;
-- END 0030.sql

-- BEGIN 0032.sql
DROP VIEW stock_current;
CREATE VIEW stock_current
AS
SELECT product_id, SUM(amount) AS amount, MIN(best_before_date) AS best_before_date
FROM stock
GROUP BY product_id;

DROP VIEW habits_current;
CREATE VIEW habits_current
AS
SELECT habit_id, MAX(tracked_time) AS last_tracked_time
FROM habits_log
GROUP BY habit_id;

DROP VIEW batteries_current;
CREATE VIEW batteries_current
AS
SELECT battery_id, MAX(tracked_time) AS last_tracked_time
FROM battery_charge_cycles
GROUP BY battery_id;
-- END 0032.sql

-- BEGIN 0033.sql
DROP VIEW habits_current;
CREATE VIEW habits_current
AS
SELECT h.id                AS habit_id,
       MAX(l.tracked_time) AS last_tracked_time,
       CASE h.period_type
           WHEN 'manually' THEN '2999-12-31 23:59:59'
           WHEN 'dynamic-regular' THEN datetime(MAX(l.tracked_time), '+' || CAST(h.period_days AS TEXT) || ' day')
           END             AS next_estimated_execution_time
FROM habits h
         LEFT JOIN habits_log l
                   ON h.id = l.habit_id
GROUP BY h.id, h.period_days;

DROP VIEW batteries_current;
CREATE VIEW batteries_current
AS
SELECT b.id                AS battery_id,
       MAX(l.tracked_time) AS last_tracked_time,
       CASE
           WHEN b.charge_interval_days = 0
               THEN '2999-12-31 23:59:59'
           ELSE datetime(MAX(l.tracked_time), '+' || CAST(b.charge_interval_days AS TEXT) || ' day')
           END             AS next_estimated_charge_time
FROM batteries b
         LEFT JOIN battery_charge_cycles l
                   ON b.id = l.battery_id
GROUP BY b.id, b.charge_interval_days;
-- END 0033.sql

-- BEGIN 0034.sql
ALTER TABLE recipes_pos
    ADD qu_id INTEGER;

UPDATE recipes_pos
SET qu_id = (SELECT qu_id_stock FROM products where id = product_id);

CREATE TRIGGER recipes_pos_qu_id_default
    AFTER INSERT
    ON recipes_pos
BEGIN
    UPDATE recipes_pos
    SET qu_id = (SELECT qu_id_stock FROM products where id = product_id)
    WHERE qu_id IS NULL
      AND id = NEW.id;
END;

ALTER TABLE recipes_pos
    ADD only_check_single_unit_in_stock TINYINT NOT NULL DEFAULT 0;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                 AS recipe_id,
       rp.id                AS recipe_pos_id,
       rp.product_id        AS product_id,
       rp.amount            AS recipe_amount,
       IFNULL(sc.amount, 0) AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) -
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) -
                       CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END)
           ELSE 0 END       AS missing_amount,
       IFNULL(sl.amount, 0) AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + IFNULL(sl.amount, 0) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END       AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         LEFT JOIN (
    SELECT product_id, SUM(amount + amount_autoadded) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id;
-- END 0034.sql

-- BEGIN 0035.sql
ALTER TABLE habits
    RENAME TO chores;

CREATE TABLE chores_log
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    chore_id              INTEGER NOT NULL,
    tracked_time          DATETIME,
    done_by_user_id       INTEGER,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO chores_log (chore_id, tracked_time, done_by_user_id, row_created_timestamp)
SELECT habit_id, tracked_time, done_by_user_id, row_created_timestamp
FROM habits_log;

DROP TABLE habits_log;

DROP VIEW habits_current;
CREATE VIEW chores_current
AS
SELECT h.id                AS chore_id,
       MAX(l.tracked_time) AS last_tracked_time,
       CASE h.period_type
           WHEN 'manually' THEN '2999-12-31 23:59:59'
           WHEN 'dynamic-regular' THEN datetime(MAX(l.tracked_time), '+' || CAST(h.period_days AS TEXT) || ' day')
           END             AS next_estimated_execution_time
FROM chores h
         LEFT JOIN chores_log l
                   ON h.id = l.chore_id
GROUP BY h.id, h.period_days;
-- END 0035.sql

-- BEGIN 0036.sql
CREATE TABLE tasks
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    due_date              DATETIME,
    done                  TINYINT NOT NULL DEFAULT 0 CHECK (done IN (0, 1)),
    done_timestamp        DATETIME,
    category_id           INTEGER,
    assigned_to_user_id   INTEGER,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE task_categories
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

CREATE VIEW tasks_current
AS
SELECT *
FROM tasks
WHERE done = 0;
-- END 0036.sql

-- BEGIN 0037.sql
ALTER TABLE products
    ADD product_group_id INTEGER;

CREATE TABLE product_groups
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0037.sql

-- BEGIN 0038.sql
DROP VIEW stock_missing_products;
CREATE VIEW stock_missing_products
AS
SELECT p.id,
       MAX(p.name)                                   AS name,
       p.min_stock_amount - IFNULL(SUM(s.amount), 0) AS amount_missing,
       CASE WHEN s.id IS NOT NULL THEN 1 ELSE 0 END  AS is_partly_in_stock
FROM products p
         LEFT JOIN stock s
                   ON p.id = s.product_id
WHERE p.min_stock_amount != 0
GROUP BY p.id
HAVING IFNULL(SUM(s.amount), 0) < p.min_stock_amount;

DROP VIEW stock_current;
CREATE VIEW stock_current
AS
SELECT product_id, SUM(amount) AS amount, MIN(best_before_date) AS best_before_date
FROM stock
GROUP BY product_id

UNION

SELECT id, 0, null
FROM stock_missing_products
WHERE is_partly_in_stock = 0;
-- END 0038.sql

-- BEGIN 0039.sql
CREATE TABLE user_settings
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    user_id               INTEGER NOT NULL,
    key                   TEXT    NOT NULL,
    value                 TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),
    row_updated_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),

    UNIQUE (user_id, key)
);
-- END 0039.sql

-- BEGIN 0040.sql
ALTER TABLE products
    ADD picture_file_name TEXT;
-- END 0040.sql

-- BEGIN 0041.sql
CREATE TABLE equipment
(
    id                           INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                         TEXT    NOT NULL UNIQUE,
    description                  TEXT,
    instruction_manual_file_name TEXT,
    row_created_timestamp        DATETIME DEFAULT (datetime('now', 'localtime'))
)
-- END 0041.sql

-- BEGIN 0042.sql
CREATE TRIGGER cascade_change_qu_id_stock
    AFTER UPDATE
    ON products
BEGIN
    UPDATE recipes_pos
    SET qu_id = (SELECT qu_id_stock FROM products WHERE id = NEW.id)
    WHERE product_id IN (SELECT id FROM products WHERE id = NEW.id)
      AND only_check_single_unit_in_stock = 0;
END;
-- END 0042.sql

-- BEGIN 0043.sql
CREATE TABLE recipes_nestings
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    recipe_id             INTEGER NOT NULL,
    includes_recipe_id    INTEGER NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),

    UNIQUE (recipe_id, includes_recipe_id)
);

CREATE VIEW recipes_nestings_resolved
AS
WITH RECURSIVE r1(recipe_id, includes_recipe_id)
                   AS (
        SELECT id, id
        FROM recipes

        UNION ALL

        SELECT rn.recipe_id, r1.includes_recipe_id
        FROM recipes_nestings rn,
             r1 r1
        WHERE rn.includes_recipe_id = r1.recipe_id
        LIMIT 100 -- This is just a safety limit to prevent infinite loops due to infinite nested recipes
    )
SELECT *
FROM r1;

DROP VIEW recipes_fulfillment_sum;
CREATE VIEW recipes_fulfillment_sum
AS
SELECT r.id                                                 AS recipe_id,
       IFNULL(MIN(rf.need_fulfilled), 1)                    AS need_fulfilled,
       IFNULL(MIN(rf.need_fulfilled_with_shopping_list), 1) AS need_fulfilled_with_shopping_list,
       (SELECT COUNT(*)
        FROM recipes_fulfillment
        WHERE recipe_id IN (SELECT includes_recipe_id FROM recipes_nestings_resolved rnr2 WHERE rnr2.recipe_id = r.id)
          AND need_fulfilled = 0
          AND recipe_pos_id IS NOT NULL)                    AS missing_products_count
FROM recipes r
         LEFT JOIN recipes_nestings_resolved rnr
                   ON r.id = rnr.recipe_id
         LEFT JOIN recipes_fulfillment rf
                   ON rnr.includes_recipe_id = rf.recipe_id
GROUP BY r.id;

ALTER TABLE recipes_pos
    ADD ingredient_group TEXT;
-- END 0043.sql

-- BEGIN 0044.sql
ALTER TABLE stock_log
    ADD undone TINYINT NOT NULL DEFAULT 0 CHECK (undone IN (0, 1));

UPDATE stock_log
SET undone = 0;

ALTER TABLE stock_log
    ADD undone_timestamp DATETIME;

ALTER TABLE chores_log
    ADD undone TINYINT NOT NULL DEFAULT 0 CHECK (undone IN (0, 1));

UPDATE chores_log
SET undone = 0;

ALTER TABLE chores_log
    ADD undone_timestamp DATETIME;

ALTER TABLE battery_charge_cycles
    ADD undone TINYINT NOT NULL DEFAULT 0 CHECK (undone IN (0, 1));

UPDATE battery_charge_cycles
SET undone = 0;

ALTER TABLE battery_charge_cycles
    ADD undone_timestamp DATETIME;
-- END 0044.sql

-- BEGIN 0045.sql
ALTER TABLE recipes_pos
    RENAME TO recipes_pos_old;

CREATE TABLE recipes_pos
(
    id                              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    recipe_id                       INTEGER NOT NULL,
    product_id                      INTEGER NOT NULL,
    amount                          REAL    NOT NULL DEFAULT 0,
    note                            TEXT,
    qu_id                           INTEGER,
    only_check_single_unit_in_stock TINYINT NOT NULL DEFAULT 0,
    ingredient_group                TEXT,
    not_check_stock_fulfillment     TINYINT NOT NULL DEFAULT 0,
    row_created_timestamp           DATETIME         DEFAULT (datetime('now', 'localtime'))
);

DROP TRIGGER recipes_pos_qu_id_default;
CREATE TRIGGER recipes_pos_qu_id_default
    AFTER INSERT
    ON recipes_pos
BEGIN
    UPDATE recipes_pos
    SET qu_id = (SELECT qu_id_stock FROM products where id = product_id)
    WHERE qu_id IS NULL
      AND id = NEW.id;
END;

INSERT INTO recipes_pos
(recipe_id, product_id, amount, note, qu_id, only_check_single_unit_in_stock, ingredient_group, row_created_timestamp)
SELECT recipe_id,
       product_id,
       amount,
       note,
       qu_id,
       only_check_single_unit_in_stock,
       ingredient_group,
       row_created_timestamp
FROM recipes_pos_old;

DROP TABLE recipes_pos_old;

DROP TRIGGER cascade_change_qu_id_stock;
CREATE TRIGGER cascade_change_qu_id_stock
    AFTER UPDATE
    ON products
BEGIN
    UPDATE recipes_pos
    SET qu_id = (SELECT qu_id_stock FROM products WHERE id = NEW.id)
    WHERE product_id IN (SELECT id FROM products WHERE id = NEW.id)
      AND only_check_single_unit_in_stock = 0;
END;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                 AS recipe_id,
       rp.id                AS recipe_pos_id,
       rp.product_id        AS product_id,
       rp.amount            AS recipe_amount,
       IFNULL(sc.amount, 0) AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) -
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) -
                       CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END)
           ELSE 0 END       AS missing_amount,
       IFNULL(sl.amount, 0) AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + IFNULL(sl.amount, 0) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END       AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         LEFT JOIN (
    SELECT product_id, SUM(amount + amount_autoadded) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                 AS recipe_id,
       rp.id                AS recipe_pos_id,
       rp.product_id        AS product_id,
       rp.amount            AS recipe_amount,
       IFNULL(sc.amount, 0) AS stock_amount,
       1                    AS need_fulfilled,
       0                    AS missing_amount,
       IFNULL(sl.amount, 0) AS amount_on_shopping_list,
       1                    AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         LEFT JOIN (
    SELECT product_id, SUM(amount + amount_autoadded) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0045.sql

-- BEGIN 0046.sql
ALTER TABLE stock
    ADD opened_date DATETIME;

ALTER TABLE stock_log
    ADD opened_date DATETIME;

ALTER TABLE stock
    ADD open TINYINT NOT NULL DEFAULT 0 CHECK (open IN (0, 1));

UPDATE stock
SET open = 0;

ALTER TABLE products
    ADD default_best_before_days_after_open INTEGER NOT NULL DEFAULT 0;

UPDATE products
SET default_best_before_days_after_open = 0;

DROP VIEW stock_current;
CREATE VIEW stock_current
AS
SELECT s.product_id,
       SUM(s.amount)                                                                           AS amount,
       MIN(s.best_before_date)                                                                 AS best_before_date,
       IFNULL((SELECT SUM(amount) FROM stock WHERE product_id = s.product_id AND open = 1), 0) AS amount_opened
FROM stock s
GROUP BY s.product_id

UNION

SELECT id,
       0,
       null,
       0
FROM stock_missing_products
WHERE is_partly_in_stock = 0;
-- END 0046.sql

-- BEGIN 0047.sql
DROP TRIGGER cascade_change_qu_id_stock;
CREATE TRIGGER cascade_change_qu_id_stock
    AFTER UPDATE
    ON products
BEGIN
    UPDATE recipes_pos
    SET qu_id = (SELECT qu_id_stock FROM products WHERE id = NEW.id)
    WHERE product_id IN (SELECT id FROM products WHERE id = NEW.id)
      AND only_check_single_unit_in_stock = 0;
END;

UPDATE recipes_pos
SET qu_id = (SELECT qu_id_stock FROM products WHERE id = recipes_pos.product_id)
WHERE only_check_single_unit_in_stock = 0;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount                                            AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END                                       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) -
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) -
                       CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END)
           ELSE 0 END                                       AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END                                       AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount + amount_autoadded) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount                                            AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       1                                                    AS need_fulfilled,
       0                                                    AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       1                                                    AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount + amount_autoadded) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0047.sql

-- BEGIN 0048.sql
PRAGMA
legacy_alter_table
= ON;

ALTER TABLE shopping_list
    RENAME TO shopping_list_old;

CREATE TABLE shopping_list
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER,
    note                  TEXT,
    amount                INTEGER NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO shopping_list
    (product_id, amount, note, row_created_timestamp)
SELECT product_id, amount + amount_autoadded, note, row_created_timestamp
FROM shopping_list_old;

DROP TABLE shopping_list_old;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount                                            AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END                                       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) -
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) -
                       CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END)
           ELSE 0 END                                       AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock) >=
                CASE WHEN rp.only_check_single_unit_in_stock = 1 THEN 1 ELSE IFNULL(rp.amount, 0) END THEN 1
           ELSE 0 END                                       AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount                                            AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       1                                                    AS need_fulfilled,
       0                                                    AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       1                                                    AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0048.sql

-- BEGIN 0049.sql
ALTER TABLE products
    ADD allow_partial_units_in_stock TINYINT NOT NULL DEFAULT 0;

PRAGMA
legacy_alter_table
= ON;

ALTER TABLE stock
    RENAME TO stock_old;

CREATE TABLE stock
(
    id                    INTEGER        NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER        NOT NULL,
    amount                DECIMAL(15, 2) NOT NULL,
    best_before_date      DATE,
    purchased_date        DATE                    DEFAULT (datetime('now', 'localtime')),
    stock_id              TEXT           NOT NULL,
    price                 DECIMAL(15, 2),
    open                  TINYINT        NOT NULL DEFAULT 0 CHECK (open IN (0, 1)),
    opened_date           DATETIME,
    row_created_timestamp DATETIME                DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO stock
(product_id, amount, best_before_date, purchased_date, stock_id, price, open, opened_date, row_created_timestamp)
SELECT product_id,
       amount,
       best_before_date,
       purchased_date,
       stock_id,
       price,
       open,
       opened_date,
       row_created_timestamp
FROM stock_old;

DROP TABLE stock_old;

ALTER TABLE stock_log
    RENAME TO stock_log_old;

CREATE TABLE stock_log
(
    id                    INTEGER        NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER        NOT NULL,
    amount                DECIMAL(15, 2) NOT NULL,
    best_before_date      DATE,
    purchased_date        DATE,
    used_date             DATE,
    spoiled               INTEGER        NOT NULL DEFAULT 0,
    stock_id              TEXT           NOT NULL,
    transaction_type      TEXT           NOT NULL,
    price                 DECIMAL(15, 2),
    undone                TINYINT        NOT NULL DEFAULT 0 CHECK (undone IN (0, 1)),
    undone_timestamp      DATETIME,
    opened_date           DATETIME,
    row_created_timestamp DATETIME                DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO stock_log
(product_id, amount, best_before_date, purchased_date, used_date, spoiled, stock_id, transaction_type, price, undone,
 undone_timestamp, opened_date, row_created_timestamp)
SELECT product_id,
       amount,
       best_before_date,
       purchased_date,
       used_date,
       spoiled,
       stock_id,
       transaction_type,
       price,
       undone,
       undone_timestamp,
       opened_date,
       row_created_timestamp
FROM stock_log_old;

DROP TABLE stock_log_old;

ALTER TABLE shopping_list
    RENAME TO shopping_list_old;

CREATE TABLE shopping_list
(
    id                    INTEGER        NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER,
    note                  TEXT,
    amount                DECIMAL(15, 2) NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME                DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO shopping_list
    (product_id, amount, note, row_created_timestamp)
SELECT product_id, amount, note, row_created_timestamp
FROM shopping_list_old;

DROP TABLE shopping_list_old;
-- END 0049.sql

-- BEGIN 0050.sql
ALTER TABLE recipes
    ADD picture_file_name TEXT;
-- END 0050.sql

-- BEGIN 0051.sql
ALTER TABLE stock
    ADD location_id INTEGER;

ALTER TABLE stock_log
    ADD location_id INTEGER;

CREATE VIEW stock_current_locations
AS
SELECT s.product_id,
       IFNULL(s.location_id, p.location_id) AS location_id
FROM stock s
         JOIN products p
              ON s.product_id = p.id
GROUP BY s.product_id, IFNULL(s.location_id, p.location_id);
-- END 0051.sql

-- BEGIN 0052.sql
ALTER TABLE recipes
    ADD base_servings INTEGER DEFAULT 1;

ALTER TABLE recipes
    ADD desired_servings INTEGER DEFAULT 1;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount * (r.desired_servings / r.base_servings)   AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END
               THEN 1
           ELSE 0 END                                       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END < 0
               THEN ABS(IFNULL(sc.amount, 0) - (CASE
                                                    WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                    ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END))
           ELSE 0 END                                       AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock) >= CASE
                                                                                                     WHEN rp.only_check_single_unit_in_stock = 1
                                                                                                         THEN 1
                                                                                                     ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END
               THEN 1
           ELSE 0 END                                       AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount * (r.desired_servings / r.base_servings)   AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       1                                                    AS need_fulfilled,
       0                                                    AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       1                                                    AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0052.sql

-- BEGIN 0053.sql
ALTER TABLE recipes
    ADD not_check_shoppinglist TINYINT NOT NULL DEFAULT 0;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount * (r.desired_servings / r.base_servings)   AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END
               THEN 1
           ELSE 0 END                                       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END < 0
               THEN ABS(IFNULL(sc.amount, 0) - (CASE
                                                    WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                    ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END))
           ELSE 0 END                                       AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END
               THEN 1
           ELSE 0 END                                       AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount * (r.desired_servings / r.base_servings)   AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       1                                                    AS need_fulfilled,
       0                                                    AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       1                                                    AS need_fulfilled_with_shopping_list,
       rp.qu_id
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0053.sql

-- BEGIN 0054.sql
CREATE VIEW products_current_price
AS
SELECT p.id                AS product_id,
       IFNULL(sl.price, 0) AS last_price
FROM products p
         LEFT JOIN (
    SELECT product_id, MAX(id) AS newest_Id
    FROM stock_log
    WHERE undone = 0
      AND transaction_type = 'purchase'
    GROUP BY product_id
) slg
                   ON p.id = slg.product_id
         LEFT JOIN stock_log sl
                   ON slg.newest_id = sl.id;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_fulfillment
AS
SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount * (r.desired_servings / r.base_servings)   AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END
               THEN 1
           ELSE 0 END                                       AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END < 0
               THEN ABS(IFNULL(sc.amount, 0) - (CASE
                                                    WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                    ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END))
           ELSE 0 END                                       AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) END
               THEN 1
           ELSE 0 END                                       AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings / r.base_servings) END / p.qu_factor_purchase_to_stock) *
       pcp.last_price                                       AS costs
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                 AS recipe_id,
       rp.id                                                AS recipe_pos_id,
       rp.product_id                                        AS product_id,
       rp.amount * (r.desired_servings / r.base_servings)   AS recipe_amount,
       IFNULL(sc.amount, 0)                                 AS stock_amount,
       1                                                    AS need_fulfilled,
       0                                                    AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock AS amount_on_shopping_list,
       1                                                    AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings / r.base_servings) END / p.qu_factor_purchase_to_stock) *
       pcp.last_price                                       AS costs
FROM recipes r
         JOIN recipes_pos rp
              ON r.id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0054.sql

-- BEGIN 0055.sql
ALTER TABLE stock_log
    ADD recipe_id INTEGER;
-- END 0055.sql

-- BEGIN 0056.sql
ALTER TABLE api_keys
    ADD key_type TEXT NOT NULL DEFAULT 'default';
-- END 0056.sql

-- BEGIN 0057.sql
ALTER TABLE products
    ADD enable_tare_weight_handling TINYINT NOT NULL DEFAULT 0;

ALTER TABLE products
    ADD tare_weight REAL NOT NULL DEFAULT 0;
-- END 0057.sql

-- BEGIN 0058.sql
ALTER TABLE recipes_nestings
    ADD servings INTEGER DEFAULT 1;

DROP VIEW recipes_nestings_resolved;
CREATE VIEW recipes_nestings_resolved
AS
WITH RECURSIVE r1(recipe_id, includes_recipe_id, includes_servings)
                   AS (
        SELECT id, id, 1
        FROM recipes

        UNION ALL

        SELECT rn.recipe_id, r1.includes_recipe_id, rn.servings
        FROM recipes_nestings rn,
             r1 r1
        WHERE rn.includes_recipe_id = r1.recipe_id
        LIMIT 100 -- This is just a safety limit to prevent infinite loops due to infinite nested recipes
    )
SELECT *
FROM r1;

DROP VIEW recipes_fulfillment;
CREATE VIEW recipes_pos_resolved
AS
SELECT r.id                                                                       AS recipe_id,
       rp.id                                                                      AS recipe_pos_id,
       rp.product_id                                                              AS product_id,
       rp.amount * (r.desired_servings / r.base_servings) * rnr.includes_servings AS recipe_amount,
       IFNULL(sc.amount, 0)                                                       AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) *
                                                 rnr.includes_servings END THEN 1
           ELSE 0 END                                                             AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE IFNULL(rp.amount, 0) * (r.desired_servings / r.base_servings) *
                                                rnr.includes_servings END < 0 THEN ABS(IFNULL(sc.amount, 0) - (CASE
                                                                                                                   WHEN rp.only_check_single_unit_in_stock = 1
                                                                                                                       THEN 1
                                                                                                                   ELSE IFNULL(rp.amount, 0) *
                                                                                                                        (r.desired_servings / r.base_servings) *
                                                                                                                        rnr.includes_servings END))
           ELSE 0 END                                                             AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                       AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE IFNULL(rp.amount, 0) *
                                                                                   (r.desired_servings / r.base_servings) *
                                                                                   rnr.includes_servings END THEN 1
           ELSE 0 END                                                             AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings / r.base_servings) * rnr.includes_servings END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                           AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END         AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                     as child_recipe_id
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                       AS recipe_id,
       rp.id                                                                      AS recipe_pos_id,
       rp.product_id                                                              AS product_id,
       rp.amount * (r.desired_servings / r.base_servings) * rnr.includes_servings AS recipe_amount,
       IFNULL(sc.amount, 0)                                                       AS stock_amount,
       1                                                                          AS need_fulfilled,
       0                                                                          AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                       AS amount_on_shopping_list,
       1                                                                          AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings / r.base_servings) * rnr.includes_servings END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                           AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END         AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                     as child_recipe_id
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;

DROP VIEW recipes_fulfillment_sum;
CREATE VIEW recipes_resolved
AS
SELECT r.id                                                  AS recipe_id,
       IFNULL(MIN(rpr.need_fulfilled), 1)                    AS need_fulfilled,
       IFNULL(MIN(rpr.need_fulfilled_with_shopping_list), 1) AS need_fulfilled_with_shopping_list,
       (SELECT COUNT(*)
        FROM recipes_pos_resolved
        WHERE recipe_id = r.id
          AND need_fulfilled = 0)                            AS missing_products_count,
       SUM(rpr.costs)                                        AS costs
FROM recipes r
         LEFT JOIN recipes_pos_resolved rpr
                   ON r.id = rpr.recipe_id
GROUP BY r.id;
-- END 0058.sql

-- BEGIN 0059.sql
DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                         AS recipe_id,
       rp.id                                                                                        AS recipe_pos_id,
       rp.product_id                                                                                AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                         AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                 rnr.includes_servings * 1.0 END THEN 1
           ELSE 0 END                                                                               AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                rnr.includes_servings * 1.0 END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) - (CASE
                                                   WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                   ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                        rnr.includes_servings * 1.0 END))
           ELSE 0 END                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                         AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE rp.amount *
                                                                                   (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                                   rnr.includes_servings * 1.0 END
               THEN 1
           ELSE 0 END                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                                             AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                           AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                       as child_recipe_id
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                         AS recipe_id,
       rp.id                                                                                        AS recipe_pos_id,
       rp.product_id                                                                                AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                         AS stock_amount,
       1                                                                                            AS need_fulfilled,
       0                                                                                            AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                         AS amount_on_shopping_list,
       1                                                                                            AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                                             AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                           AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                       as child_recipe_id
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;

DROP VIEW recipes_resolved;
CREATE VIEW recipes_resolved
AS
SELECT r.id                                                  AS recipe_id,
       IFNULL(MIN(rpr.need_fulfilled), 1)                    AS need_fulfilled,
       IFNULL(MIN(rpr.need_fulfilled_with_shopping_list), 1) AS need_fulfilled_with_shopping_list,
       (SELECT COUNT(*)
        FROM recipes_pos_resolved
        WHERE recipe_id = r.id
          AND need_fulfilled = 0)                            AS missing_products_count,
       IFNULL(SUM(rpr.costs), 0)                             AS costs
FROM recipes r
         LEFT JOIN recipes_pos_resolved rpr
                   ON r.id = rpr.recipe_id
GROUP BY r.id;
-- END 0059.sql

-- BEGIN 0060.sql
DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                         AS recipe_id,
       rp.id                                                                                        AS recipe_pos_id,
       rp.product_id                                                                                AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                         AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                 rnr.includes_servings * 1.0 END THEN 1
           ELSE 0 END                                                                               AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                rnr.includes_servings * 1.0 END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) - (CASE
                                                   WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                   ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                        rnr.includes_servings * 1.0 END))
           ELSE 0 END                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                         AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE rp.amount *
                                                                                   (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                                   rnr.includes_servings * 1.0 END
               THEN 1
           ELSE 0 END                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                                             AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                           AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                       as child_recipe_id,
       rp.note
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                         AS recipe_id,
       rp.id                                                                                        AS recipe_pos_id,
       rp.product_id                                                                                AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                         AS stock_amount,
       1                                                                                            AS need_fulfilled,
       0                                                                                            AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                         AS amount_on_shopping_list,
       1                                                                                            AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                                             AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                           AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                       as child_recipe_id,
       rp.note
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0060.sql

-- BEGIN 0061.sql
ALTER TABLE products
    ADD not_check_stock_fulfillment_for_recipes TINYINT DEFAULT 0;
-- END 0061.sql

-- BEGIN 0062.sql
ALTER TABLE shopping_list
    ADD shopping_list_id INT DEFAULT 1;

CREATE TABLE shopping_lists
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

INSERT INTO shopping_lists
    (name)
VALUES ('Default');
-- END 0062.sql

-- BEGIN 0064.sql
CREATE VIEW stock_average_product_shelf_life
AS
SELECT p.id,
       CASE WHEN x.product_id IS NULL THEN -1 ELSE AVG(x.shelf_life_days) END AS average_shelf_life_days
FROM products p
         LEFT JOIN (
    SELECT sl_p.product_id,
           JULIANDAY(MIN(sl_p.best_before_date)) - JULIANDAY(MIN(sl_c.used_date)) AS shelf_life_days
    FROM stock_log sl_p
             JOIN (
        SELECT product_id,
               stock_id,
               MAX(used_date) AS used_date
        FROM stock_log
        WHERE transaction_type = 'consume'
        GROUP BY product_id, stock_id
    ) sl_c
                  ON sl_p.stock_id = sl_c.stock_id
    WHERE sl_p.transaction_type = 'purchase'
    GROUP BY sl_p.product_id, sl_p.stock_id
) x
                   ON p.id = x.product_id
GROUP BY p.id;
-- END 0064.sql

-- BEGIN 0065.sql
ALTER TABLE chores
    ADD period_config TEXT;

DROP VIEW chores_current;
CREATE VIEW chores_current
AS
SELECT h.id                AS chore_id,
       MAX(l.tracked_time) AS last_tracked_time,
       CASE h.period_type
           WHEN 'manually' THEN '2999-12-31 23:59:59'
           WHEN 'dynamic-regular' THEN DATETIME(MAX(l.tracked_time), '+' || CAST(h.period_days AS TEXT) || ' day')
           WHEN 'daily' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 day')
           WHEN 'weekly' THEN
               CASE
                   WHEN period_config LIKE '%sunday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 0')
                   WHEN period_config LIKE '%monday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 1')
                   WHEN period_config LIKE '%tuesday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 2')
                   WHEN period_config LIKE '%wednesday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 3')
                   WHEN period_config LIKE '%thursday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 4')
                   WHEN period_config LIKE '%friday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 5')
                   WHEN period_config LIKE '%saturday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), 'weekday 6')
                   END
           WHEN 'monthly' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 month',
                                        'start of month', '+' || CAST(h.period_days - 1 AS TEXT) || ' day')
           END             AS next_estimated_execution_time
FROM chores h
         LEFT JOIN chores_log l
                   ON h.id = l.chore_id
GROUP BY h.id, h.period_days;
-- END 0065.sql

-- BEGIN 0066.sql
CREATE TABLE userfields
(
    id                       INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    entity                   TEXT    NOT NULL,
    name                     TEXT    NOT NULL,
    caption                  TEXT    NOT NULL,
    type                     TEXT    NOT NULL,
    show_as_column_in_tables TINYINT NOT NULL DEFAULT 0,
    row_created_timestamp    DATETIME         DEFAULT (datetime('now', 'localtime')),

    UNIQUE (entity, name)
);

CREATE TABLE userfield_values
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    field_id              INTEGER NOT NULL,
    object_id             INTEGER NOT NULL,
    value                 TEXT    NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),

    UNIQUE (field_id, object_id)
);

CREATE VIEW userfield_values_resolved
AS
SELECT u.*,
       uv.object_id,
       uv.value
FROM userfields u
         JOIN userfield_values uv
              ON u.id = uv.field_id;
-- END 0066.sql

-- BEGIN 0067.sql
ALTER TABLE quantity_units
    ADD plural_forms TEXT;
-- END 0067.sql

-- BEGIN 0068.sql
ALTER TABLE recipes_pos
    ADD variable_amount TEXT;

DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                         AS recipe_id,
       rp.id                                                                                        AS recipe_pos_id,
       rp.product_id                                                                                AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                         AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                 rnr.includes_servings * 1.0 END THEN 1
           ELSE 0 END                                                                               AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                rnr.includes_servings * 1.0 END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) - (CASE
                                                   WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                   ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                        rnr.includes_servings * 1.0 END))
           ELSE 0 END                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                         AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE rp.amount *
                                                                                   (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                                   rnr.includes_servings * 1.0 END
               THEN 1
           ELSE 0 END                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                                             AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                           AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                       as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                           AS recipe_variable_amount
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                         AS recipe_id,
       rp.id                                                                                        AS recipe_pos_id,
       rp.product_id                                                                                AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                         AS stock_amount,
       1                                                                                            AS need_fulfilled,
       0                                                                                            AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                         AS amount_on_shopping_list,
       1                                                                                            AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * rnr.includes_servings * 1.0 END /
        p.qu_factor_purchase_to_stock) * pcp.last_price                                             AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                           AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                       as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                           AS recipe_variable_amount
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0068.sql

-- BEGIN 0069.sql
ALTER TABLE chores
    ADD track_date_only TINYINT DEFAULT 0;
-- END 0069.sql

-- BEGIN 0070.sql
CREATE TABLE meal_plan
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    day                   DATE    NOT NULL,
    recipe_id             INTEGER NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),

    UNIQUE (day, recipe_id)
);
-- END 0070.sql

-- BEGIN 0071.sql
ALTER TABLE meal_plan
    ADD servings INTEGER DEFAULT 1;

ALTER TABLE recipes
    ADD type TEXT DEFAULT 'normal';

CREATE INDEX ix_recipes ON recipes (
                                    name,
                                    type
    );

CREATE TRIGGER create_internal_recipe
    AFTER INSERT
    ON meal_plan
BEGIN
    -- Create a recipe per day
    DELETE
    FROM recipes
    WHERE name = NEW.day
      AND type = 'mealplan-day';

    INSERT OR
    REPLACE
    INTO recipes
        (id, name, type)
    VALUES ((SELECT MIN(id) - 1 FROM recipes), NEW.day, 'mealplan-day');

    -- Create a recipe per week
    DELETE
    FROM recipes
    WHERE name = LTRIM(STRFTIME('%Y-%W', NEW.day), '0')
      AND type = 'mealplan-week';

    INSERT INTO recipes
        (id, name, type)
    VALUES ((SELECT MIN(id) - 1 FROM recipes), LTRIM(STRFTIME('%Y-%W', NEW.day), '0'), 'mealplan-week');

    -- Delete all current nestings entries for the day and week recipe
    DELETE
    FROM recipes_nestings
    WHERE recipe_id IN (SELECT id FROM recipes WHERE name = NEW.day AND type = 'mealplan-day')
       OR recipe_id IN (SELECT id FROM recipes WHERE name = NEW.day AND type = 'mealplan-week');

    -- Add all recipes for this day as included recipes in the day-recipe
    INSERT INTO recipes_nestings
        (recipe_id, includes_recipe_id, servings)
    SELECT (SELECT id FROM recipes WHERE name = NEW.day AND type = 'mealplan-day'), recipe_id, SUM(servings)
    FROM meal_plan
    WHERE day = NEW.day
    GROUP BY recipe_id;

    -- Add all recipes for this week as included recipes in the week-recipe
    INSERT INTO recipes_nestings
        (recipe_id, includes_recipe_id, servings)
    SELECT (SELECT id FROM recipes WHERE name = LTRIM(STRFTIME('%Y-%W', NEW.day), '0') AND type = 'mealplan-week'),
           recipe_id,
           SUM(servings)
    FROM meal_plan
    WHERE STRFTIME('%Y-%W', day) = STRFTIME('%Y-%W', NEW.day)
    GROUP BY recipe_id;
END;
-- END 0071.sql

-- BEGIN 0072.sql
ALTER TABLE userfields
    ADD config TEXT;
-- END 0072.sql

-- BEGIN 0073.sql
DROP TRIGGER create_internal_recipe;
CREATE TRIGGER create_internal_recipe
    AFTER INSERT
    ON meal_plan
BEGIN
    /* This contains practically the same logic as the trigger remove_internal_recipe */

    -- Create a recipe per day
    DELETE
    FROM recipes
    WHERE name = NEW.day
      AND type = 'mealplan-day';

    INSERT OR
    REPLACE
    INTO recipes
        (id, name, type)
    VALUES ((SELECT MIN(id) - 1 FROM recipes), NEW.day, 'mealplan-day');

    -- Create a recipe per week
    DELETE
    FROM recipes
    WHERE name = LTRIM(STRFTIME('%Y-%W', NEW.day), '0')
      AND type = 'mealplan-week';

    INSERT INTO recipes
        (id, name, type)
    VALUES ((SELECT MIN(id) - 1 FROM recipes), LTRIM(STRFTIME('%Y-%W', NEW.day), '0'), 'mealplan-week');

    -- Delete all current nestings entries for the day and week recipe
    DELETE
    FROM recipes_nestings
    WHERE recipe_id IN (SELECT id FROM recipes WHERE name = NEW.day AND type = 'mealplan-day')
       OR recipe_id IN (SELECT id FROM recipes WHERE name = NEW.day AND type = 'mealplan-week');

    -- Add all recipes for this day as included recipes in the day-recipe
    INSERT INTO recipes_nestings
        (recipe_id, includes_recipe_id, servings)
    SELECT (SELECT id FROM recipes WHERE name = NEW.day AND type = 'mealplan-day'), recipe_id, SUM(servings)
    FROM meal_plan
    WHERE day = NEW.day
    GROUP BY recipe_id;

    -- Add all recipes for this week as included recipes in the week-recipe
    INSERT INTO recipes_nestings
        (recipe_id, includes_recipe_id, servings)
    SELECT (SELECT id FROM recipes WHERE name = LTRIM(STRFTIME('%Y-%W', NEW.day), '0') AND type = 'mealplan-week'),
           recipe_id,
           SUM(servings)
    FROM meal_plan
    WHERE STRFTIME('%Y-%W', day) = STRFTIME('%Y-%W', NEW.day)
    GROUP BY recipe_id;
END;

CREATE TRIGGER remove_internal_recipe
    AFTER DELETE
    ON meal_plan
BEGIN
    /* This contains practically the same logic as the trigger create_internal_recipe */

    -- Create a recipe per day
    DELETE
    FROM recipes
    WHERE name = OLD.day
      AND type = 'mealplan-day';

    INSERT OR
    REPLACE
    INTO recipes
        (id, name, type)
    VALUES ((SELECT MIN(id) - 1 FROM recipes), OLD.day, 'mealplan-day');

    -- Create a recipe per week
    DELETE
    FROM recipes
    WHERE name = LTRIM(STRFTIME('%Y-%W', OLD.day), '0')
      AND type = 'mealplan-week';

    INSERT INTO recipes
        (id, name, type)
    VALUES ((SELECT MIN(id) - 1 FROM recipes), LTRIM(STRFTIME('%Y-%W', OLD.day), '0'), 'mealplan-week');

    -- Delete all current nestings entries for the day and week recipe
    DELETE
    FROM recipes_nestings
    WHERE recipe_id IN (SELECT id FROM recipes WHERE name = OLD.day AND type = 'mealplan-day')
       OR recipe_id IN (SELECT id FROM recipes WHERE name = OLD.day AND type = 'mealplan-week');

    -- Add all recipes for this day as included recipes in the day-recipe
    INSERT INTO recipes_nestings
        (recipe_id, includes_recipe_id, servings)
    SELECT (SELECT id FROM recipes WHERE name = OLD.day AND type = 'mealplan-day'), recipe_id, SUM(servings)
    FROM meal_plan
    WHERE day = OLD.day
    GROUP BY recipe_id;

    -- Add all recipes for this week as included recipes in the week-recipe
    INSERT INTO recipes_nestings
        (recipe_id, includes_recipe_id, servings)
    SELECT (SELECT id FROM recipes WHERE name = LTRIM(STRFTIME('%Y-%W', OLD.day), '0') AND type = 'mealplan-week'),
           recipe_id,
           SUM(servings)
    FROM meal_plan
    WHERE STRFTIME('%Y-%W', day) = STRFTIME('%Y-%W', OLD.day)
    GROUP BY recipe_id;
END;
-- END 0073.sql

-- BEGIN 0074.sql
DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                                            AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                 (rnr.includes_servings * 1.0 / CASE
                                                                                    WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                        THEN rnrr.base_servings * 1.0
                                                                                    ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                (rnr.includes_servings * 1.0 / CASE
                                                                                   WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                       THEN rnrr.base_servings * 1.0
                                                                                   ELSE 1 END) END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) - (CASE
                                                   WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                   ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                        (rnr.includes_servings * 1.0 / CASE
                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                               THEN rnrr.base_servings * 1.0
                                                                                           ELSE 1 END) END))
           ELSE 0 END                                                                                                  AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE rp.amount *
                                                                                   (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                                   (rnr.includes_servings * 1.0 / CASE
                                                                                                                      WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                          THEN rnrr.base_servings * 1.0
                                                                                                                      ELSE 1 END) END
               THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) *
       pcp.last_price                                                                                                  AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                                            AS stock_amount,
       1                                                                                                               AS need_fulfilled,
       0                                                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       1                                                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) *
       pcp.last_price                                                                                                  AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0074.sql

-- BEGIN 0075.sql
ALTER TABLE shopping_list
    ADD done INT DEFAULT 0;
-- END 0075.sql

-- BEGIN 0076.sql
DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                                            AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount, 0) >= CASE
                                            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                 (rnr.includes_servings * 1.0 / CASE
                                                                                    WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                        THEN rnrr.base_servings * 1.0
                                                                                    ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount, 0) - CASE
                                           WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                           ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                (rnr.includes_servings * 1.0 / CASE
                                                                                   WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                       THEN rnrr.base_servings * 1.0
                                                                                   ELSE 1 END) END < 0 THEN ABS(
                       IFNULL(sc.amount, 0) - (CASE
                                                   WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                   ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                        (rnr.includes_servings * 1.0 / CASE
                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                               THEN rnrr.base_servings * 1.0
                                                                                           ELSE 1 END) END))
           ELSE 0 END                                                                                                  AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount, 0) + (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                                        p.qu_factor_purchase_to_stock) >= CASE
                                                                              WHEN rp.only_check_single_unit_in_stock = 1
                                                                                  THEN 1
                                                                              ELSE rp.amount *
                                                                                   (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                                   (rnr.includes_servings * 1.0 / CASE
                                                                                                                      WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                          THEN rnrr.base_servings * 1.0
                                                                                                                      ELSE 1 END) END
               THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) *
       pcp.last_price                                                                                                  AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount, 0)                                                                                            AS stock_amount,
       1                                                                                                               AS need_fulfilled,
       0                                                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       1                                                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) *
       pcp.last_price                                                                                                  AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0076.sql

-- BEGIN 0077.sql
DROP VIEW chores_current;
CREATE VIEW chores_current
AS
SELECT h.id                AS chore_id,
       MAX(l.tracked_time) AS last_tracked_time,
       CASE h.period_type
           WHEN 'manually' THEN '2999-12-31 23:59:59'
           WHEN 'dynamic-regular' THEN DATETIME(MAX(l.tracked_time), '+' || CAST(h.period_days AS TEXT) || ' day')
           WHEN 'daily' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 day')
           WHEN 'weekly' THEN
               CASE
                   WHEN period_config LIKE '%sunday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 0')
                   WHEN period_config LIKE '%monday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 1')
                   WHEN period_config LIKE '%tuesday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 2')
                   WHEN period_config LIKE '%wednesday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 3')
                   WHEN period_config LIKE '%thursday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 4')
                   WHEN period_config LIKE '%friday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 5')
                   WHEN period_config LIKE '%saturday%' THEN DATETIME(
                           IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 6')
                   END
           WHEN 'monthly' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 month',
                                        'start of month', '+' || CAST(h.period_days - 1 AS TEXT) || ' day')
           END             AS next_estimated_execution_time,
       h.track_date_only
FROM chores h
         LEFT JOIN chores_log l
                   ON h.id = l.chore_id
                       AND l.undone = 0
GROUP BY h.id, h.period_days;
-- END 0077.sql

-- BEGIN 0078.sql
ALTER TABLE chores
    ADD rollover TINYINT DEFAULT 0;

DROP VIEW chores_current;
CREATE VIEW chores_current
AS
SELECT x.chore_id,
       x.last_tracked_time,
       CASE
           WHEN x.rollover = 1 AND DATETIME('now', 'localtime') > x.next_estimated_execution_time THEN
               DATETIME(STRFTIME('%Y-%m-%d', DATETIME('now', 'localtime')) || ' ' ||
                        STRFTIME('%H:%M:%S', x.next_estimated_execution_time))
           ELSE
               x.next_estimated_execution_time
           END AS next_estimated_execution_time,
       x.track_date_only
FROM (
         SELECT h.id                AS chore_id,
                MAX(l.tracked_time) AS last_tracked_time,
                CASE h.period_type
                    WHEN 'manually' THEN '2999-12-31 23:59:59'
                    WHEN 'dynamic-regular' THEN DATETIME(MAX(l.tracked_time),
                                                         '+' || CAST(h.period_days AS TEXT) || ' day')
                    WHEN 'daily' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 day')
                    WHEN 'weekly' THEN
                        CASE
                            WHEN period_config LIKE '%sunday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 0')
                            WHEN period_config LIKE '%monday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 1')
                            WHEN period_config LIKE '%tuesday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 2')
                            WHEN period_config LIKE '%wednesday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 3')
                            WHEN period_config LIKE '%thursday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 4')
                            WHEN period_config LIKE '%friday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 5')
                            WHEN period_config LIKE '%saturday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 6')
                            END
                    WHEN 'monthly' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 month',
                                                 'start of month', '+' || CAST(h.period_days - 1 AS TEXT) || ' day')
                    END             AS next_estimated_execution_time,
                h.track_date_only,
                h.rollover
         FROM chores h
                  LEFT JOIN chores_log l
                            ON h.id = l.chore_id
                                AND l.undone = 0
         GROUP BY h.id, h.period_days
     ) x;
-- END 0078.sql

-- BEGIN 0079.sql
CREATE VIEW stock_current_location_content
AS
SELECT IFNULL(s.location_id, p.location_id) AS location_id,
       s.product_id,
       SUM(s.amount)                        AS amount,
       MIN(s.best_before_date)              AS best_before_date,
       IFNULL((SELECT SUM(amount)
               FROM stock
               WHERE product_id = s.product_id
                 AND location_id = s.location_id
                 AND open = 1), 0)          AS amount_opened
FROM stock s
         JOIN products p
              ON s.product_id = p.id
GROUP BY IFNULL(s.location_id, p.location_id), s.product_id;
-- END 0079.sql

-- BEGIN 0080.sql
UPDATE products
SET description = REPLACE(description, CHAR(13) + CHAR(10), '<br>');

UPDATE products
SET description = REPLACE(description, CHAR(13), '<br>');

UPDATE products
SET description = REPLACE(description, CHAR(10), '<br>');
-- END 0080.sql

-- BEGIN 0081.sql
ALTER TABLE products
    ADD parent_product_id INT;

CREATE VIEW products_resolved
AS
SELECT p.parent_product_id parent_product_id,
       p.id as             sub_product_id
FROM products p
WHERE p.parent_product_id IS NOT NULL

UNION

SELECT p.id    parent_product_id,
       p.id as sub_product_id
FROM products p
WHERE p.parent_product_id IS NULL;

DROP VIEW stock_current;
CREATE VIEW stock_current
AS
SELECT pr.parent_product_id                                                                            AS product_id,
       IFNULL((SELECT SUM(amount) FROM stock WHERE product_id = pr.parent_product_id), 0)              AS amount,
       SUM(s.amount)                                                                                   AS amount_aggregated,
       MIN(s.best_before_date)                                                                         AS best_before_date,
       IFNULL((SELECT SUM(amount) FROM stock WHERE product_id = pr.parent_product_id AND open = 1), 0) AS amount_opened,
       IFNULL((SELECT SUM(amount)
               FROM stock
               WHERE product_id IN
                     (SELECT sub_product_id FROM products_resolved WHERE parent_product_id = pr.parent_product_id)
                 AND open = 1),
              0)                                                                                       AS amount_opened_aggregated,
       CASE WHEN p.parent_product_id IS NOT NULL THEN 1 ELSE 0 END                                     AS is_aggregated_amount
FROM products_resolved pr
         JOIN stock s
              ON pr.sub_product_id = s.product_id
         JOIN products p
              ON pr.sub_product_id = p.id
GROUP BY pr.parent_product_id
HAVING SUM(s.amount) > 0

UNION

-- This is the same as above but sub products not rolled up (column is_aggregated_amount = 0 here)
SELECT pr.sub_product_id                                                                       AS product_id,
       SUM(s.amount)                                                                           AS amount,
       SUM(s.amount)                                                                           AS amount_aggregated,
       MIN(s.best_before_date)                                                                 AS best_before_date,
       IFNULL((SELECT SUM(amount) FROM stock WHERE product_id = s.product_id AND open = 1), 0) AS amount_opened,
       IFNULL((SELECT SUM(amount) FROM stock WHERE product_id = s.product_id AND open = 1),
              0)                                                                               AS amount_opened_aggregated,
       0                                                                                       AS is_aggregated_amount
FROM products_resolved pr
         JOIN stock s
              ON pr.sub_product_id = s.product_id
WHERE pr.parent_product_id != pr.sub_product_id
GROUP BY pr.sub_product_id
HAVING SUM(s.amount) > 0;

DROP VIEW stock_missing_products;
CREATE VIEW stock_missing_products
AS
SELECT p.id,
       MAX(p.name)                                              AS name,
       p.min_stock_amount - IFNULL(SUM(s.amount), 0)            AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END AS is_partly_in_stock
FROM products p
         LEFT JOIN stock_current s
                   ON p.id = s.product_id
WHERE p.min_stock_amount != 0
GROUP BY p.id
HAVING IFNULL(SUM(s.amount), 0) < p.min_stock_amount;

DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount_aggregated, 0)                                                                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) >= CASE
                                                       WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                       ELSE rp.amount *
                                                            (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                            (rnr.includes_servings * 1.0 / CASE
                                                                                               WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                   THEN rnrr.base_servings * 1.0
                                                                                               ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) - CASE
                                                      WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                      ELSE rp.amount *
                                                           (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                           (rnr.includes_servings * 1.0 / CASE
                                                                                              WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                  THEN rnrr.base_servings * 1.0
                                                                                              ELSE 1 END) END < 0
               THEN ABS(IFNULL(sc.amount_aggregated, 0) - (CASE
                                                               WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                               ELSE rp.amount *
                                                                    (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                    (rnr.includes_servings * 1.0 / CASE
                                                                                                       WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                           THEN rnrr.base_servings * 1.0
                                                                                                       ELSE 1 END) END))
           ELSE 0 END                                                                                                  AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) +
                (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                 p.qu_factor_purchase_to_stock) >= CASE
                                                       WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                       ELSE rp.amount *
                                                            (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                            (rnr.includes_servings * 1.0 / CASE
                                                                                               WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                   THEN rnrr.base_servings * 1.0
                                                                                               ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) *
       pcp.last_price                                                                                                  AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount_aggregated, 0)                                                                                 AS stock_amount,
       1                                                                                                               AS need_fulfilled,
       0                                                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       1                                                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) *
       pcp.last_price                                                                                                  AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0081.sql

-- BEGIN 0082.sql
CREATE TABLE quantity_unit_conversions
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    from_qu_id            INT     NOT NULL,
    to_qu_id              INT     NOT NULL,
    factor                REAL    NOT NULL,
    product_id            INT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);

CREATE TRIGGER quantity_unit_conversions_custom_unique_constraint_INS
    BEFORE INSERT
    ON quantity_unit_conversions
BEGIN
    -- Necessary because unique constraints don't include NULL values in SQLite, and also because the constraint should include the products default conversion factor
    SELECT CASE
               WHEN ((
                   SELECT 1
                   FROM quantity_unit_conversions
                   WHERE from_qu_id = NEW.from_qu_id
                     AND to_qu_id = NEW.to_qu_id
                     AND IFNULL(product_id, 0) = IFNULL(NEW.product_id, 0)
                   UNION
                   SELECT 1
                   FROM products
                   WHERE id = NEW.product_id
                     AND qu_id_purchase = NEW.from_qu_id
                     AND qu_id_stock = NEW.to_qu_id
               )
                   NOTNULL) THEN RAISE(ABORT, "Unique constraint violation") END;
END;

CREATE TRIGGER quantity_unit_conversions_custom_unique_constraint_UPD
    BEFORE UPDATE
    ON quantity_unit_conversions
BEGIN
    -- Necessary because unique constraints don't include NULL values in SQLite, and also because the constraint should include the products default conversion factor
    SELECT CASE
               WHEN ((
                   SELECT 1
                   FROM quantity_unit_conversions
                   WHERE from_qu_id = NEW.from_qu_id
                     AND to_qu_id = NEW.to_qu_id
                     AND IFNULL(product_id, 0) = IFNULL(NEW.product_id, 0)
                     AND id != NEW.id
                   UNION
                   SELECT 1
                   FROM products
                   WHERE id = NEW.product_id
                     AND qu_id_purchase = NEW.from_qu_id
                     AND qu_id_stock = NEW.to_qu_id
               )
                   NOTNULL) THEN RAISE(ABORT, "Unique constraint violation") END;
END;

CREATE VIEW quantity_unit_conversions_resolved
AS
-- First: Product "purchase to stock" conversion factor
SELECT p.id                          AS id, -- Dummy, LessQL needs an id column
       p.id                          AS product_id,
       p.qu_id_purchase              AS from_qu_id,
       qu_from.name                  AS from_qu_name,
       p.qu_id_stock                 AS to_qu_id,
       qu_to.name                    AS to_qu_name,
       p.qu_factor_purchase_to_stock AS factor
FROM products p
         JOIN quantity_units qu_from
              ON p.qu_id_purchase = qu_from.id
         JOIN quantity_units qu_to
              ON p.qu_id_stock = qu_to.id

UNION

-- Second: Product specific overrides
SELECT p.id           AS id, -- Dummy, LessQL needs an id column
       p.id           AS product_id,
       quc.from_qu_id AS from_qu_id,
       qu_from.name   AS from_qu_name,
       quc.to_qu_id   AS to_qu_id,
       qu_to.name     AS to_qu_name,
       quc.factor     AS factor
FROM products p
         JOIN quantity_unit_conversions quc
              ON p.qu_id_stock = quc.from_qu_id
                  AND p.id = quc.product_id
         JOIN quantity_units qu_from
              ON quc.from_qu_id = qu_from.id
         JOIN quantity_units qu_to
              ON quc.to_qu_id = qu_to.id

UNION

-- Third: Default quantity unit conversion factors
SELECT p.id          AS id, -- Dummy, LessQL needs an id column
       p.id          AS product_id,
       p.qu_id_stock AS from_qu_id,
       qu_from.name  AS from_qu_name,
       quc.to_qu_id  AS to_qu_id,
       qu_to.name    AS to_qu_name,
       quc.factor    AS factor
FROM products p
         JOIN quantity_unit_conversions quc
              ON p.qu_id_stock = quc.from_qu_id
                  AND quc.product_id IS NULL
         JOIN quantity_units qu_from
              ON quc.from_qu_id = qu_from.id
         JOIN quantity_units qu_to
              ON quc.to_qu_id = qu_to.id;

DROP TRIGGER cascade_change_qu_id_stock;
CREATE TRIGGER cascade_change_qu_id_stock
    AFTER UPDATE
    ON products
BEGIN
    UPDATE recipes_pos
    SET qu_id = NEW.qu_id_stock
    WHERE product_id = NEW.id
      AND qu_id = OLD.qu_id_stock;
END;
-- END 0082.sql

-- BEGIN 0083.sql
ALTER TABLE chores ADD assignment_type TEXT;

ALTER TABLE chores ADD assignment_config TEXT;

ALTER TABLE chores ADD next_execution_assigned_to_user_id INT;

DROP VIEW chores_current;
CREATE VIEW chores_current
AS
SELECT x.chore_id,
       x.last_tracked_time,
       CASE
           WHEN x.rollover = 1 AND DATETIME('now', 'localtime') > x.next_estimated_execution_time THEN
               DATETIME(STRFTIME('%Y-%m-%d', DATETIME('now', 'localtime')) || ' ' ||
                        STRFTIME('%H:%M:%S', x.next_estimated_execution_time))
           ELSE
               x.next_estimated_execution_time
           END AS next_estimated_execution_time,
       x.track_date_only,
       x.next_execution_assigned_to_user_id
FROM (
         SELECT h.id                AS chore_id,
                MAX(l.tracked_time) AS last_tracked_time,
                CASE h.period_type
                    WHEN 'manually' THEN '2999-12-31 23:59:59'
                    WHEN 'dynamic-regular' THEN DATETIME(MAX(l.tracked_time),
                                                         '+' || CAST(h.period_days AS TEXT) || ' day')
                    WHEN 'daily' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 day')
                    WHEN 'weekly' THEN
                        CASE
                            WHEN period_config LIKE '%sunday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 0')
                            WHEN period_config LIKE '%monday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 1')
                            WHEN period_config LIKE '%tuesday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 2')
                            WHEN period_config LIKE '%wednesday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 3')
                            WHEN period_config LIKE '%thursday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 4')
                            WHEN period_config LIKE '%friday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 5')
                            WHEN period_config LIKE '%saturday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days', 'weekday 6')
                            END
                    WHEN 'monthly' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '+1 month',
                                                 'start of month', '+' || CAST(h.period_days - 1 AS TEXT) || ' day')
                    END             AS next_estimated_execution_time,
                h.track_date_only,
                h.rollover,
                h.next_execution_assigned_to_user_id
         FROM chores h
                  LEFT JOIN chores_log l
                            ON h.id = l.chore_id
                                AND l.undone = 0
         GROUP BY h.id, h.period_days
     ) x;

CREATE VIEW chores_assigned_users_resolved
AS
SELECT c.id AS chore_id,
       u.id AS user_id
FROM chores c
         JOIN users u
              ON ',' || c.assignment_config || ',' LIKE '%,' || CAST(u.id AS TEXT) || ',%';

CREATE VIEW chores_execution_users_statistics
AS
SELECT c.id               AS id, -- Dummy, LessQL needs an id column
       c.id               AS chore_id,
       caur.user_id       AS user_id,
       (SELECT COUNT(1)
        FROM chores_log
        WHERE chore_id = c.id
          AND done_by_user_id = caur.user_id
          AND undone = 0) AS execution_count
FROM chores c
         JOIN chores_assigned_users_resolved caur
              ON c.id = caur.chore_id
GROUP BY c.id, caur.user_id;
-- END 0083.sql

-- BEGIN 0084.sql
ALTER TABLE chores
    ADD consume_product_on_execution TINYINT NOT NULL DEFAULT 0;

ALTER TABLE chores
    ADD product_id TINYINT;

ALTER TABLE chores
    ADD product_amount REAL;
-- END 0084.sql

-- BEGIN 0085.sql
CREATE TABLE userentities
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL,
    caption               TEXT    NOT NULL,
    description           TEXT,
    show_in_sidebar_menu  TINYINT NOT NULL DEFAULT 1,
    icon_css_class        TEXT,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime')),

    UNIQUE (name)
);

CREATE TABLE userobjects
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    userentity_id         INTEGER NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
-- END 0085.sql

-- BEGIN 0086.sql
CREATE VIEW stock_missing_products_including_opened
AS
SELECT p.id,
       MAX(p.name)                                                                       AS name,
       p.min_stock_amount - (IFNULL(SUM(s.amount), 0) - IFNULL(SUM(s.amount_opened), 0)) AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END                          AS is_partly_in_stock
FROM products p
         LEFT JOIN stock_current s
                   ON p.id = s.product_id
WHERE p.min_stock_amount != 0
GROUP BY p.id
HAVING IFNULL(SUM(s.amount), 0) - IFNULL(SUM(s.amount_opened), 0) < p.min_stock_amount;
-- END 0086.sql

-- BEGIN 0087.sql
ALTER TABLE recipes_pos
    ADD price_factor REAL NOT NULL DEFAULT 1;

DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount_aggregated, 0)                                                                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) >= CASE
                                                       WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                       ELSE rp.amount *
                                                            (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                            (rnr.includes_servings * 1.0 / CASE
                                                                                               WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                   THEN rnrr.base_servings * 1.0
                                                                                               ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) - CASE
                                                      WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                      ELSE rp.amount *
                                                           (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                           (rnr.includes_servings * 1.0 / CASE
                                                                                              WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                  THEN rnrr.base_servings * 1.0
                                                                                              ELSE 1 END) END < 0
               THEN ABS(IFNULL(sc.amount_aggregated, 0) - (CASE
                                                               WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                               ELSE rp.amount *
                                                                    (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                    (rnr.includes_servings * 1.0 / CASE
                                                                                                       WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                           THEN rnrr.base_servings * 1.0
                                                                                                       ELSE 1 END) END))
           ELSE 0 END                                                                                                  AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) +
                (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                 p.qu_factor_purchase_to_stock) >= CASE
                                                       WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                       ELSE rp.amount *
                                                            (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                            (rnr.includes_servings * 1.0 / CASE
                                                                                               WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                   THEN rnrr.base_servings * 1.0
                                                                                               ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) * pcp.last_price *
       rp.price_factor                                                                                                 AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount_aggregated, 0)                                                                                 AS stock_amount,
       1                                                                                                               AS need_fulfilled,
       0                                                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       1                                                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) * pcp.last_price *
       rp.price_factor                                                                                                 AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;
-- END 0087.sql

-- BEGIN 0088.sql
ALTER TABLE products
    ADD calories INTEGER;

DROP VIEW recipes_pos_resolved;
CREATE VIEW recipes_pos_resolved
AS

-- Multiplication by 1.0 to force conversion to float (REAL)

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount_aggregated, 0)                                                                                 AS stock_amount,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) >= CASE
                                                       WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                       ELSE rp.amount *
                                                            (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                            (rnr.includes_servings * 1.0 / CASE
                                                                                               WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                   THEN rnrr.base_servings * 1.0
                                                                                               ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) - CASE
                                                      WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                      ELSE rp.amount *
                                                           (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                           (rnr.includes_servings * 1.0 / CASE
                                                                                              WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                  THEN rnrr.base_servings * 1.0
                                                                                              ELSE 1 END) END < 0
               THEN ABS(IFNULL(sc.amount_aggregated, 0) - (CASE
                                                               WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                               ELSE rp.amount *
                                                                    (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                                    (rnr.includes_servings * 1.0 / CASE
                                                                                                       WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                           THEN rnrr.base_servings * 1.0
                                                                                                       ELSE 1 END) END))
           ELSE 0 END                                                                                                  AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       CASE
           WHEN IFNULL(sc.amount_aggregated, 0) +
                (CASE WHEN r.not_check_shoppinglist = 1 THEN 0 ELSE IFNULL(sl.amount, 0) END *
                 p.qu_factor_purchase_to_stock) >= CASE
                                                       WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
                                                       ELSE rp.amount *
                                                            (r.desired_servings * 1.0 / r.base_servings * 1.0) *
                                                            (rnr.includes_servings * 1.0 / CASE
                                                                                               WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                   THEN rnrr.base_servings * 1.0
                                                                                               ELSE 1 END) END THEN 1
           ELSE 0 END                                                                                                  AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) * pcp.last_price *
       rp.price_factor                                                                                                 AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) *
       IFNULL(p.calories, 0)                                                                                           AS calories
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 0

UNION

-- Just add all recipe positions which should not be checked against stock with fulfilled need

SELECT r.id                                                                                                            AS recipe_id,
       rp.id                                                                                                           AS recipe_pos_id,
       rp.product_id                                                                                                   AS product_id,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) AS recipe_amount,
       IFNULL(sc.amount_aggregated, 0)                                                                                 AS stock_amount,
       1                                                                                                               AS need_fulfilled,
       0                                                                                                               AS missing_amount,
       IFNULL(sl.amount, 0) * p.qu_factor_purchase_to_stock                                                            AS amount_on_shopping_list,
       1                                                                                                               AS need_fulfilled_with_shopping_list,
       rp.qu_id,
       (CASE
            WHEN rp.only_check_single_unit_in_stock = 1 THEN 1
            ELSE rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                                     WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                                         THEN rnrr.base_servings * 1.0
                                                                                                                     ELSE 1 END) END /
        p.qu_factor_purchase_to_stock) * pcp.last_price *
       rp.price_factor                                                                                                 AS costs,
       CASE WHEN rnr.recipe_id = rnr.includes_recipe_id THEN 0 ELSE 1 END                                              AS is_nested_recipe_pos,
       rp.ingredient_group,
       rp.id, -- Just a dummy id column
       rnr.includes_recipe_id                                                                                          as child_recipe_id,
       rp.note,
       rp.variable_amount                                                                                              AS recipe_variable_amount,
       rp.only_check_single_unit_in_stock,
       rp.amount * (r.desired_servings * 1.0 / r.base_servings * 1.0) * (rnr.includes_servings * 1.0 / CASE
                                                                                                           WHEN rnr.recipe_id != rnr.includes_recipe_id
                                                                                                               THEN rnrr.base_servings * 1.0
                                                                                                           ELSE 1 END) *
       IFNULL(p.calories, 0)                                                                                           AS calories
FROM recipes r
         JOIN recipes_nestings_resolved rnr
              ON r.id = rnr.recipe_id
         JOIN recipes rnrr
              ON rnr.includes_recipe_id = rnrr.id
         JOIN recipes_pos rp
              ON rnr.includes_recipe_id = rp.recipe_id
         JOIN products p
              ON rp.product_id = p.id
         LEFT JOIN (
    SELECT product_id, SUM(amount) AS amount
    FROM shopping_list
    GROUP BY product_id) sl
                   ON rp.product_id = sl.product_id
         LEFT JOIN stock_current sc
                   ON rp.product_id = sc.product_id
         LEFT JOIN products_current_price pcp
                   ON rp.product_id = pcp.product_id
WHERE rp.not_check_stock_fulfillment = 1;

DROP VIEW recipes_resolved;
CREATE VIEW recipes_resolved
AS
SELECT r.id                                                  AS recipe_id,
       IFNULL(MIN(rpr.need_fulfilled), 1)                    AS need_fulfilled,
       IFNULL(MIN(rpr.need_fulfilled_with_shopping_list), 1) AS need_fulfilled_with_shopping_list,
       (SELECT COUNT(*)
        FROM recipes_pos_resolved
        WHERE recipe_id = r.id
          AND need_fulfilled = 0)                            AS missing_products_count,
       IFNULL(SUM(rpr.costs), 0)                             AS costs,
       IFNULL(SUM(rpr.calories), 0)                          AS calories
FROM recipes r
         LEFT JOIN recipes_pos_resolved rpr
                   ON r.id = rpr.recipe_id
GROUP BY r.id;
-- END 0088.sql

-- BEGIN 0089.sql
CREATE TRIGGER remove_recipe_from_meal_plans
    AFTER DELETE
    ON recipes
BEGIN
    DELETE
    FROM meal_plan
    WHERE recipe_id = OLD.id;
END;

-- Delete all recipes from the meal plan which doesn't exist anymore
DELETE
FROM meal_plan
WHERE recipe_id NOT IN (SELECT id FROM recipes);
-- END 0089.sql

-- BEGIN 0090.sql
DROP VIEW stock_average_product_shelf_life;
CREATE VIEW stock_average_product_shelf_life
AS
SELECT p.id,
       CASE WHEN x.product_id IS NULL THEN -1 ELSE AVG(x.shelf_life_days) END AS average_shelf_life_days
FROM products p
         LEFT JOIN (
    SELECT sl_p.product_id,
           JULIANDAY(sl_p.best_before_date) - JULIANDAY(sl_p.purchased_date) AS shelf_life_days
    FROM stock_log sl_p
    WHERE sl_p.transaction_type = 'purchase'
      AND sl_p.undone = 0
) x
                   ON p.id = x.product_id
GROUP BY p.id;
-- END 0090.sql

-- BEGIN 0091.sql
DROP VIEW recipes_nestings_resolved;
CREATE VIEW recipes_nestings_resolved
AS
WITH RECURSIVE r1(recipe_id, includes_recipe_id, includes_servings)
                   AS (
        SELECT id, id, 1
        FROM recipes

        UNION ALL

        SELECT rn.recipe_id, r1.includes_recipe_id, rn.servings
        FROM recipes_nestings rn,
             r1 r1
        WHERE rn.includes_recipe_id = r1.recipe_id
        LIMIT 100 -- This is just a safety limit to prevent infinite loops due to infinite nested recipes
    )
SELECT *,
       1 AS id -- Dummy, LessQL needs an id column
FROM r1;
-- END 0091.sql

-- BEGIN 0092.sql
ALTER TABLE products
    ADD cumulate_min_stock_amount_of_sub_products TINYINT DEFAULT 0;

CREATE VIEW products_view
AS
SELECT *,
       CASE WHEN (SELECT 1 FROM products WHERE parent_product_id = p.id) NOTNULL THEN 1 ELSE 0 END AS has_sub_products
FROM products p;

DROP VIEW stock_missing_products;
CREATE VIEW stock_missing_products
AS

-- Products WITHOUT sub products where the amount of the sub products SHOULD NOT be cumulated
SELECT p.id,
       MAX(p.name)                                              AS name,
       p.min_stock_amount - IFNULL(SUM(s.amount), 0)            AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END AS is_partly_in_stock
FROM products_view p
         LEFT JOIN stock_current s
                   ON p.id = s.product_id
WHERE p.min_stock_amount != 0
  AND p.cumulate_min_stock_amount_of_sub_products = 0
  AND p.has_sub_products = 0
  AND p.parent_product_id IS NULL
GROUP BY p.id
HAVING IFNULL(SUM(s.amount), 0) < p.min_stock_amount

UNION

-- Parent products WITH sub products where the amount of the sub products SHOULD be cumulated
SELECT p.id,
       MAX(p.name)                                                       AS name,
       SUM(sub_p.min_stock_amount) - IFNULL(SUM(s.amount_aggregated), 0) AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END          AS is_partly_in_stock
FROM products_view p
         JOIN products_resolved pr
              ON p.id = pr.parent_product_id
         JOIN products sub_p
              ON pr.sub_product_id = sub_p.id
         LEFT JOIN stock_current s
                   ON pr.sub_product_id = s.product_id
WHERE sub_p.min_stock_amount != 0
  AND p.cumulate_min_stock_amount_of_sub_products = 1
GROUP BY p.id
HAVING IFNULL(SUM(s.amount_aggregated), 0) < SUM(sub_p.min_stock_amount)

UNION

-- Sub products where the amount SHOULD NOT be cumulated into the parent product
SELECT sub_p.id,
       MAX(sub_p.name)                                          AS name,
       SUM(sub_p.min_stock_amount) - IFNULL(SUM(s.amount), 0)   AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END AS is_partly_in_stock
FROM products p
         JOIN products_resolved pr
              ON p.id = pr.parent_product_id
         JOIN products sub_p
              ON pr.sub_product_id = sub_p.id
         LEFT JOIN stock_current s
                   ON pr.sub_product_id = s.product_id
WHERE sub_p.min_stock_amount != 0
  AND p.cumulate_min_stock_amount_of_sub_products = 0
GROUP BY sub_p.id
HAVING IFNULL(SUM(s.amount), 0) < sub_p.min_stock_amount;

DROP VIEW stock_missing_products_including_opened;
CREATE VIEW stock_missing_products_including_opened
AS
    /* This is basically the same view as stock_missing_products, but the column "amount_missing" includes opened amounts */

-- Products WITHOUT sub products where the amount of the sub products SHOULD NOT be cumulated
SELECT p.id,
       MAX(p.name)                                                                       AS name,
       p.min_stock_amount - (IFNULL(SUM(s.amount), 0) - IFNULL(SUM(s.amount_opened), 0)) AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END                          AS is_partly_in_stock
FROM products_view p
         LEFT JOIN stock_current s
                   ON p.id = s.product_id
WHERE p.min_stock_amount != 0
  AND p.cumulate_min_stock_amount_of_sub_products = 0
  AND p.has_sub_products = 0
  AND p.parent_product_id IS NULL
GROUP BY p.id
HAVING IFNULL(SUM(s.amount), 0) < p.min_stock_amount

UNION

-- Parent products WITH sub products where the amount of the sub products SHOULD be cumulated
SELECT p.id,
       MAX(p.name)                                                     AS name,
       SUM(sub_p.min_stock_amount) - (IFNULL(SUM(s.amount_aggregated), 0) -
                                      IFNULL(SUM(s.amount_opened), 0)) AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END        AS is_partly_in_stock
FROM products_view p
         JOIN products_resolved pr
              ON p.id = pr.parent_product_id
         JOIN products sub_p
              ON pr.sub_product_id = sub_p.id
         LEFT JOIN stock_current s
                   ON pr.sub_product_id = s.product_id
WHERE sub_p.min_stock_amount != 0
  AND p.cumulate_min_stock_amount_of_sub_products = 1
GROUP BY p.id
HAVING IFNULL(SUM(s.amount_aggregated), 0) < SUM(sub_p.min_stock_amount)

UNION

-- Sub products where the amount SHOULD NOT be cumulated into the parent product
SELECT sub_p.id,
       MAX(sub_p.name)                                                                            AS name,
       SUM(sub_p.min_stock_amount) - (IFNULL(SUM(s.amount), 0) - IFNULL(SUM(s.amount_opened), 0)) AS amount_missing,
       CASE WHEN IFNULL(SUM(s.amount), 0) > 0 THEN 1 ELSE 0 END                                   AS is_partly_in_stock
FROM products p
         JOIN products_resolved pr
              ON p.id = pr.parent_product_id
         JOIN products sub_p
              ON pr.sub_product_id = sub_p.id
         LEFT JOIN stock_current s
                   ON pr.sub_product_id = s.product_id
WHERE sub_p.min_stock_amount != 0
  AND p.cumulate_min_stock_amount_of_sub_products = 0
GROUP BY sub_p.id
HAVING IFNULL(SUM(s.amount), 0) < sub_p.min_stock_amount;
-- END 0092.sql

-- BEGIN 0093.sql
DROP VIEW recipes_nestings_resolved;
CREATE VIEW recipes_nestings_resolved
AS
WITH RECURSIVE r1(recipe_id, includes_recipe_id, includes_servings)
                   AS (
        SELECT id, id, 1
        FROM recipes

        UNION ALL

        SELECT rn.recipe_id, r1.includes_recipe_id, rn.servings
        FROM recipes_nestings rn,
             r1 r1
        WHERE rn.includes_recipe_id = r1.recipe_id
    )
SELECT *,
       1 AS id -- Dummy, LessQL needs an id column
FROM r1;

CREATE TRIGGER prevent_self_nested_recipes_INS
    BEFORE INSERT
    ON recipes_nestings
BEGIN
    SELECT CASE
               WHEN ((
                   SELECT 1
                   FROM recipes_nestings
                   WHERE NEW.recipe_id = NEW.includes_recipe_id
               )
                   NOTNULL) THEN RAISE(ABORT, "Recursive nested recipe detected") END;
END;

CREATE TRIGGER prevent_self_nested_recipes_UPD
    BEFORE UPDATE
    ON recipes_nestings
BEGIN
    SELECT CASE
               WHEN ((
                   SELECT 1
                   FROM recipes_nestings
                   WHERE NEW.recipe_id = NEW.includes_recipe_id
               )
                   NOTNULL) THEN RAISE(ABORT, "Recursive nested recipe detected") END;
END;

DELETE
FROM recipes_nestings
WHERE recipe_id = includes_recipe_id;
-- END 0093.sql

-- BEGIN 0094.sql
ALTER TABLE chores
    ADD period_interval INTEGER NOT NULL DEFAULT 1 CHECK (period_interval > 0);

DROP VIEW chores_current;
CREATE VIEW chores_current
AS
SELECT x.chore_id,
       x.last_tracked_time,
       CASE
           WHEN x.rollover = 1 AND DATETIME('now', 'localtime') > x.next_estimated_execution_time THEN
               DATETIME(STRFTIME('%Y-%m-%d', DATETIME('now', 'localtime')) || ' ' ||
                        STRFTIME('%H:%M:%S', x.next_estimated_execution_time))
           ELSE
               x.next_estimated_execution_time
           END AS next_estimated_execution_time,
       x.track_date_only,
       x.next_execution_assigned_to_user_id
FROM (
         SELECT h.id                AS chore_id,
                MAX(l.tracked_time) AS last_tracked_time,
                CASE h.period_type
                    WHEN 'manually' THEN '2999-12-31 23:59:59'
                    WHEN 'dynamic-regular' THEN DATETIME(MAX(l.tracked_time),
                                                         '+' || CAST(h.period_days AS TEXT) || ' day')
                    WHEN 'daily' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')),
                                               '+' || CAST(h.period_interval AS TEXT) || ' day')
                    WHEN 'weekly' THEN
                        CASE
                            WHEN period_config LIKE '%sunday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 0')
                            WHEN period_config LIKE '%monday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 1')
                            WHEN period_config LIKE '%tuesday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 2')
                            WHEN period_config LIKE '%wednesday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 3')
                            WHEN period_config LIKE '%thursday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 4')
                            WHEN period_config LIKE '%friday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 5')
                            WHEN period_config LIKE '%saturday%' THEN DATETIME(
                                    IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')), '1 days',
                                    '+' || CAST((h.period_interval - 1) * 7 AS TEXT) || ' days', 'weekday 6')
                            END
                    WHEN 'monthly' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')),
                                                 '+' || CAST(h.period_interval AS TEXT) || ' month', 'start of month',
                                                 '+' || CAST(h.period_days - 1 AS TEXT) || ' day')
                    WHEN 'yearly' THEN DATETIME(IFNULL(MAX(l.tracked_time), DATETIME('now', 'localtime')),
                                                '+' || CAST(h.period_interval AS TEXT) || ' years')
                    END             AS next_estimated_execution_time,
                h.track_date_only,
                h.rollover,
                h.next_execution_assigned_to_user_id
         FROM chores h
                  LEFT JOIN chores_log l
                            ON h.id = l.chore_id
                                AND l.undone = 0
         GROUP BY h.id, h.period_days
     ) x;
-- END 0094.sql

-- BEGIN 0095.sql
CREATE TRIGGER set_products_default_location_if_empty_stock
    AFTER INSERT
    ON stock
BEGIN
    UPDATE stock
    SET location_id = (SELECT location_id FROM products where id = product_id)
    WHERE id = NEW.id
      AND location_id IS NULL;
END;

CREATE TRIGGER set_products_default_location_if_empty_stock_log
    AFTER INSERT
    ON stock_log
BEGIN
    UPDATE stock_log
    SET location_id = (SELECT location_id FROM products where id = product_id)
    WHERE id = NEW.id
      AND location_id IS NULL;
END;

ALTER TABLE stock_log
    ADD correlation_id TEXT;

ALTER TABLE stock_log
    ADD transaction_id TEXT;

ALTER TABLE stock_log
    ADD stock_row_id INTEGER;

DROP VIEW stock_current_locations;
CREATE VIEW stock_current_locations
AS
SELECT 1             AS id, -- Dummy, LessQL needs an id column
       s.product_id,
       s.location_id AS location_id,
       l.name        AS location_name
FROM stock s
         JOIN locations l
              ON s.location_id = l.id
GROUP BY s.product_id, s.location_id, l.name;
-- END 0095.sql