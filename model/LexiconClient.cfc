/*
Author      :	Don Quist
GitHub		:	https://github.com/sigmaprojects
Date        :	02/23/2014
Description :

This client is used to get key:value pairs from a local server for SigmaProjects.org.

We create a lot of OSS that sometimes needs private settings, like
Mail Settings, Passwords, Hosts, etc.
It isn't always feasible to keep track of a file that needs to be .gitignored. 

We decided to firewall off a private ReST application we built that we can
retrieve these settings from when needed using this API client.

If you got this via one of our projects, simply find what references this client
(usually Wirebox.cfc or Coldbox.cfc) and replace our calls for your settings 
and delete this file.

If you have any issues or questions, you can contact us here: https://www.sigmaprojects.org/contact 

*/

component output="false" hint="Lexicon Client for SigmaProjects.org" {

	/**
	* Constructor
	* @apiKey.hint The API Key to use.
	* @host.hint Hostname for the API.
	* @service.hint URL Path to the service.
	* @timeout.hint HTTP timeout (in seconds).
	*/
	public LexiconClient function init(
		Required	String		apiKey,
					String		host		= 'lexicon.sigmaprojects.org',
					String		servicePath	= '/rest/v1/service/',
					Numeric		timeout		= 60
	) {
		// properties
		variables.apiKey		= arguments.apiKey;
		variables.host			= arguments.host;
		variables.servicePath	= arguments.servicePath;
		variables.timeout		= arguments.timeout;
		
		variables.getPath	= 'get';
		variables.setPath	= 'set';
		return this;
	}


	/**
	* Retrieves a setting stored in the lexicon.
	* @params.Key The setting key to retrieve. 
	*/
	public struct function get(
		Required	String		key
	) {
		var endpoint = variables.getPath & '/' & trim(arguments.key);
		var results = sendLexiconRequest(
			endpoint	= endpoint,
			method		= 'GET'
		);
		
		return results;
	}


	/**
	* Sets a key/value pair setting in the lexicon.
	* @params.key The setting key to set.
	* @params.value The value to set.  
	*/
	public struct function set(
		Required	String		key,
		Required	Any			value
	) {
		var endpoint = variables.setPath & '/' & trim(arguments.Key);
		var params = [];
		arrayAppend(
			params,
			{
				type	= 'BODY',
				value	= arguments.value
			}
		);
		var results = sendLexiconRequest(
			endpoint	= endpoint,
			method		= 'PUT',
			params		= params
		);
		
		return results;
	}



	/**
	* Sends a lexicon request and returns the http file content.
	* @endpoint.hint An endpoint to attach to the API URL.
	* @method.hint The HTTP Verb used for this call.
	* @params.hint The parameter array to send.
	*/
	private struct function sendLexiconRequest(
		Required	String		endpoint,
		Required	String		method,
					Array		params		= []
	) {

		var oHTTP = new http(
			url			= getAPIURL( arguments.endpoint ), 
			timeout		= variables.timeout,
			method		= arguments.method
		);
		
		oHTTP.addParam( name="apikey",  type="header", value=variables.apikey );

		
		for( var param in arguments.params ){
			var value = ( isSimpleValue(param['value']) ? param['value'] : serializeJson(param['value']) );
			if( structKeyExists(param,'name') ) {
				oHTTP.addParam( name=param['name'],	type=param['type'], value=value );
			} else {
				oHTTP.addParam( type=param['type'],	value=value );
			}
		}

		//oHTTP.addParam( type="body", value=serializeJson(data) );

		var prefix = oHTTP.send().getPrefix();
		var fileContent = prefix.fileContent;
		
		return deSerializeJson(fileContent);
	}


	/**
	* Get the API URL using the data in this CFC
	* @endpoint.hint An endpoint to attach to the API URL
	*/
	private string function getAPIURL(Required String endpoint) {
		return 'https://' & variables.host & variables.servicePath & arguments.endpoint;
	}


}