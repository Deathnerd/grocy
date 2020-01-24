<?php


namespace Grocy\Models;

use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\OneToMany;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\NameDescriptionEntity;

/**
 * Class Product
 * @package Grocy\Models
 * @Entity
 * @Table(name="products")
 */
class Product extends NameDescriptionEntity
{
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $location_id;
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $qu_id_purchase;
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $qu_id_stock;
    /**
     * @Column(type="float", nullable=false)
     * @var string
     */
    protected string $qu_factor_purchase_to_stock;
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $barcode;
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $min_stock_amount = 0;
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
}