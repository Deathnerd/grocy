<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\OneToMany;
use Doctrine\ORM\Mapping\Table;

/**
 * Class Product
 * @package Grocy\Models
 * @Entity
 * @Table(name="products")
 */
class Product
{
//CREATE TABLE products (
//	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    /**
     * @Id
     * @Column(type="integer", nullable=false, unique=true)
     * @GeneratedValue
     * @var int
     */
    protected int $id;
//	name TEXT NOT NULL UNIQUE,
    /**
     * @Column(type="text", unique=true, nullable=false)
     * @var string
     */
    protected string $name;
//	description TEXT,
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $description;
//	location_id INTEGER NOT NULL,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $location_id;
//	qu_id_purchase INTEGER NOT NULL,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $qu_id_purchase;
//	qu_id_stock INTEGER NOT NULL,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $qu_id_stock;
//	qu_factor_purchase_to_stock REAL NOT NULL,
    /**
     * @Column(type="float", nullable=false)
     * @var string
     */
    protected string $qu_factor_purchase_to_stock;
//	barcode TEXT,
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $barcode;
//	min_stock_amount INTEGER NOT NULL DEFAULT 0,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $min_stock_amount = 0;
//	default_best_before_days INTEGER NOT NULL DEFAULT 0,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $default_best_before_days = 0;
    /**
     * @OneToMany(targetEntity="ShoppingList", mappedBy="product")
     * @var ShoppingList[]
     */
    protected array $shopping_lists;
//	row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
    /**
     * @Column(type="datetimetz")
     * @var DateTime
     */
    protected DateTime $row_created_timestamp;
//)

    public function __construct()
    {
        $this->row_created_timestamp = new DateTime();
    }
}