component table="submission" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="submission_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	
	property
		name="Log"
		cfc="Log"
		fieldtype="many-to-one"
		fkcolumn="log_id"
    	missingRowIgnored="false";

	property
		name="Postback"
		fieldtype="one-to-one"
		cfc="Postback"
		fkcolumn="postback_id"
		missingRowIgnored="true"
		lazy="false";

	property
		name="eventtype"
		index="eventtype"
		ormtype="string"
		type="string"
		length="250";

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
		if( hasPostback() ) {
			d['postback']	= getPostback().toJSON();
		}
		d['eventtype']	= getEventType();
		d['created']	= getCreated();
		d['updated']	= getUpdated();
		return d;
	}

}
