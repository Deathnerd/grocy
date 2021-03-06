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
class User
{
//CREATE TABLE users (
//	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    /**
     * @Id
     * @Column(type="integer")
     * @GeneratedValue
     * @var int
     */
    protected int $id;
//	username TEXT NOT NULL UNIQUE,
    /**
     * @Column(type="string", nullable=false, unique=true)
     * @var string
     */
    protected string $username;
//	first_name TEXT,
    /**
     * @Column(type="string")
     * @var string
     */
    protected string $first_name;
//	last_name TEXT,
    /**
     * @Column(type="string")
     * @var string
     */
    protected string $last_name;
//	password TEXT NOT NULL,
    /**
     * @Column(type="string", nullable=false)
     * @var string
     */
    protected string $password;

    /**
     * @OneToMany(targetEntity="Session", mappedBy="user")
     * @var Session[]
     */
    protected array $sessions;
//	row_created_timestamp DATETIME DEFAULT (datetime('now', 'localtime'))
    /**
     * @Column(type="datetime")
     * @var DateTime
     */
    protected DateTime $row_created_timestamp;
//)
    public function __construct()
    {
        $this->row_created_timestamp = new DateTime();
    }
}