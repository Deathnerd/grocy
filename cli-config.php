<?php
// cli-config.php
use Doctrine\ORM\Tools\Console\ConsoleRunner;

require_once "doctrine_bootstrap.php";

return ConsoleRunner::createHelperSet($entityManager);