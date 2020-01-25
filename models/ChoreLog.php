<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\BaseEntity;

/**
 * Class ChoreLog
 * @package Grocy\Models
 * @Entity
 * @Table(name="chores_log")
 */
class ChoreLog extends BaseEntity
{
    /**
     * @ManyToOne(targetEntity="Chore", inversedBy="log_entries")
     * @var Chore The chore being logged
     */
    protected Chore $chore;
    /**
     * @Column(type="datetime")
     * @var DateTime
     * TODO: Change this to total seconds elapsed?
     */
    protected DateTime $tracked_time;
    /**
     * @ManyToOne(targetEntity="User", inversedBy="chore_logs")
     * @var User The user that did the chore
     */
    protected User $done_by_user;
    /**
     * @Column(type="boolean")
     * @var bool Has the chore been undone?
     */
    protected bool $undone = false;
    /**
     * @Column(type="datetimetz")
     * @var DateTime When the chore was undone
     */
    protected DateTime $undone_timestamp;
}