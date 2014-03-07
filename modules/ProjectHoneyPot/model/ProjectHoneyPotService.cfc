component output="false" hint="The Project Honey Pot Service" singleton="true" implements="spamcheck.model.ILookupService"  {

	property name="controller" inject="coldbox";
	
	property name="configBean" inject="coldbox:configBean";
	
	property name="AppSettingService" inject="AppSettingService";
	

	public ProjectHoneyPotService function init(
		Required	App		App
	) {
		var settings = variables.configBean.getKey("modules").ProjectHoneyPot.settings;
		
		variables.ready = false;
		
		for(var key in settings) {
			var setting = settings[key];
			if( isStruct(setting) && AppSettingService.isModuleSettingValidForApp( 'projecthoneypot', setting, arguments.App ) ) {
				var AppSetting = AppSettingService.getModuleSettingForApp( 'projecthoneypot', key, arguments.App );
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
			"user_ip"				= arguments.user_ip
		};
		
		variables.controller.getInterceptorService().processState('projectHoneyPot_preCheckSpam',arguments);

		var results = sendProjectHoneyPotRequest( params=arguments );
		
		variables.controller.getInterceptorService().processState('projectHoneyPot_postCheckSpam',results);

		try {
		} catch(any e) {
			throw(message="Invalid ProjectHoneyPot Request", detail="#results.Responseheader.toString()#", type="InvalidRequest" );
		}
		
		// validate results
		return results;
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
	*  Send an ProjectHoneyPot request and returns the http result object.
	*/
	private boolean function sendProjectHoneyPotRequest(
					Struct	params	= {}
	){
		var reversedIPArr = listToArray(arguments.params.user_ip,".");
		if( !arrayLen(reversedIPArr) eq 4 ) { return true; }
		var reversedIPStr = reversedIPArr[4]&"."&reversedIPArr[3]&"."&reversedIPArr[2]&"."&reversedIPArr[1];
		
		var found = false;
		try {
			var projHoneypotResult = createObject("java", "java.net.InetAddress").getByName("#variables.apiKey#.#reversedIPStr#.dnsbl.httpbl.org").getHostAddress();
			var found = true;
		} catch("java.net.UnknownHostException" e) {
			return false;
		}
		
		if( found ) {
			return calculateResults( projHoneypotResult );
		}
		
		return false;
	}
	
	private boolean function calculateResults(Required String projHoneypotResult) {
		var resultArray = listToArray(arguments.projHoneypotResult,".");
			
		var daysOld		= resultArray[2];
		var threatScore	= resultArray[3];
		var visitorType	= resultArray[4];
			
		if( visitorType gt variables.fourthoctet ) {
			return true;
		}
		if( threatScore gt variables.thirdoctet && daysOld lt variables.secondoctet ) {
			return true;
		}
		
		return false;
	}


}