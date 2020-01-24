<?php


namespace Grocy\Models;


use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\BaseEntity;

/**
 * Class Session
 * @package Grocy\Models
 * @Entity
 * @Table(name="sessions")
 */
class Session extends BaseEntity
{
    /**
     * @Column(type="text", nullable=false)
     * @var string
     */
    protected string $session_key;
    /**
     * @ManyToOne(targetEntity="User", inversedBy="sessions")
     * @var User
     */
    protected User $user;
    /**
     * @Column(type="datetimetz")
     * @var DateTime
     */
    protected DateTime $expires;
    /**
     * @Column(type="datetimetz")
     * @var DateTime
     */
    protected DateTime $last_used;
}