<?php

namespace Grocy\Services;

use Exception;
use LessQL\Database;
use PDO;
use PDOStatement;

class DatabaseService
{
	private function GetDbFilePath() : string
	{
		if (getenv("GROCY_MODE") === 'demo' || getenv("GROCY_MODE") === 'prerelease')
		{
			return getenv("GROCY_DATAPATH") . '/grocy_' . getenv("GROCY_CULTURE") . '.db';
		}

		return getenv("GROCY_DATAPATH") . '/grocy.db';
	}

	private PDO $DbConnectionRaw;
	/**
	 * @return PDO
	 */
	public function GetDbConnectionRaw() : PDO
	{
		if ($this->DbConnectionRaw == null)
		{
			$pdo = new PDO('sqlite:' . $this->GetDbFilePath());
			$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			$this->DbConnectionRaw = $pdo;
		}

		return $this->DbConnectionRaw;
	}

    /**
     * @var GrocyDB
     */
	private GrocyDB $DbConnection;
	/**
	 * @return GrocyDB
	 */
	public function GetDbConnection() : GrocyDB
	{
		if ($this->DbConnection == null)
		{
			$this->DbConnection = new GrocyDB($this->GetDbConnectionRaw());
		}

		return $this->DbConnection;
	}

    /**
     * @param string $sql
     * @return boolean
     * @throws Exception When executing the query failed
     */
	public function ExecuteDbStatement(string $sql) : bool
	{
		$pdo = $this->GetDbConnectionRaw();
		if ($pdo->exec($sql) === false)
		{
			throw new Exception($pdo->errorInfo());
		}

		return true;
	}

    /**
     * @param string $sql
     * @return boolean|PDOStatement
     * @throws Exception When executing the query failed
     */
	public function ExecuteDbQuery(string $sql)
	{
		$pdo = $this->GetDbConnectionRaw();
		if ($this->ExecuteDbStatement($sql) === true)
		{
			return $pdo->query($sql);
		}

		return false;
	}

	public function GetDbChangedTime() : string
	{
		return date('Y-m-d H:i:s', filemtime($this->GetDbFilePath()));
	}

	public function SetDbChangedTime(string $dateTime) : bool
	{
		return touch($this->GetDbFilePath(), strtotime($dateTime));
	}
}
