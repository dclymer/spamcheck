component{

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "SpamCheck",
			eventName 				= "event",

			//Development Settings
			debugMode				= false,
			debugPassword			= "",
			reinitPassword			= "123",
			handlersIndexAutoReload = true,

			//Implicit Events
			defaultEvent			= "",
			requestStartHandler		= "Main.onRequestStart",
			requestEndHandler		= "",
			applicationStartHandler = "Main.onAppInit",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "",

			//Extension Points
			UDFLibraryFile 				= "includes/helpers/ApplicationHelper.cfm",
			coldboxExtensionsLocation 	= "",
			modulesExternalLocation		= [],
			pluginsExternalLocation 	= "",
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",

			//Error/Exception Handling
			exceptionHandler		= "Main.onException",
			onInvalidEvent			= "",
			customErrorTemplate		= "",

			//Application Aspects
			handlerCaching 			= false,
			eventCaching			= false,
			proxyReturnCollection 	= false
		};

		// custom settings
		settings = {
			bugEmailRecipients = "admin@localhost",
			
			debugPassword = coldbox.debugPassword // used to reload modules 
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			//development = "^cf8.,^railo."
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = true,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			//exclude = ['Akismet','ProjectHoneyPot','LinkSleeve']
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ColdboxTracerAppender" },
				
				AsyncDBAppender = {
					class="coldbox.system.logging.appenders.AsyncDBAppender",
					properties = {
						dsn = "spamcheck", table="api_logs", autocreate=true, textDBType="longtext"
					}
				}
			},
			// Root Logger
			root = { levelMin="FATAL", levelMax="WARN", appenders="AsyncDBAppender,coldboxTracer" },
			/*
			categories = {
				'model.SomeService' = { levelMin="FATAL", levelMax="INFO", appenders="AsyncDBAppender" },
			},
			*/
			// Implicit Level Categories
			OFF = ["coldbox.system"]
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "Main",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = "SpamCheckModuleLoaded,SpamCheckModuleUnLoaded,registerModuleSettings,postSubmitSpam,postSubmitHam,postSaveSubmission,postbackSaved"
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//SES
			{class="coldbox.system.interceptors.SES",
			 properties={}
			},
			{class="spamcheck.interceptors.JSONInterceptor",
			 properties={}
			},
			{class="spamcheck.interceptors.SpamCheckModulesInterceptor",
			 properties={}
			},
			{class="spamcheck.interceptors.SpamCheckInterceptor",
			 properties={}
			}
		];

		// Object & Form Validation
		validation = {
			// manager = "class path" or none at all to use ColdBox as the validation manager
			manager = "coldbox.system.validation.ValidationManager",
			// The shared constraints for your application.
			sharedConstraints = {
				// EX
				// myForm = { name={required=true}, age={type="numeric",min="18"} }
			}
		};

		// ORM services, injection, etc
		orm = {
			// entity injection
			injection = {
				// enable it
				enabled = true,
				// the include list for injection
				include = "",
				// the exclude list for injection
				exclude = ""
			}
		};

		// flash scope configuration
		flash = {
			scope = "session",
			properties = {}, // constructor properties for the flash scope implementation
			inflateToRC = true, // automatically inflate flash data into the RC scope
			inflateToPRC = false, // automatically inflate flash data into the PRC scope
			autoPurge = true, // automatically purge flash data for you
			autoSave = true // automatically save flash scopes at end of a request and on relocations.
		};

		//IOC Integration
		ioc = {
			framework = "wirebox",
			definitionFile  = "config.WireBox"
		};

		//Debugger Settings
		debugger = {
			enableDumpVar = false,
			persistentRequestProfilers = true,
			maxPersistentRequestProfilers = 10,
			maxRCPanelQueryRows = 50,
			showRCSnapshots = false,
			//Panels
			showTracerPanel = true,
			expandedTracerPanel = true,
			showInfoPanel = true,
			expandedInfoPanel = true,
			showCachePanel = true,
			expandedCachePanel = true,
			showRCPanel = true,
			expandedRCPanel = true,
			showModulesPanel = true,
			expandedModulesPanel = false
		};

		//Mailsettings
		mailSettings = {
			server = "",
			username = "",
			password = "",
			port = 25
		};
		//webservices
		webservices = {
			BugLog	= "http://buglog.sigmaprojects.org/listeners/bugLogListenerWS.cfc?wsdl"
		};

		//Datasources
		datasources = {
			//mysite   = {name="mySite", dbType="mysql", username="root", password="pass"}
		};

	}

}