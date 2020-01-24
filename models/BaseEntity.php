<?php


namespace Grocy\Models;

use DateTime;
use Doctrine\ORM\Mapping\Column;
use Doctrine\ORM\Mapping\GeneratedValue;
use Doctrine\ORM\Mapping\Id;
use Doctrine\ORM\Mapping\MappedSuperclass;
use Doctrine\ORM\Mapping\PrePersist;
use Exception;

/**
 * Class BaseEntity
 * @package Grocy\Models
 * @MappedSuperclass
 */
class BaseEntity
{
    /**
     * @Id
     * @Column(type="integer", nullable=false, unique=true)
     * @GeneratedValue
     * @var int
     */
    protected int $id;
    /**
     * @Column(type="datetimetz")
     * @var DateTime
     */
    protected DateTime $row_created_timestamp;

    /**
     * @PrePersist
     * @throws Exception
     */
    public function generateTimeStamp() {
        $this->row_created_timestamp = new DateTime();
    }
}