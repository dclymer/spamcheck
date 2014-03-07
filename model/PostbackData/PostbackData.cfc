component table="postbackdata" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="postbackdata_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	
	property
		name="Log"
		fieldtype="many-to-one"
		cfc="Log"
		fkcolumn="log_id"
    	missingRowIgnored="false";
	/*
	property
		name="key"
		column="postbackdata_key" 
		index="postbackdata_key"
		ormtype="string"
		type="string"
		length="250";

	property
		name="type"
		column="type" 
		index="type"
		ormtype="string"
		type="string"
		length="250";
*/
	property
		name="value"
		ormtype="clob"
		type="string";

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
		d['id']			= getID();
		//d['key']		= getKey();
		d['value']		= getValue();
		d['created']	= getCreated();
		d['updated']	= getUpdated();
		return d;
	}

}
