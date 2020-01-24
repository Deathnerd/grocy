<?php


namespace Grocy\Models\SuperClasses;

use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\MappedSuperclass;

/**
 * Class NameDescriptionEntity
 * @package Grocy\Models
 * @MappedSuperclass
 */
abstract class NameDescriptionEntity extends BaseEntity
{
    /**
     * @Column(type="text", unique=true, nullable=false)
     * @var string
     */
    protected string $name;
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $description;
}