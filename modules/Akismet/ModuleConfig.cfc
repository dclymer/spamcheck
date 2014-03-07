component hint="Akismet Config" {
	// Module Properties
	this.title 				= "Akismet";
	this.author 			= "Sigma Projects";
	this.webURL 			= "https://www.sigmaprojects.org";
	this.description 		= "The Akismet module for use in SpamCheck";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "akismet";

	function configure(){
		
		settings = {

			scoreWeight	= {
				'required'		= true,
				'default'		= 1,
				'description'	= 'The weighted score value you want to assign for this service (Range 1-10)'
			},

			userAgent	= {
				'required'		= true,
				'default'		= 'CFSpamCheck | CFSpamCheck/#this.version#',
				'description'	= 'The application name used in the user agent as per the Akismet API'
			},
			
			httpTimeout	= {
				'required'		= true,
				'default'		= 120,
				'description'	= 'HTTP Timeout for API calls (in seconds)'
			}, 
			
			apiKey = {
				'required'		= true,
				'description'	= 'Your Akismet API Key'
			},
			
			defaultBlogURL	= {
				'required'		= true,
				'description'	= 'The default "blogURL" used to verify the key'
			},
			
			akismetVersion	= {
				'required'		= true,
				'default'		= '1.1',
				'description'	= 'The Akismet API Version (their end)'
			},
			
			akismetHost	= {
				'required'		= true,
				'default'		= 'rest.akismet.com',
				'description'	= 'The end point host (hostname)'
			},
			
			
			verifyKeyPath	= {
				'required'		= true,
				'default'		= 'verify-key',
				'description'	= 'The verify-key endpoint'
			},
			
			spamPath	= {
				'required'		= true,
				'default'		= 'submit-spam',
				'description'	= 'The submit-spam endpoint'
			},
			
			hamPath	= {
				'required'		= true,
				'default'		= 'submit-ham',
				'description'	= 'The submit-ham endpoint'
			},
			
			commentCheckPath	= {
				'required'		= true,
				'default'		= 'comment-check',
				'description'	= 'The comment-check endpoint'
			}

		};
		
		binder.map("AkismetService@Akismet").
			to("#moduleMapping#.model.AkismetService")
			.into( binder.SCOPES.NOSCOPE )
			.noInit();


		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = arrayToList( [
			"akismet_preVerifyKey", "akismet_postVerifyKey",
			
			"akismet_preCheckSpam", "akismet_postCheckSpam",
			
			"akismet_preSubmitSpam", "akismet_postSubmitSpam",
			
			"akismet_preSubmitHam", "akismet_postSubmitHam"
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
		var AkismetService = controller.getWireBox().getInstance("AkismetService@Akismet");
		controller.getInterceptorService().processState('SpamCheckModuleLoaded', AkismetService );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var AkismetService = controller.getWireBox().getInstance("AkismetService@Akismet");
		controller.getInterceptorService().processState('SpamCheckModuleUnLoaded', AkismetService );
	}

}