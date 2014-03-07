component singleton {

	property name="LogService" inject="LogService";
	
	property name="Logger" inject="logbox:logger:{this}";


	public any function init(
		Any		controller	Inject="coldbox"
	){
		variables.controller = arguments.controller;
		variables.services = [];
		return this;
	}


	/**
	* Submit submissions for Ham or Spam
	* @Submissions.hint An array struct consisting of 2 keys.  Type:Ham|Spam, Log:Log object
	*/
	public boolean function submit(
		Required	App			App,
		Required	Array		Submissions
	) {

		for(var Submission in Submissions) {
			switch(Submission.Type) {
				case 'ham': {
					submitHam( App=arguments.App, Logs=[Submission.Log] );
					break;
				}
				case 'spam': {
					submitSpam( App=arguments.App, Logs=[Submission.Log] );
					break;
				}
			}
		}
		return true;
	}


	public boolean function submitSpam(
		Required	App			App,
		Required	Array		Logs
	) {
		
		for(var Log in arguments.Logs) {
			//var requestData = deSerializeJson(serializeJson(Log.getComment()));
			var requestData = Log.getComment().toJSON();
		
			for( var Service in getReadyServices() ) {
				//service['service'].submitSpam(argumentCollection=requestData);
			}
			
			variables.controller.getInterceptorService().processState( state='postSubmitSpam', interceptData={Log=Log} );
			//variables.controller.getInterceptorService().processState( state='postSubmitSpam', interceptData={Log=Log} );
		}
		return true;
	}


	public boolean function submitHam(
		Required	App			App,
		Required	Array		Logs
	) {
		for(var Log in arguments.Logs) {
			var requestData = deSerializeJson(serializeJson(Log.getComment()));
		
			for( var Service in getReadyServices() ) {
				//service['service'].submitHam(argumentCollection=requestData);
			}
			
			variables.controller.getInterceptorService().processState( state='postSubmitHam', interceptData={Log=Log} );
			//variables.controller.getInterceptorService().processState( state='postSubmitHam', interceptData={Log=Log} );
		}
		return true;
	}

	
	
	
	public void function addService(
		Required	Any		Service
	) {
		var serviceData = {};
		serviceData['service'] = arguments.Service;
		//serviceData['isready'] = arguments.Service.isReady();
		serviceData['name'] = listLast(getMetaData(arguments.Service).name,'.');
		if( !serviceExists(serviceData['name']) ) {
			arrayAppend(variables.services,serviceData);
		}
	}


	public void function removeService(
		Required	Any		Service
	) {
		var i = 0;
		for(var Service in getServices()) {
			i++;
			if( Service.name eq listLast(getMetaData(arguments.Service).name,'.') ) {
				arrayDeleteAt(variables.services,i);
			}
		}
	}

	public array function getReadyServices() {
		return variables.services;
		
		var services = [];
		for(var service in variables.services) {
			if( service.isready ) {
				arrayAppend(services,service);
			}
		}
		return services;
	}

	public array function getServices() {
		return variables.services;
	}


	public boolean function serviceExists(
		Required	String		serviceName
	) {
		for(var Service in getServices()) {
			if( Service.name eq arguments.serviceName ) {
				return true;
			}
		}
		return false;
	}
}