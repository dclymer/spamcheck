component hint="Project Honey Pot Config" {
	// Module Properties
	this.title 				= "ProjectHoneyPot";
	this.author 			= "Sigma Projects";
	this.webURL 			= "https://www.sigmaprojects.org";
	this.description 		= "The Project Honey Pot module for use in SpamCheck";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "projecthoneypot";

	function configure(){

		settings = {

			scoreWeight	= {
				'required'		= true,
				'default'		= 1,
				'description'	= 'The weighted score value you want to assign for this service (Range 1-10)'
			},
			
			apiKey = {
				'required'		= true,
				'description'	= 'Your Project Honey Pot API Key'
			},
			
			
			secondoctet = {
				'required'		= true,
				'default'		= '30',
				'description'	= 'How high can the second octet be before its considered STALE/WORTHLESS, range from 0-255 (2nd octet is for days since last seen, i.e. stale information)'
			},
			
			thirdoctet = {
				'required'		= true,
				'default'		= '10',
				'description'	= 'How high can the third octet be before its considered BAD, range from 0-255  (threat score)'
			},
			
			fourthoctet = {
				'required'		= true,
				'default'		= '1',
				'description'	= 'How high can the fourth octet be before its considered BAD, range from 1-7 (represents the type of visitor, see link above)'
			}
			
			

		};

		binder.map("ProjectHoneyPotService@ProjectHoneyPot").
			to("#moduleMapping#.model.ProjectHoneyPotService")
			.into( binder.SCOPES.NOSCOPE )
			.noInit();


		interceptorSettings = {
			customInterceptionPoints = arrayToList( [
			"projectHoneyPot_preCheckSpam", "projectHoneyPot_postCheckSpam",
			
			"projectHoneyPot_preSubmitSpam", "projectHoneyPot_postSubmitSpam",
			
			"projectHoneyPot_preSubmitHam", "projectHoneyPot_postSubmitHam"
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
		var ProjectHoneyPotService = controller.getWireBox().getInstance("ProjectHoneyPotService@ProjectHoneyPot");
		controller.getInterceptorService().processState('SpamCheckModuleLoaded', ProjectHoneyPotService );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var ProjectHoneyPotService = controller.getWireBox().getInstance("ProjectHoneyPotService@ProjectHoneyPot");
		controller.getInterceptorService().processState('SpamCheckModuleUnLoaded', ProjectHoneyPotService );
	}

}