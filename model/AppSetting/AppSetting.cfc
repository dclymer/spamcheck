component table="appsetting" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="appsetting_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	/*
	property name="key"
		column="setting_key"
		ormtype="string"
		type="string"
		fieldtype="id"
		generator="assigned"
		length="190";
	*/

	property
		name="key"
		column="setting_key"
		index="setting_key"
		ormtype="string"
		type="string"
		length="250";

	property
		name="value"
		column="setting_value"
		index="setting_value"
		ormtype="string"
		type="string"
		length="250";

	property
		name="section"
		index="section"
		ormtype="string"
		type="string"
		length="250"; // ala module?  email? etc

	property
		name="category"
		index="category"
		ormtype="string"
		type="string"
		length="250"; // ala module name/key, email to-alerts?
	
	property
		name="description"
		ormtype="clob"
		type="string";
	
	property
		name="App"
		cfc="App"
		fieldtype="many-to-one"
		fkcolumn="app_id"
    	missingRowIgnored="false";


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
		var d = {};
		d['key']			= getKey();
		d['value']			= getValue();
		d['section']		= getSection();
		d['category']		= getCategory();
		d['description']	= getDescription();
		d['created']		= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']		= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

}
