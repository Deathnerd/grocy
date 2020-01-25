create table api_keys
(
    id INTEGER not null
        primary key autoincrement
        unique,
    api_key TEXT not null
        unique,
    user_id INTEGER not null,
    expires DATETIME,
    last_used DATETIME,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    key_type TEXT default 'default' not null
);

create table batteries
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    used_in TEXT,
    charge_interval_days INTEGER default 0 not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table battery_charge_cycles
(
    id INTEGER not null
        primary key autoincrement
        unique,
    battery_id TEXT not null,
    tracked_time DATETIME,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    undone TINYINT default 0 not null,
    undone_timestamp DATETIME,
    check (undone IN (0, 1))
);

create table chores
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    period_type TEXT not null,
    period_days INTEGER,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    period_config TEXT,
    track_date_only TINYINT default 0,
    rollover TINYINT default 0,
    assignment_type TEXT,
    assignment_config TEXT,
    next_execution_assigned_to_user_id INT,
    consume_product_on_execution TINYINT default 0 not null,
    product_id TINYINT,
    product_amount REAL,
    period_interval INTEGER default 1 not null,
    check (period_interval > 0)
);

create table chores_log
(
    id INTEGER not null
        primary key autoincrement
        unique,
    chore_id INTEGER not null,
    tracked_time DATETIME,
    done_by_user_id INTEGER,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    undone TINYINT default 0 not null,
    undone_timestamp DATETIME,
    check (undone IN (0, 1))
);

create table equipment
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    instruction_manual_file_name TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table locations
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table meal_plan
(
    id INTEGER not null
        primary key autoincrement
        unique,
    day DATE not null,
    recipe_id INTEGER not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    servings INTEGER default 1,
    unique (day, recipe_id)
);

CREATE TRIGGER create_internal_recipe AFTER INSERT ON meal_plan
BEGIN
    /* This contains practically the same logic as the trigger remove_internal_recipe */

    -- Create a recipe per day
    DELETE FROM recipes
    WHERE name = NEW.day
      AND type = 'mealplan-day';

    INSERT OR REPLACE INTO recipes
    (id, name, type)
    VALUES
    ((SELECT MIN(id) - 1 FROM recipes), NEW.day, 'mealplan-day');

    -- Create a recipe per week
    DELETE FROM recipes
    WHERE name = LTRIM(STRFTIME('%Y-%W', NEW.day), '0')
      AND type = 'mealplan-week';

    INSERT INTO recipes
    (id, name, type)
    VALUES
    ((SELECT MIN(id) - 1 FROM recipes), LTRIM(STRFTIME('%Y-%W', NEW.day), '0'), 'mealplan-week');

    -- Delete all current nestings entries for the day and week recipe
    DELETE FROM recipes_nestings
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
    SELECT (SELECT id FROM recipes WHERE name = LTRIM(STRFTIME('%Y-%W', NEW.day), '0') AND type = 'mealplan-week'), recipe_id, SUM(servings)
    FROM meal_plan
    WHERE STRFTIME('%Y-%W', day) = STRFTIME('%Y-%W', NEW.day)
    GROUP BY recipe_id;
END;

CREATE TRIGGER remove_internal_recipe AFTER DELETE ON meal_plan
BEGIN
    /* This contains practically the same logic as the trigger create_internal_recipe */

    -- Create a recipe per day
    DELETE FROM recipes
    WHERE name = OLD.day
      AND type = 'mealplan-day';

    INSERT OR REPLACE INTO recipes
    (id, name, type)
    VALUES
    ((SELECT MIN(id) - 1 FROM recipes), OLD.day, 'mealplan-day');

    -- Create a recipe per week
    DELETE FROM recipes
    WHERE name = LTRIM(STRFTIME('%Y-%W', OLD.day), '0')
      AND type = 'mealplan-week';

    INSERT INTO recipes
    (id, name, type)
    VALUES
    ((SELECT MIN(id) - 1 FROM recipes), LTRIM(STRFTIME('%Y-%W', OLD.day), '0'), 'mealplan-week');

    -- Delete all current nestings entries for the day and week recipe
    DELETE FROM recipes_nestings
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
    SELECT (SELECT id FROM recipes WHERE name = LTRIM(STRFTIME('%Y-%W', OLD.day), '0') AND type = 'mealplan-week'), recipe_id, SUM(servings)
    FROM meal_plan
    WHERE STRFTIME('%Y-%W', day) = STRFTIME('%Y-%W', OLD.day)
    GROUP BY recipe_id;
END;

create table migrations
(
    migration INTEGER not null
        primary key
        unique,
    execution_time_timestamp DATETIME default datetime('now', 'localtime')
);

create table product_groups
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table products
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    location_id INTEGER not null,
    qu_id_purchase INTEGER not null,
    qu_id_stock INTEGER not null,
    qu_factor_purchase_to_stock REAL not null,
    barcode TEXT,
    min_stock_amount INTEGER default 0 not null,
    default_best_before_days INTEGER default 0 not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    product_group_id INTEGER,
    picture_file_name TEXT,
    default_best_before_days_after_open INTEGER default 0 not null,
    allow_partial_units_in_stock TINYINT default 0 not null,
    enable_tare_weight_handling TINYINT default 0 not null,
    tare_weight REAL default 0 not null,
    not_check_stock_fulfillment_for_recipes TINYINT default 0,
    parent_product_id INT,
    calories INTEGER,
    cumulate_min_stock_amount_of_sub_products TINYINT default 0
);

CREATE TRIGGER cascade_change_qu_id_stock AFTER UPDATE ON products
BEGIN
    UPDATE recipes_pos
    SET qu_id = NEW.qu_id_stock
    WHERE product_id = NEW.id
      AND qu_id = OLD.qu_id_stock;
END;

create table quantity_unit_conversions
(
    id INTEGER not null
        primary key autoincrement
        unique,
    from_qu_id INT not null,
    to_qu_id INT not null,
    factor REAL not null,
    product_id INT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

CREATE TRIGGER quantity_unit_conversions_custom_unique_constraint_INS BEFORE INSERT ON quantity_unit_conversions
BEGIN
    -- Necessary because unique constraints don't include NULL values in SQLite, and also because the constraint should include the products default conversion factor
    SELECT CASE WHEN((
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

CREATE TRIGGER quantity_unit_conversions_custom_unique_constraint_UPD BEFORE UPDATE ON quantity_unit_conversions
BEGIN
    -- Necessary because unique constraints don't include NULL values in SQLite, and also because the constraint should include the products default conversion factor
    SELECT CASE WHEN((
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

create table quantity_units
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    name_plural TEXT,
    plural_forms TEXT
);

create table recipes
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null,
    description TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    picture_file_name TEXT,
    base_servings INTEGER default 1,
    desired_servings INTEGER default 1,
    not_check_shoppinglist TINYINT default 0 not null,
    type TEXT default 'normal'
);

create index ix_recipes
    on recipes (name, type);

CREATE TRIGGER remove_recipe_from_meal_plans AFTER DELETE ON recipes
BEGIN
    DELETE FROM meal_plan
    WHERE recipe_id = OLD.id;
END;

create table recipes_nestings
(
    id INTEGER not null
        primary key autoincrement
        unique,
    recipe_id INTEGER not null,
    includes_recipe_id INTEGER not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    servings INTEGER default 1,
    unique (recipe_id, includes_recipe_id)
);

CREATE TRIGGER prevent_self_nested_recipes_INS BEFORE INSERT ON recipes_nestings
BEGIN
    SELECT CASE WHEN((
        SELECT 1
        FROM recipes_nestings
        WHERE NEW.recipe_id = NEW.includes_recipe_id
    )
        NOTNULL) THEN RAISE(ABORT, "Recursive nested recipe detected") END;
END;

CREATE TRIGGER prevent_self_nested_recipes_UPD BEFORE UPDATE ON recipes_nestings
BEGIN
    SELECT CASE WHEN((
        SELECT 1
        FROM recipes_nestings
        WHERE NEW.recipe_id = NEW.includes_recipe_id
    )
        NOTNULL) THEN RAISE(ABORT, "Recursive nested recipe detected") END;
END;

create table recipes_pos
(
    id INTEGER not null
        primary key autoincrement
        unique,
    recipe_id INTEGER not null,
    product_id INTEGER not null,
    amount REAL default 0 not null,
    note TEXT,
    qu_id INTEGER,
    only_check_single_unit_in_stock TINYINT default 0 not null,
    ingredient_group TEXT,
    not_check_stock_fulfillment TINYINT default 0 not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    variable_amount TEXT,
    price_factor REAL default 1 not null
);

CREATE TRIGGER recipes_pos_qu_id_default AFTER INSERT ON recipes_pos
BEGIN
    UPDATE recipes_pos
    SET qu_id = (SELECT qu_id_stock FROM products where id = product_id)
    WHERE qu_id IS NULL
      AND id = NEW.id;
END;

create table sessions
(
    id INTEGER not null
        primary key autoincrement
        unique,
    session_key TEXT not null
        unique,
    user_id INTEGER not null,
    expires DATETIME,
    last_used DATETIME,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table shopping_list
(
    id INTEGER not null
        primary key autoincrement
        unique,
    product_id INTEGER,
    note TEXT,
    amount DECIMAL(15,2) default 0 not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    shopping_list_id INT default 1,
    done INT default 0
);

create table shopping_lists
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table stock
(
    id INTEGER not null
        primary key autoincrement
        unique,
    product_id INTEGER not null,
    amount DECIMAL(15,2) not null,
    best_before_date DATE,
    purchased_date DATE default datetime('now', 'localtime'),
    stock_id TEXT not null,
    price DECIMAL(15,2),
    open TINYINT default 0 not null,
    opened_date DATETIME,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    location_id INTEGER,
    check (open IN (0, 1))
);

create table stock_log
(
    id INTEGER not null
        primary key autoincrement
        unique,
    product_id INTEGER not null,
    amount DECIMAL(15,2) not null,
    best_before_date DATE,
    purchased_date DATE,
    used_date DATE,
    spoiled INTEGER default 0 not null,
    stock_id TEXT not null,
    transaction_type TEXT not null,
    price DECIMAL(15,2),
    undone TINYINT default 0 not null,
    undone_timestamp DATETIME,
    opened_date DATETIME,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    location_id INTEGER,
    recipe_id INTEGER,
    check (undone IN (0, 1))
);

create table task_categories
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table tasks
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    description TEXT,
    due_date DATETIME,
    done TINYINT default 0 not null,
    done_timestamp DATETIME,
    category_id INTEGER,
    assigned_to_user_id INTEGER,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    check (done IN (0, 1))
);

create table user_settings
(
    id INTEGER not null
        primary key autoincrement
        unique,
    user_id INTEGER not null,
    key TEXT not null,
    value TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    row_updated_timestamp DATETIME default datetime('now', 'localtime'),
    unique (user_id, key)
);

create table userentities
(
    id INTEGER not null
        primary key autoincrement
        unique,
    name TEXT not null
        unique,
    caption TEXT not null,
    description TEXT,
    show_in_sidebar_menu TINYINT default 1 not null,
    icon_css_class TEXT,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table userfield_values
(
    id INTEGER not null
        primary key autoincrement
        unique,
    field_id INTEGER not null,
    object_id INTEGER not null,
    value TEXT not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    unique (field_id, object_id)
);

create table userfields
(
    id INTEGER not null
        primary key autoincrement
        unique,
    entity TEXT not null,
    name TEXT not null,
    caption TEXT not null,
    type TEXT not null,
    show_as_column_in_tables TINYINT default 0 not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime'),
    config TEXT,
    unique (entity, name)
);

create table userobjects
(
    id INTEGER not null
        primary key autoincrement
        unique,
    userentity_id INTEGER not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

create table users
(
    id INTEGER not null
        primary key autoincrement
        unique,
    username TEXT not null
        unique,
    first_name TEXT,
    last_name TEXT,
    password TEXT not null,
    row_created_timestamp DATETIME default datetime('now', 'localtime')
);

