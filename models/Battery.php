<?php

namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\Entity;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\Table;

/**
 * Class Battery
 * @package Grocy\Models
 * @Entity
 * @Table(name="batteries")
 */
class Battery
{
    //CREATE TABLE batteries (
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
     * @Column(type="text", unique=true, nullable=false)
     * @var string
     */
    protected string $name;
    //	description TEXT,
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $description;
    //	used_in TEXT,
    /**
     * @Column(type="text")
     * @var string
     */
    protected string $used_in;
    //	charge_interval_days INTEGER NOT NULL DEFAULT 0,
    /**
     * @Column(type="integer", nullable=false)
     * @var int
     */
    protected int $charge_interval_days = 0;
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