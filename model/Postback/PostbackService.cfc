import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(
		Any	controller	Inject="coldbox"
	){
		variables.controller	= arguments.controller;
		variables.maxTryCount	= 10;
		variables.timeout		= 60;
		super.init("Postback", "Postback.query.cache", true );
		return this;
	}
	
	
	public any function postback(
		Required	String		EventType,
		Required	Log			Log,
		Required	Submission	Submission
	) {

		if( arguments.Log.hasValidPostbackURL() ) {
			
			var requestParms = {
				EventType	= arguments.EventType,
				//oURL		= 'http://www.sigmaprojects.org',
				oURL		= arguments.Log.getPostbackURL(),
				Log			= arguments.Log
			};
			var result = sendRequest( argumentCollection=requestParms );
			
			saveResult( Submission=arguments.Submission, EventType=arguments.EventType, Result=result);
			
			return result;
		}

	}
	
	private void function saveResult(
		Required	Submission		Submission,
		Required	String			EventType,
		Required	Struct			Result
	) {
		var Postback = super.new();
		Postback.setSubmission( arguments.Submission );
		arguments.Submission.setPostback( Postback );
		
		super.populate( target=Postback, memento=arguments.Result, exclude='status_code,responseheader' );
		
		Postback.setEventType( arguments.EventType );

		if( structKeyExists(arguments.Result,'responseheader') ) {
			Postback.setResponseHeader( serializeJson(arguments.Result.responseheader) );
		}
		
		if( structKeyExists(arguments.Result,'status_code') && isNumeric(arguments.Result.status_code) ) {
			Postback.setStatus_Code( arguments.Result.status_code );
		}
		
		if( structKeyExists(arguments.Result,'responseheader') && isStruct(arguments.Result.responseheader) && structKeyExists(arguments.Result.responseheader,'Content-Type') && isSimpleValue(arguments.Result.responseheader['Content-Type']) ) {
			Postback.setContent_Type( arguments.Result.responseheader['Content-Type'] );
		} else {
			Postback.setContent_Type( '(Unknown)' );
		}
		
		save(Postback);
	}
	
	private struct function sendRequest(
		Required	String		oURL,
		Required	Log			Log,
		Required	String		EventType,
					Numeric		tryCount	= 0
	) {
		if( arguments.tryCount gte variables.maxTryCount ) {
			throw(message="Maximum amount of sendRequest tries reached, aborting.", type="PostbackService.RetryLimit");
		}

		var oHTTP = new http(
			url			= arguments.oURL,
			timeout		= variables.timeout,
			useragent	= 'SpamCheck v1 / Postback',
			method		= 'put',
			redirect	= true
		);
		
		var bodyData = {};
		bodyData['eventtype'] = arguments.EventType;
		bodyData['log'] = arguments.Log.toJSON();
		bodyData['postbackdata'] = {};
		if( arguments.Log.hasPostbackData() ) {
			try {
				bodyData['postbackdata'] = deSerializeJson(arguments.Log.getPostbackData().getValue());
			} catch(any e) {
				bodyData['postbackdata'] = arguments.Log.getPostbackData().getValue();
			}
		}
		var bodyDataString = serializeJson(bodyData);
		
		oHTTP.addParam( name="Content-Type",	type="header",	value='application/json; charset=utf-8' );
		oHTTP.addParam( name="Content-Length",	type="header",	value=Len(bodyDataString) );
		
		oHTTP.addParam( type="BODY",							value=bodyDataString );
		
		var prefix = oHTTP.send().getPrefix();
		
		if( structKeyExists(prefix,'responseheader') && isStruct(prefix.responseheader) && structKeyExists(prefix.responseheader,'Location') && isValid('url',prefix.responseheader.Location) ) {
			arguments.tryCount++;
			return sendRequest(
				oURL		= prefix.responseheader.Location,
				Log			= arguments.Log,
				EventType	= arguments.EventType,
				tryCount	= arguments.tryCount
			);
		}

		return prefix;
	}
	
	public void function save(Required Postback) {
		super.save(arguments.Postback);
		variables.controller.getInterceptorService().processState('postbackSaved',arguments.Postback);
	}
	
}