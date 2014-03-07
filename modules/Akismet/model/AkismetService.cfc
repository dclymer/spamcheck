component output="false" hint="The Akismet Service" singleton="true" implements="spamcheck.model.ILookupService"  {

	property name="controller" inject="coldbox";
	
	property name="configBean" inject="coldbox:configBean";
	
	property name="AppSettingService" inject="AppSettingService";

	public AkismetService function init(
		Required	App		App
	) {
		var settings = variables.configBean.getKey("modules").Akismet.settings;
		
		variables.ready = false;
		
		for(var key in settings) {
			var setting = settings[key];
			if( isStruct(setting) && AppSettingService.isModuleSettingValidForApp( 'akismet', setting, arguments.App ) ) {
				var AppSetting = AppSettingService.getModuleSettingForApp( 'akismet', key, arguments.App );
				variables[key] = AppSetting.getValue();
				variables.ready = true;
			} else {
				variables.ready = false;
				break;
			}
		}
		
		return this;
	}


	public boolean function isReady() {
		return variables.ready;
	}
	
	public numeric function getScoreWeight() {
		return variables.scoreweight;
	}

	/**
	* Comment Spam verification
	* @author.hint The author making the comment
	* @authorEmail.hint The author email
	* @authorURL.hint the Author URL
	* @content.hint The content that was submitted.
	* @permalink.hint The permanent location of the entry the comment was submitted to.
	* @blogURL.hint The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://. 
	* @user_ip.hint The author IP address.
	* @user_agent.hint The author user agent.
	* @referrer.hint The referrer from the author.
	* @commentType.hint May be blank, comment, trackback, pingback, or a made up value like "registration".
	*/
	public boolean function checkSpam( 
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	){
		var params = {
			"comment_author"		= arguments.author,
			"comment_author_email"	= arguments.authorEmail,
			"comment_author_url"	= arguments.authorURL,
			"comment_content"		= arguments.content,
			"permalink"				= arguments.permalink,
			"blog"					= arguments.blogURL,
			"user_ip"				= arguments.user_ip,
			"user_agent"			= arguments.user_agent,
			"referrer"				= arguments.content,
			"comment_type"			= arguments.referrer
		};
		
		variables.controller.getInterceptorService().processState('akismet_preCheckSpam',arguments);

		var results = sendAkismetRequest( endPoint=commentCheckPath, params=params );
		
		variables.controller.getInterceptorService().processState('akismet_postCheckSpam',results);
		
		// check for invalid
		if( trim( results.fileContent ) == "invalid" ){
			throw(message="Invalid Akismet Request", detail="#results.Responseheader.toString()#", type="InvalidRequest" );
		}
		
		// validate results
		return ( trim( results.fileContent) == 'true' ? true : false );
	}


	/**
	* Comment Spam verification
	* @author.hint The author making the comment
	* @authorEmail.hint The author email
	* @authorURL.hint the Author URL
	* @content.hint The content that was submitted.
	* @permalink.hint The permanent location of the entry the comment was submitted to.
	* @blogURL.hint The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://.
	* @user_ip.hint The author IP address.
	* @user_agent.hint The author user agent.
	* @referrer.hint The referrer from the author.
	* @commentType.hint May be blank, comment, trackback, pingback, or a made up value like "registration".
	*/
	public string function submitSpam( 
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	){
		var params = {
			"comment_author"		= arguments.author,
			"comment_author_email"	= arguments.authorEmail,
			"comment_author_url"	= arguments.authorURL,
			"comment_content"		= arguments.content,
			"permalink"				= arguments.permalink,
			"blog"					= arguments.blogURL,
			"user_ip"				= arguments.user_ip,
			"user_agent"			= arguments.user_agent,
			"referrer"				= arguments.content,
			"comment_type"			= arguments.referrer
		};

		variables.controller.getInterceptorService().processState('akismet_preSubmitSpam',arguments);

		var results = sendAkismetRequest( endPoint=spamPath, params=params );
		
		variables.controller.getInterceptorService().processState('akismet_postSubmitSpam',results);
		
		return results.fileContent;
	}


	/**
	* Comment Spam verification
	* @author.hint The author making the comment
	* @authorEmail.hint The author email
	* @authorURL.hint the Author URL
	* @content.hint The content that was submitted.
	* @permalink.hint The permanent location of the entry the comment was submitted to.
	* @blogURL.hint The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://.
	* @user_ip.hint The author IP address.
	* @user_agent.hint The author user agent.
	* @referrer.hint The referrer from the author.
	* @commentType.hint May be blank, comment, trackback, pingback, or a made up value like "registration".
	*/
	public string function submitHam( 
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	){
		var params = {
			"comment_author"		= arguments.author,
			"comment_author_email"	= arguments.authorEmail,
			"comment_author_url"	= arguments.authorURL,
			"comment_content"		= arguments.content,
			"permalink"				= arguments.permalink,
			"blog"					= arguments.blogURL,
			"user_ip"				= arguments.user_ip,
			"user_agent"			= arguments.user_agent,
			"referrer"				= arguments.content,
			"comment_type"			= arguments.referrer
		};
		
		variables.controller.getInterceptorService().processState('akismet_preSubmitHam',arguments);

		var results = sendAkismetRequest( endPoint=hamPath, params=params );
		
		variables.controller.getInterceptorService().processState('akismet_postSubmitHam',results);
		
		return results.fileContent;
	}


	/**
	*  Send an akismet request and returns the http result object.
	*/
	private function sendAkismetRequest(
		Required	String	endpoint,
					Struct	params	= {}
	){
		// create http service
		var oHTTP = new http(
			url			= getAPIURL( arguments.endPoint ), 
			timeout		= variables.HTTPTimeout,
			useragent	= variables.userAgent,
			method		= "post"
		);

		// add params
		if( !structIsEmpty( arguments.params ) ){
			for( var thisParam in arguments.params ){
				oHTTP.addParam( name=thisParam,  type="formfield", value=arguments.params[ thisParam ] );
			}
		}
		/*
		oHTTP.addParam( name='is_test',  type="url", value=1 );
		oHTTP.addParam( name='is_test',  type="formfield", value=1 );
		*/
		
		var prefix = oHTTP.send().getPrefix();

		return prefix;
	}


	/**
	* Get the API URL using the data in this CFC
	* @endpoint.hint An endpoint to attach to the API URL
	*/
	private string function getAPIURL( Required String endpoint ){
		var prefix = "http://#variables.apiKey#.";
		return prefix & variables.akismetHost & "/" & variables.akismetVersion & "/" & arguments.endPoint;
	}



	/**
	* Key verification
	*/
	private boolean function verifyKey(){
		variables.controller.getInterceptorService().processState('akismet_preVerifyKey',arguments);
		
		var results = sendAkismetRequest(
			endPoint	= variables.verifyKeyPath,
			params		= {
				"key"		: variables.apiKey,
				"blog"		: variables.defaultBlogURL
			}
		);
		
		var status = ( trim( results.fileContent ) == "invalid" ? false : true );
		// validate results
		return status;
		
		variables.controller.getInterceptorService().processState('akismet_postVerifyKey',results);
	}


}