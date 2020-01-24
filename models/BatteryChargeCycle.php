<?php

namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\BaseEntity;

/**
 * Class BatteryChargeCycle
 * Package Grocy\Models
 * @Entity
 * @Table(name="battery_charge_cycles")
 */
class BatteryChargeCycle extends BaseEntity
{
    /**
     * @ManyToOne(targetEntity="Battery", inversedBy="charge_cycles");
     * @var Battery
     */
    protected $battery;
    /**
     * @Column(type="datetimetz")
     * @var DateTime
     */
     protected DateTime $tracked_time;
}
