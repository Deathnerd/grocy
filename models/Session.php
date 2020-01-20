<?php


namespace Grocy\Models;


use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\ManyToOne;
use Doctrine\ORM\Mapping\Table;

/**
 * Class Session
 * @package Grocy\Models
 * @Entity
 * @Table(name="sessions")
 */
class Session
{
//CREATE TABLE users (
//	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    /**
     * @Id
     * @Column(type="integer", nullable=false, unique=true)
     * @GeneratedValue
     * @var int
     */
    protected int $id;
//	session_key TEXT NOT NULL UNIQUE,
    /**
     * @Column(type="text", nullable=false)
     * @var string
     */
    protected string $session_key;
//	user_id INTEGER NOT NULL,
    /**
     * @ManyToOne(targetEntity="User", inversedBy="sessions")
     * @var User
     */
    protected User $user;
//	expires DATETIME,
    /**
     * @Column(type="datetime")
     * @var DateTime
     */
    protected DateTime $expires;
//	last_used DATETIME,
    /**
     * @Column(type="datetime")
     * @var DateTime
     */
    protected DateTime $last_used;
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