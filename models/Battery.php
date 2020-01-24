<?php

namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\Table;

/**
 * Class Battery
 * @package Grocy\Models
 * @Entity
 * @Table(name="batteries")
 */
class Battery extends NameDescriptionEntity
{
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $used_in;
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $charge_interval_days = 0;
}