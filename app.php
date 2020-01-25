<?php /** @noinspection PhpUnusedParameterInspection */

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

use \Grocy\Helpers\UrlManager;
use \Grocy\Controllers\LoginController;
use Slim\App;
use Slim\Container;
use Slim\Views\Blade;

require_once 'vendor\autoload.php';

// Definitions for embedded mode
if (file_exists(__DIR__ . '/embedded.txt'))
{
	putenv("GROCY_IS_EMBEDDED_INSTALL=true");
	putenv(sprintf("GROCY_DATAPATH=%s", file_get_contents(__DIR__ . '/embedded.txt')));
	putenv("GROCY_USER_ID=1");
}
else
{
	putenv("GROCY_IS_EMBEDDED_INSTALL=false");
	putenv(sprintf("GROCY_DATAPATH=%s/data", __DIR__));
}

// Load composer dependencies
require_once __DIR__ . '/vendor/autoload.php';

// Load config files
require_once __DIR__ . '/data/config.php';
require_once __DIR__ . '/config-dist.php'; // For not in own config defined values we use the default ones

// Definitions for dev/demo/prerelease mode
if (getenv("GROCY_MODE") === 'dev' || getenv("GROCY_MODE") === 'demo' || getenv("GROCY_MODE") === 'prerelease')
{
    putenv("GROCY_USER_ID=1");
}

// Definitions for disabled authentication mode
if (getenv("GROCY_DISABLE_AUTH") === true)
{
	if (!getenv('GROCY_USER_ID'))
	{
        putenv("GROCY_USER_ID=1");
	}
}

// Setup base application
$appContainer = new Container([
	'settings' => [
		'displayErrorDetails' => true,
		'determineRouteBeforeAppMiddleware' => true
	],
	'view' => function($container)
	{
		return new Blade(__DIR__ . '/views', getenv("GROCY_DATAPATH") . '/viewcache');
	},
	'LoginControllerInstance' => function($container)
	{
		return new LoginController($container, 'grocy_session');
	},
	'UrlManager' => function($container)
	{
		return new UrlManager(getenv("GROCY_BASE_URL"));
	},
	'ApiKeyHeaderName' => function($container)
	{
		return 'GROCY-API-KEY';
	}
]);
$app = new App($appContainer);

// Load routes from separate file
require_once __DIR__ . '/routes.php';

/** @noinspection PhpUnhandledExceptionInspection */
$app->run();
