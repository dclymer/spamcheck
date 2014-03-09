/*
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Description :
	Relax Resources Definition.  For documentation on how to build this CFC
	look at our documenation here: http://wiki.coldbox.org/wiki/Projects:Relax.cfm
	
	The methods you can use for defining your RESTful service are:
	
	// Service is used to define the service
	- service(title:string,
		      description:string,
			  entryPoint:string or struct
			  extensionDetection:boolean,
			  validExtensions:list,
			  throwOnInvalidExtensions:boolean);
	
	// GlobalHeader() is used to define global headers which can be concatenated
	- globalHeader(name:string, description:string, required:boolean, default:any, type:string);
	
	// globalParam() is used to define global params which can be concatenated
	- globalParam(name:string, description:string, required:boolean, default:any, type:string);
	
	// Resources are defined by concatenating the following methods
	// The resource() takes in all arguments that match the SES addRoutes() method
	resource(pattern:string, handler:string, action:string or struct)
		.description(string)
		.methods(string or list)
		.header(name:string, description:string, required:boolean, default:any, type:string)
		.param(name:string, description:string, required:boolean, default:any, type:string)
		.placeholder(name:string, description:string, required:boolean, default:any, type:string)
		.schema(format:string, description:string, body:string)
		.sample(format:string, description:string, body:string);
		
*/
component output="false" {
	
	// I save the location of this CFC path to use resources located here
	variables.dirPath = getDirectoryFromPath( getMetadata(this).path ); 
	
	function configure(){
		
		/************************************** SERVICE DEFINITION *********************************************/
		
		// This is where we define our RESTful service, this is usually
		// our first place before even building it, we spec it out.
		this.relax = {
			// Service Title
			title = "Spam Check RESTful API",
			// Service Description
			description = "",
			// Service entry point, can be a single string or name value pairs to denote tiers
			//entryPoint = "http://www.myapi.com",
			entryPoint = {
				//dev  = "https://dev.myapi.com",
				production = "https://spamcheck.sigmaprojects.org/api/v1"
			},
			// Does it have extension detection via ColdBox
			extensionDetection = true,
			// Valid format extensions
			validExtensions = "xml,json,jsont,wddx,html",
			// Does it throw exceptions when invalid extensions are detected
			throwOnInvalidExtension = false		
		};
		
		/************************************** GLOBAL PARAMS +  HEADERS *********************************************/

		// Global API Headers
		globalHeader(name="apikey",description="The apikey needed for request authentication.",required=true);
		globalHeader(name="appid",description="The appid needed for certain spam check request.",required=false);

		
		/************************************** RESOURCES *********************************************/
		
		// api users resource
		resource(pattern="/comment/get/:id",handler="api.v1.Comment",action={GET = 'get'})
			.description("Gets a comment")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.schema(format="json", description="The following will be returned when the format requested is JSON.", body=fileRead("#dirPath#schemas/comment/comment.json"))
			.placeholder(name="id",description="The Comment ID",required=true);
			
		resource(pattern="/log/get/:id",handler="api.v1.Log",action={GET = 'get'})
			.description("Gets a log")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.schema(format="json", description="The following will be returned when the format requested is JSON.", body=fileRead("#dirPath#schemas/log/log.json"))
			.placeholder(name="id",description="The Log ID",required=true);
		
		resource(pattern="/lookup/get/:id",handler="api.v1.Lookup",action={GET = 'get'})
			.description("Gets a lookup")
			.methods("GET")
			.defaultMethod("GET")
			.defaultFormat("json")
			.schema(format="json", description="The following will be returned when the format requested is JSON.", body=fileRead("#dirPath#schemas/lookup/lookup.json"))
			.placeholder(name="id",description="The Lookup ID",required=true);
			
		resource(pattern="/lookup/lookup/:id",handler="api.v1.Lookup",action={POST = 'lookup'})
			.description("Requests a lookup on a specific comment")
			.methods("POST")
			.defaultMethod("POST")
			.defaultFormat("json")
			.schema(format="json", description="The following will be returned when the format requested is JSON.", body=fileRead("#dirPath#schemas/lookup/lookups.json"))
			.placeholder(name="id",description="The Comment ID",required=true);
		
		resource(pattern="/spam/check",handler="api.v1.Spam",action={POST = 'check'})
			.description("Creates and returns a new Log with lookups")
			.param(name="appid",			description="The appid this Log will belong to - must match your API Key header.",	required="true", 		type="header")
			.param(name="author",			description="The author making the comment",										required=true)
			.param(name="authorEmail",		description="The author email",														required=true)
			.param(name="authorURL",		description="The Author URL",														required=true)
			.param(name="content",			description="The content that was submitted.",										required=true)
			.param(name="permalink",		description="The permanent location of the entry the comment was submitted to.",	required=true)
			.param(name="blogURL",			description="The front page or home URL of the instance making the request. For a blog or wiki this would be the front page. Note: Must be a full URI, including http://.",				required=true)
			.param(name="user_ip",			description="The author IP address.",												required=true)
			.param(name="user_agent",		description="The author user agent.",												required=true)
			.param(name="referrer",			description="The referrer from the author.",										required=true)
			.param(name="commentType",		description="May be blank, comment, trackback, pingback, or a made up value like 'registration'.",			required=false)
			.param(name="PostbackData",		description="Any postback data you want sent for future submissions",				required="false")
			.methods("POST")
			.defaultMethod("POST")
			.defaultFormat("json")
			.schema(format="json", description="The following will be returned when the format requested is JSON.", body=fileRead("#dirPath#schemas/log/log.json"))
			.placeholder(name="id",description="The Comment ID",required=true);
		
		
		
		
			
		// api my resource
		resource(pattern="/api/TETETEET",handler="rest.myUser",action={POST = 'create', GET = 'getResources'})
			.description("Returns of my available resources")
			.methods("GET,POST")
			.defaultMethod("POST");
			  
		// api user username
		resource(pattern="/api/user/:username",handler="rest.user",action="{'get':'view','post':'create','put':'update','delete','remove'}")
			.description("The representation for system users.  You can also interact with creation, updating and deletion via this resource")
			.methods("GET,POST,PUT,DELETE")
			.header(name="x-test",description="Return test in a header",required="true")
			.param(name="firstName",description="The user firstname. Only used on PUT and POST operations",required="true")
			.param(name="lastName",description="The user lastname. Only used on PUT and POST operations",required=true)
			.param(name="email",description="The user email. Only used on PUT and POST operations",required="false")
			.placeholder(name="username",description="The resource username to interact with",required=true);
			
		// table actions resource
		resource(pattern="/api/tables/:action",handler="rest.table")
			.description("Returns table actions")
			.methods("GET");
			 
		/*
		// api user resource with response tags
		resource(pattern="/api/user", handler="rest.user")
			.description("User resource.")
 			.methods("GET,POST")
	 		.param(name="userID", description="The userID of the User record.", required=false)
	 		.param(name="username", description="The username of the User record.", required=false)
	 		.schema(format="json", description="The following will be returned when the format requested is JSON.", body=fileRead("#dirPath#schemas/user/user.json"))
	 		.schema(format="xml", description="The following will be returned when the format requested is XML.", body=fileRead("#dirPath#schemas/user/user.xsd"))
	 		.sample(format="json", description="The basic user information will be returned in a flat object.", body=fileRead("#dirPath#samples/user/user.json"))
			.sample(format="json", description="If the requested user is not found, or some other error has occurred, the resopnse will be like the following.", body=fileRead("#dirPath#samples/user/failure.json"));
		*/
	}

}