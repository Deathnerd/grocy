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
class ShoppingList extends BaseEntity
{
    /**
     * @ManyToOne(targetEntity="Product", inversedBy="shoppingList")
     * @var Product
     */
    protected Product $product;
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $amount = 0;
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $amount_autoadded = 0;
}