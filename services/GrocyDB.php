<?php


namespace Grocy\Services;


use LessQL\Database;
use LessQL\Result;
use LessQL\Row;

class GrocyDB extends Database
{
    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function api_keys($id=null) {
        return $this->table('api_keys', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function batteries($id=null) {
        return $this->table('batteries', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function battery_charge_cycles($id=null) {
        return $this->table('battery_charge_cycles', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function chores($id=null) {
        return $this->table('chores', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function chores_current($id=null) {
        return $this->table('chores', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function chores_execution_users_statistics($id=null) {
        return $this->table('chores', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function chores_log($id=null) {
        return $this->table('chores_log', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function equipment($id=null) {
        return $this->table('equipment', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|string|null
     */
    public function lastInsertId($id=null) {
        return $this->table('lastInsertId', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function locations($id=null) {
        return $this->table('locations', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function meal_plan($id=null) {
        return $this->table('meal_plan', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function product_groups($id=null) {
        return $this->table('product_groups', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function products($id=null) {
        return $this->table('products', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function quantity_unit_conversions($id=null) {
        return $this->table('quantity_unit_conversions', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function quantity_unit_conversions_resolved($id=null) {
        return $this->table('quantity_unit_conversions_resolved', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function quantity_units($id=null) {
        return $this->table('quantity_units', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function recipes($id=null) {
        return $this->table('recipes', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function recipes_nestings($id=null) {
        return $this->table('recipes_nestings', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function recipes_pos($id=null) {
        return $this->table('recipes_pos', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function recipes_pos_resolved($id=null) {
        return $this->table('recipes_pos_resolved', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function sessions($id=null) {
        return $this->table('shopping_list', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function shopping_list($id=null) {
        return $this->table('shopping_list', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function shopping_lists($id=null) {
        return $this->table('shopping_lists', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function stock($id=null) {
        return $this->table('stock', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function stock_log($id=null) {
        return $this->table('stock_log', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function task_categories($id=null) {
        return $this->table('task_categories', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function tasks($id=null) {
        return $this->table('tasks', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function userentities($id=null) {
        return $this->table('userentities', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function userfield_values($id=null) {
        return $this->table('users', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function userfield_values_resolved($id=null) {
        return $this->table('users', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function userfields($id=null) {
        return $this->table('users', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function userobjects($id=null) {
        return $this->table('userobjects', $id);
    }

    /**
     * @param int|null $id
     * @return Result|Row|null
     */
    public function users($id=null) {
        return $this->table('users', $id);
    }

    public function __construct($pdo)
    {
        parent::__construct($pdo);
    }
}