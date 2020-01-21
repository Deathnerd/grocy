<?php

namespace Grocy\Middleware;

use \Grocy\Services\SessionService;
use \Grocy\Services\LocalizationService;

class SessionAuthMiddleware extends BaseMiddleware
{
	public function __construct(\Slim\Container $container, string $sessionCookieName)
	{
		parent::__construct($container);
		$this->SessionCookieName = $sessionCookieName;
	}

	protected $SessionCookieName;

	public function __invoke(\Slim\Http\Request $request, \Slim\Http\Response $response, callable $next)
	{
		$route = $request->getAttribute('route');
		$routeName = $route->getName();
		$sessionService = new SessionService();

		if ($routeName === 'root')
		{
			$response = $next($request, $response);
		}
		elseif (getenv("GROCY_MODE") === 'dev' || getenv("GROCY_MODE") === 'demo' || getenv("GROCY_MODE") === 'prerelease' || getenv("GROCY_IS_EMBEDDED_INSTALL") || getenv("GROCY_DISABLE_AUTH"))
		{
			$user = $sessionService->GetDefaultUser();
			putenv("GROCY_AUTHENTICATED=true");
			putenv("GROCY_USER_USERNAME={$user->username}");

			$response = $next($request, $response);
		}
		else
		{
			if ((!isset($_COOKIE[$this->SessionCookieName]) || !$sessionService->IsValidSession($_COOKIE[$this->SessionCookieName])) && $routeName !== 'login')
			{
				putenv("GROCY_AUTHENTICATED=false");
				$response = $response->withRedirect($this->AppContainer->UrlManager->ConstructUrl('/login'));
			}
			else
			{
				if ($routeName !== 'login')
				{
					$user = $sessionService->GetUserBySessionKey($_COOKIE[$this->SessionCookieName]);
					putenv("GROCY_AUTHENTICATED=true");
					putenv("GROCY_USER_USERNAME={$user->username}");
					putenv("GROCY_USER_ID={$user->id}");
				}
				else
				{
					putenv("GROCY_AUTHENTICATED=false");
				}

				$response = $next($request, $response);
			}
		}

		return $response;
	}
}
