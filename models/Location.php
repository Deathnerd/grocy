<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\Table;

/**
 * Class Location
 * @package Grocy\Models
 * @Entity
 * @Table(name="locations")
 */
class Location
{
//CREATE TABLE locations (
//	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    /**
     * @Id
     * @Column(type="integer", nullable=false, unique=true)
     * @GeneratedValue
     * @var int
     */
    protected int $id;
//	name TEXT NOT NULL UNIQUE,
    /**
     * @Column(type="string", unique=true, nullable=false)
     * @var string
     */
    protected string $name;
//	description TEXT,
    /**
     * @Column(type="string")
     * @var string
     */
    protected string $description;
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