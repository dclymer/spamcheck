component output="false" hint="The LinkSleeve Service" singleton="true" implements="spamcheck.model.ILookupService"  {

	property name="controller" inject="coldbox";
	
	property name="configBean" inject="coldbox:configBean";
	
	property name="AppSettingService" inject="AppSettingService";

	public LinkSleeveService function init(
		Required	App		App
	) {
		var settings = variables.configBean.getKey("modules").LinkSleeve.settings;
		
		variables.ready = false;
		
		for(var key in settings) {
			var setting = settings[key];
			if( isStruct(setting) && AppSettingService.isModuleSettingValidForApp( 'linksleeve', setting, arguments.App ) ) {
				var AppSetting = AppSettingService.getModuleSettingForApp( 'linksleeve', key, arguments.App );
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
		return ( structKeyExists(variables,'ready') ? variables.ready : false );
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
		
		variables.controller.getInterceptorService().processState('linkSleeve_preCheckSpam',arguments);

		var results = sendLinkSleeveRequest( params=arguments );
		
		variables.controller.getInterceptorService().processState('linkSleeve_postCheckSpam',results);

		try {
			var responseXML = xmlParse(results.fileContent);
			var linkSleeveResult = responseXML.methodResponse.params.param.value.int.xmlText;
			if(linkSleeveResult eq 0) {
				// 0 means it is spam
				return true;
			}
		} catch(any e) {
			throw(message="Invalid LinkSleeve Request", detail="#results.Responseheader.toString()#", type="InvalidRequest" );
		}
		
		// validate results
		return false;
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
		return '';
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
		return '';
	}


	/**
	*  Send an LinkSleeve request and returns the http result object.
	*/
	private function sendLinkSleeveRequest(
					Struct	params	= {}
	){
		// create http service
		var oHTTP = new http(
			url			= variables.url, 
			timeout		= variables.HTTPTimeout,
			useragent	= variables.userAgent,
			method		= "post"
		);

		var contentData = '';
		for(var key in arguments.params) {
			try {
				contentData = contentData & ' ' & arguments.params[key];
			} catch(any e) {
				contentData = contentData & ' ' & serializeJson(arguments.params[key]);
			}
		}
		
		var linkSleeveXML = "";
		savecontent variable="linkSleeveXML" {WriteOutput('<?xml version="1.0" encoding="UTF-8"?>
			<methodCall>
				<methodName>slv</methodName>
				<params>
					<param>
						<value><string>' & contentData & '</string></value>
					</param>
				</params>
			</methodCall>
		');}
		
		oHTTP.addParam( name='Content-Type',  type="HEADER", value="text/xml; charset=utf-8" );
		oHTTP.addParam( name='Content-Length',  type="HEADER", value=len(trim(linkSleeveXML)) );
		oHTTP.addParam( type="BODY", value=trim(linkSleeveXML) );
		
		var prefix = oHTTP.send().getPrefix();

		return prefix;
	}


}