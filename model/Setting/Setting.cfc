component table="setting" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	
	property name="key"
		column="setting_key"
		ormtype="string"
		type="string"
		fieldtype="id"
		generator="assigned"
		length="190";

	property
		name="value"
		column="setting_value"
		index="setting_value"
		ormtype="string"
		type="string"
		length="250";

	property
		name="category"
		index="category"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="description"
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
		

}