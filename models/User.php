<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\OneToMany;
use Doctrine\ORM\Mapping\Table;

/**
 * Class User
 * @package Grocy\Models
 * @Entity
 * @Table(name="users")
 */
class User extends BaseEntity
{
    /**
     * @Column(type="text", nullable=false, unique=true)
     * @var string
     */
    protected string $username;
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $first_name;
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $last_name;
    /**
     * @Column(type="text", nullable=false)
     * @var string
     */
    protected string $password;
    /**
     * @OneToMany(targetEntity="Session", mappedBy="user")
     * @var Session[]
     */
    protected array $sessions;
}