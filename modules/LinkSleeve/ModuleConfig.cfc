component hint="linkSleeve Config" {
	// Module Properties
	this.title 				= "LinkSleeve";
	this.author 			= "Sigma Projects";
	this.webURL 			= "https://www.sigmaprojects.org";
	this.description 		= "The LinkSleeve module for use in SpamCheck";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "linksleeve";

	function configure(){

		settings = {

			scoreWeight	= {
				'required'		= true,
				'default'		= 1,
				'description'	= 'The weighted score value you want to assign for this service (Range 1-10)'
			},
			
			url	= {
				'required'		= true,
				'default'		= 'http://www.linksleeve.org/slv.php',
				'description'	= 'The LinkSleeve Service URL'
			},
			
			userAgent	= {
				'required'		= true,
				'default'		= 'CFSpamCheck | CFSpamCheck/#this.version#',
				'description'	= 'The user agent used when making http calls'
			},
			
			httpTimeout	= {
				'required'		= true,
				'default'		= 120,
				'description'	= 'HTTP Timeout for API calls (in seconds)'
			}

		};

		
		binder.map("LinkSleeveService@LinkSleeve").
			to("#moduleMapping#.model.LinkSleeveService")
			.into( binder.SCOPES.NOSCOPE )
			.noInit();


		interceptorSettings = {
			customInterceptionPoints = arrayToList( [
			"linksleeve_preCheckSpam", "linksleeve_postCheckSpam",
			
			"linksleeve_preSubmitSpam", "linksleeve_postSubmitSpam",
			
			"linksleeve_preSubmitHam", "linksleeve_postSubmitHam"
			] )
		};

		// Custom Declared Interceptors
		interceptors = [
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var LinkSleeveService = controller.getWireBox().getInstance("LinkSleeveService@LinkSleeve");
		controller.getInterceptorService().processState('SpamCheckModuleLoaded', LinkSleeveService );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var LinkSleeveService = controller.getWireBox().getInstance("LinkSleeveService@LinkSleeve");
		controller.getInterceptorService().processState('SpamCheckModuleUnLoaded', LinkSleeveService );
	}

}