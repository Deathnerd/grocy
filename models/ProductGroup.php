<?php


namespace Grocy\Models;

use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\NameDescriptionEntity;

/**
 * Class ProductGroup
 * @package Grocy\Models
 * @Entity
 * @Table(name="product_groups")
 */
class ProductGroup extends NameDescriptionEntity
{
}
