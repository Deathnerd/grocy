<?php

namespace Grocy\Models;

use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\OneToMany;
use Doctrine\ORM\Mapping\PrePersist;
use Doctrine\ORM\Mapping\PreUpdate;
use Doctrine\ORM\Mapping\Table;
use Exception;
use Grocy\Models\SuperClasses\NameDescriptionEntity;

/**
 * Class Chore
 * Package Grocy\Models
 * @Entity
 * @Table(name="chores")
 */
class Chore extends NameDescriptionEntity
{
    const CHORE_PERIOD_TYPE_MANUALLY = 'manually';
    const CHORE_PERIOD_TYPE_DYNAMIC_REGULAR = 'dynamic-regular';
    const CHORE_PERIOD_TYPE_DAILY = 'daily';
    const CHORE_PERIOD_TYPE_WEEKLY = 'weekly';
    const CHORE_PERIOD_TYPE_MONTHLY = 'monthly';
    const CHORE_PERIOD_TYPE_YEARLY = 'yearly';

    const CHORE_ASSIGNMENT_TYPE_NO_ASSIGNMENT = 'no-assignment';
    const CHORE_ASSIGNMENT_TYPE_WHO_LEAST_DID_FIRST = 'who-least-did-first';
    const CHORE_ASSIGNMENT_TYPE_RANDOM = 'random';
    const CHORE_ASSIGNMENT_TYPE_IN_ALPHABETICAL_ORDER = 'in-alphabetical-order';

    /**
     * @Column(type="text", nullable=false)
     * @var string
     */
    protected string $period_type;
    /**
     * @Column(type="integer")
     * @var int
     */
    protected int $period_days;
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $period_config;
    /**
     * @Column(type="boolean")
     * @var bool
     */
    protected bool $trace_date_only = false;
    /**
     * @Column(type="boolean")
     * @var bool
     */
    protected bool $rollover = false;
    /**
     * @Column(type="text", nullable=false)
     * @var string
     */
    protected string $assignment_type;
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $assignment_config;
    /**
     * @ManyToOne(targetEntity="User", inversedBy="assigned_chores")
     * @var User
     */
    protected User $next_execution_assigned_to_user;
    /**
     * @Column(type="boolean")
     * @var bool
     */
    protected bool $consume_product_on_execution = false;

    /**
     * @ManyToOne(targetEntity="Product", inversedBy="chores_used_in")
     * @return Product
     */
    protected Product $product;

    /**
     * @Column(type="float")
     * @var float The amount of product used
     */
    protected float $product_amount;
    /**
     * @Column(type="integer")
     * @var int
     */
    protected int $period_interval = 1;
    /**
     * @OneToMany(targetEntity="ChoreLog", mappedBy="chore")
     * @var ChoreLog[]
     */
    protected array $log_entries;
    /**
     * @PrePersist
     * @PreUpdate
     * @throws Exception
     */
    public function checkPeriodType()
    {
        if (!in_array($this->period_type, self::getPeriodTypes())) {
            throw new Exception("Chore " . $this->id . " has invalid period type of " . $this->period_type);
        }
    }

    /**
     * @PrePersist
     * @PreUpdate
     * @throws Exception
     */
    public function checkAssignmentType()
    {
        if (!in_array($this->period_type, self::getAssignmentTypes())) {
            throw new Exception("Chore " . $this->id . " has invalid assignment type of " . $this->assignment_type);
        }
    }

    public static function getPeriodTypes(): array
    {
        return [
            self::CHORE_PERIOD_TYPE_MANUALLY,
            self::CHORE_PERIOD_TYPE_DYNAMIC_REGULAR,
            self::CHORE_PERIOD_TYPE_DAILY,
            self::CHORE_PERIOD_TYPE_WEEKLY,
            self::CHORE_PERIOD_TYPE_MONTHLY,
            self::CHORE_PERIOD_TYPE_YEARLY
        ];
    }

    public static function getAssignmentTypes(): array
    {
        return [
            self::CHORE_ASSIGNMENT_TYPE_NO_ASSIGNMENT,
            self::CHORE_ASSIGNMENT_TYPE_WHO_LEAST_DID_FIRST,
            self::CHORE_ASSIGNMENT_TYPE_RANDOM,
            self::CHORE_ASSIGNMENT_TYPE_IN_ALPHABETICAL_ORDER
        ];
    }
}
