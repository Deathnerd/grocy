<?php


namespace Grocy\Models;

use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\NameDescriptionEntity;

/**
 * Class Equipment
 * @package Grocy\Models
 * @Entity
 * @Table(name="equipment")
 */
class Equipment extends NameDescriptionEntity
{
    /**
     * @Column(type="text")
     * @var string
     */
    public string $instruction_manual_file_name;
}