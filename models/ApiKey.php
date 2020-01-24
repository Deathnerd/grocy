<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\Table;

/**
 * Class ApiKey
 * @package Grocy\Models
 * @Entity
 * @Table(name="api_keys")
 */
class ApiKey extends BaseEntity
{
    /**
     * @Column(type="text", nullable=false, unique=true)
     * @var string
     */
    protected string $api_key;
    /**
     * @ManyToOne(targetEntity="User", inversedBy="api_keys")
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