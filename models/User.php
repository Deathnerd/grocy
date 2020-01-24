<?php


namespace Grocy\Models;

use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\OneToMany;
use Doctrine\ORM\Mapping\Table;
use Grocy\Models\SuperClasses\BaseEntity;

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
    /**
     * @OneToMany(targetEntity="ApiKey", mappedBy="user")
     * @var ApiKey[]
     */
    protected array $api_keys;
    /**
     * @OneToMany(targetEntity="Chore", mappedBy="next_execution_assigned_to_user")
     * @var Chore[]
     */
    protected array $assigned_chores;
}