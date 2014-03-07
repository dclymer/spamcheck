component table="app" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="app_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="name"
		index="name"
		ormtype="string"
		type="string"
		length="60";
	
	property
		name="User"
		cfc="User"
		fieldtype="many-to-one"
		fkcolumn="user_id"
    	missingRowIgnored="false";
	
	property
		name="postbackurl"
		index="postbackurl"
		ormtype="string"
		type="string"
		length="255";

	property
		name="appid"
		index="appid"
		ormtype="string"
		type="string"
		length="40";

	property
		name="AppSettings"
		singularname="AppSetting" 
		type="array"
		fieldtype="one-to-many"
		cfc="AppSetting"
		fkcolumn="app_id"
		inverse="true"
		//cascade="all-delete-orphan"
		orderby="section asc, category asc, setting_key asc";

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


	this.constraints = {
		name			= {
			required		= true,
			requiredMessage	= "App name is required",
			size			= "2..50",
			sizeMessage		= "App name must be between 2 and 50 characters long"
		},
		postbackurl		= {
			required		= false,
			type			= 'url',
			typeMessage		= "Postback URL must be a valid URL"
		}
	};

	public boolean function hasPostbackURL() {
		if( !IsNull(getPostbackURL()) && Len(trim(getPostbackURL())) && isValid('url',getPostbackURL()) ) {
			return true;
		}
		return false;
	}

	public struct function toJSON() {
		var d = {};
		d['id']				= getID();
		d['name']			= getName();
		d['postbackurl']	= getPostbackurl();
		d['appid']			= getAppID();
		if( hasAppSetting() ) {
			d['appsettings']	= arrayToJSON( getAppSettings() );
		} else {
			d['appsettings']	= ArrayNew(1);
		}
		d['created']		= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']		= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

	public void function preInsert() {
		var newAppID = lCase(Hash(CreateUUID(),'SHA1'));
		setAppID(newAppID);
	}


}
