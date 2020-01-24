-- Table DDL extracted from old sql file migrations

CREATE TABLE api_keys -- Mapped
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    api_key               TEXT    NOT NULL UNIQUE,
    user_id               INTEGER NOT NULL,
    expires               DATETIME,
    last_used             DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE batteries -- Mapped
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    used_in               TEXT,
    charge_interval_days  INTEGER NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME         DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE battery_charge_cycles
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    battery_id            TEXT    NOT NULL,
    tracked_time          DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE chores_log
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    chore_id              INTEGER NOT NULL,
    tracked_time          DATETIME,
    done_by_user_id       INTEGER,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE equipment
(
    id                           INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                         TEXT    NOT NULL UNIQUE,
    description                  TEXT,
    instruction_manual_file_name TEXT,
    row_created_timestamp        DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE habits
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    period_type           TEXT    NOT NULL,
    period_days           INTEGER,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE habits_log
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    habit_id              INTEGER NOT NULL,
    tracked_time          DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE locations
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE meal_plan
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    day                   DATE    NOT NULL,
    recipe_id             INTEGER NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),
    UNIQUE (day, recipe_id)
);
CREATE TABLE product_groups
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
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
CREATE TABLE quantity_unit_conversions
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    from_qu_id            INT     NOT NULL,
    to_qu_id              INT     NOT NULL,
    factor                REAL    NOT NULL,
    product_id            INT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE quantity_units
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE recipes
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE recipes_nestings
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    recipe_id             INTEGER NOT NULL,
    includes_recipe_id    INTEGER NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),
    UNIQUE (recipe_id, includes_recipe_id)
);
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
CREATE TABLE sessions
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    session_key           TEXT    NOT NULL UNIQUE,
    user_id               INTEGER NOT NULL,
    expires               DATETIME,
    last_used             DATETIME,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE shopping_list
(
    id                    INTEGER        NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    product_id            INTEGER,
    note                  TEXT,
    amount                DECIMAL(15, 2) NOT NULL DEFAULT 0,
    row_created_timestamp DATETIME                DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE shopping_lists
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
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
CREATE TABLE task_categories
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name                  TEXT    NOT NULL UNIQUE,
    description           TEXT,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
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
CREATE TABLE userfield_values
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    field_id              INTEGER NOT NULL,
    object_id             INTEGER NOT NULL,
    value                 TEXT    NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime')),
    UNIQUE (field_id, object_id)
);
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
CREATE TABLE userobjects
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    userentity_id         INTEGER NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);
CREATE TABLE users
(
    id                    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    username              TEXT    NOT NULL UNIQUE,
    first_name            TEXT,
    last_name             TEXT,
    password              TEXT    NOT NULL,
    row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
);