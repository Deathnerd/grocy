<?php


namespace Grocy\Models;

use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\NameDescriptionEntity;

/**
 * Class Location
 * @package Grocy\Models
 * @Entity
 * @Table(name="quantity_units")
 */
class QuantityUnit extends NameDescriptionEntity
{
}