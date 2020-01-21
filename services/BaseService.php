<?php

namespace Grocy\Services;

use \Grocy\Services\DatabaseService;
use \Grocy\Services\LocalizationService;
use LessQL\Database;

class BaseService
{
	public function __construct() {
		$this->DatabaseService = new DatabaseService();
		$this->Database = $this->DatabaseService->GetDbConnection();

		$localizationService = new LocalizationService(getenv("GROCY_CULTURE"));
		$this->LocalizationService = $localizationService;
	}

    /**
     * TODO: Remove or migrate this to Doctrine
     * @var \Grocy\Services\DatabaseService
     */
	protected DatabaseService $DatabaseService;
    /**
     * TODO: Remove or migrate this to Doctrine
     * @var GrocyDB The database access layer
     */
	protected GrocyDB $Database;
    /**
     * @var \Grocy\Services\LocalizationService The localization service
     */
	protected LocalizationService $LocalizationService;
}
