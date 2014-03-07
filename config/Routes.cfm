<cfscript>
	setEnabled(true);
	// Allow unique URL or combination of URLs, we recommend both enabled
	setUniqueURLS(false);
	// Auto reload configuration, true in dev makes sense to reload the routes on every request
	setAutoReload(true);
	// Sets automatic route extension detection and places the extension in the rc.format variable
	// setExtensionDetection(true);
	// The valid extensions this interceptor will detect
	// setValidExtensions('xml,json,jsont,rss,html,htm');
	// If enabled, the interceptor will throw a 406 exception that an invalid format was detected or just ignore it
	// setThrowOnInvalidExtension(true);

	// Base URL
	if( len(getSetting('AppMapping') ) lte 1){
		setBaseURL("https://#cgi.HTTP_HOST#/");
	}
	else{
		setBaseURL("https://#cgi.HTTP_HOST#/#getSetting('AppMapping')#/");
	}

	//addRoute(pattern="settings/:action?",handler="Settings");

	addRoute(pattern="log/infowin/:id-numeric",handler="Log",action="infowin");
	addRoute(pattern="log/log_tr/:id-numeric",handler="Log",action="log_tr");
	addRoute(pattern="log/submissionswin/:id-numeric",handler="Log",action="submissionswin");
	
	//addRoute(pattern="log/",handler="Log",action="index");
	
	
	addRoute(pattern="api/v1/log/get/:id-numeric",handler="api.v1.Log",action="get");
	addRoute(pattern="api/v1/log/save/",handler="api.v1.Log",action="save");
	
	addRoute(pattern="api/v1/lookup/get/:id-numeric",handler="api.v1.Lookup",action="get");
	addRoute(pattern="/api/v1/lookup/lookup/:id-numeric",handler="api.v1.Lookup",action="lookup");
	
	addRoute(pattern="api/v1/comment/get/:id-numeric",handler="api.v1.Comment",action="get");
	
	addRoute(pattern="api/v1/log/spam/submit/",handler="api.v1.Spam",action="submit");
	addRoute(pattern="api/v1/log/spam/submitSpam/:id-numeric",handler="api.v1.Spam",action="submitSpam");
	addRoute(pattern="api/v1/log/spam/submitHam/:id-numeric",handler="api.v1.Spam",action="submitHam");
	
	
	// Your Application Routes
	addRoute(pattern=":handler/:action?");


	/** Developers can modify the CGI.PATH_INFO value in advance of the SES
		interceptor to do all sorts of manipulations in advance of route
		detection. If provided, this function will be called by the SES
		interceptor instead of referencing the value CGI.PATH_INFO.

		This is a great place to perform custom manipulations to fix systemic
		URL issues your Web site may have or simplify routes for i18n sites.

		@Event The ColdBox RequestContext Object
	**/
	function PathInfoProvider(Event){
		/* Example:
		var URI = CGI.PATH_INFO;
		if (URI eq "api/foo/bar")
		{
			Event.setProxyRequest(true);
			return "some/other/value/for/your/routes";
		}
		*/
		return CGI.PATH_INFO;
	}
</cfscript>