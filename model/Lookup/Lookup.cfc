component table="lookup" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="lookup_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="service"
		index="service"
		ormtype="string"
		type="string"
		length="250";

	property
		name="isspam"
		index="isspam"
		ormtype="boolean"  
		type="boolean";
	
	property
		name="Log"
		fieldtype="many-to-one"
		cfc="Log"
		fkcolumn="log_id"
    	missingRowIgnored="false";
	
	property
		name="scoreweight"
		index="scoreweight"
		ormtype="integer"
		dbdefault="5"
		default="5"  
		type="numeric";
	
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
		d['id']				= getID();
		d['service']		= getService();
		d['isspam']			= getIsSpam();
		d['scoreweight']	= getScoreWeight();
		d['created']		= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']		= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

}