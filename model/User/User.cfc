component table="user" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="user_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="email"
		index="email"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="password"
		index="password"
		ormtype="string"
		type="string"
		length="128"
		remotingfetch="false";

	property
		name="verifypassword"
		type="string"
		length="128"
		remotingfetch="false"
		persistent="false";
	
	property
		name="salt"
		index="salt"
		ormtype="string"
		type="string"
		length="128"
		remotingfetch="false";
	
	property
		name="apikey"
		index="apikey"
		ormtype="string"
		type="string"
		length="40";

	property
		name="Logs"
		singularname="Log" 
		type="array"
		fieldtype="one-to-many"
		cfc="Log"
		fkcolumn="log_id"
		inverse="true"
		cascade="all-delete-orphan"
		orderby="created desc";

	/*
	property
		name="Apps"
		singularName="App"
		type="array"
		fieldtype="one-to-many"
		cfc="App"
		fkcolumn="user_id"
		inverse="true"
		cascade="all-delete-orphan"
		orderby="created desc";
	*/
	property
		name="created"
		index="created"
		ormtype="timestamp"
		type="date";
	
	property
		name="updated"
		index="updated"
		ormtype="timestamp"
		type="date";


	public struct function toJSON() {
		var u = {};
		u['id']			= getID();
		u['apikey']		= getAPIKey();
		u['created']	= getCreated();
		u['updated']	= getUpdated();
		return u;
	} 

	this.constraints = {
		'email'			= {
			required		= true,
			requiredMessage	= "Email is required",
			type			= "email",
			typeMessage		= "Must be a valid E-Mail address.",
			unique			= true,
			uniqueMessage	= "E-Mail address already registered."
		},
		password			= {
			required		= true,
			requiredMessage	= "Password is required",
			size			= '6..128',
			sizeMessage		= "Password must be between 6 and 128 characters"
		},
		verifypassword = {
			sameAs			= "password",
			sameAsMessage	= "Passwords must match"
		}
	};


	public void function postInsert() {
		var newAPIKey = lCase(Hash(CreateUUID(),'SHA1'));
		setAPIKey(newAPIKey);
		
		var newSalt = Hash(GenerateSecretKey("AES"), "SHA-512");
		setSalt(newSalt);
		
		var hashedPassword = Hash(getPassword() & getSalt(), "SHA-512");
		setPassword(hashedPassword);
	}




}
