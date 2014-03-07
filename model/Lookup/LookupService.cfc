import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="SpamCheckService" inject="SpamCheckService";
	
	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		super.init("Lookup", "Lookup.query.cache", true );
		return this;
	}

	public void function lookupLog(
		Required	Log		Log
	) {
		
		//var Lookups = [];
		var requestData = deSerializeJson(serializeJson(arguments.Log.getComment()));
		
		var Services = SpamCheckService.getServices();
		
		for(var Service in Services) {
			
			var ServiceObj = Service.service.init( arguments.Log.getApp() );
			if( ServiceObj.isReady() ) {
				var Lookup = super.new();
				var isSpam = ServiceObj.checkSpam( argumentCollection=requestData );
			
				Lookup.setIsSpam(isSpam);
				Lookup.setService( Service.name );
				Lookup.setScoreWeight( ServiceObj.getScoreWeight() );
				//arrayAppend( Lookups, Lookup );
				//save( Lookup );
				Lookup.setLog( arguments.Log );
				arguments.Log.addLookup( Lookup );
			}
		}
		
		//return Lookups;
	}

	public array function lookupComment(
		Required	Comment	Comment,
					String	services	= ''
	) {
		
		var Lookups = [];
		var requestData = arguments.Comment.toJSON();
		
		var Services = SpamCheckService.getServices();
		
		if( !len(trim(arguments.services)) || arguments.services eq '*' || arguments.services eq 'all' ) {
			var lookupServices = Services;
		} else {
			var lookupServices = [];
			for(var Service in Services) {
				if( listContainsNoCase(arguments.service,Service.name) ) {
					arrayAppend(lookupServices,Service);
				}
			}
		}
		
		for(var lookupService in lookupServices) {
			
			var ServiceObj = lookupService.service.init( arguments.Comment.getLog().getApp() );
			if( ServiceObj.isReady() ) {
				var Lookup = super.new();
				var isSpam = ServiceObj.checkSpam( argumentCollection=requestData );
			
				Lookup.setIsSpam(isSpam);
				Lookup.setService( lookupService.name );
				Lookup.setScoreWeight( ServiceObj.getScoreWeight() );
				Lookup.setLog( arguments.Comment.getLog() );
				save( Lookup );
				EntityReload( Lookup );
				arrayAppend( Lookups, Lookup );
			}
			
		}

		return Lookups;
	}


	public void function save(Required Lookup) {
		super.save(arguments.Lookup);
	}



}