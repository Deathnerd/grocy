<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\Table;

/**
 * Class ShoppingList
 * @package Grocy\Models
 * @Entity
 * @Table(name="shopping_list")
 * TODO: Convert to having multiple shopping lists
 */
class ShoppingList
{
//CREATE TABLE shopping_list (
//	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    /**
     * @Id
     * @Column(type="integer", nullable=false, unique=true)
     * @GeneratedValue
     * @var int
     */
    protected int $id;
//	product_id INTEGER NOT NULL UNIQUE,
    /**
     * @ManyToOne(targetEntity="Product", inversedBy="shoppingList")
     * @var Product
     */
    protected Product $product;
//	amount INTEGER NOT NULL DEFAULT 0,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $amount = 0;
//	amount_autoadded INTEGER NOT NULL DEFAULT 0,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $amount_autoadded = 0;
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