component table="log" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="log_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";


	property
		name="Comment"
		fieldtype="one-to-one"
		cfc="Comment"
		fkcolumn="comment_id"
		missingRowIgnored="false"
		lazy="false";

	property
		name="Lookups"
		singularName="Lookup"
		type="array"
		fieldtype="one-to-many"
		cfc="Lookup"
		fkcolumn="log_id"
		inverse="true"
		cascade="all-delete-orphan"
		orderby="created desc";
	
	property
		name="postbackurl"
		index="postbackurl"
		ormtype="string"
		type="string"
		length="250";

	property
		name="PostbackData"
		fieldtype="one-to-one"
		cfc="PostbackData"
		fkcolumn="postbackdata_id"
		missingRowIgnored="true"
		lazy="false";

	property
		name="Submissions"
		singularName="Submission"
		cfc="Submission"
		type="array"
		fieldtype="one-to-many"
		fkcolumn="log_id"
		inverse="true"
		cascade="all-delete-orphan"
		orderby="created desc";

	/*
	property
		name="User"
		fieldtype="many-to-one"
		cfc="User"
		fkcolumn="user_id"
    	missingRowIgnored="false";
	*/

	property
		name="App"
		fieldtype="many-to-one"
		cfc="App"
		fkcolumn="app_id"
    	missingRowIgnored="false";	
	
	property
		name="spamconfidence"
		index="spamconfidence"
		ormtype="integer"  
		type="numeric"
		length="3"
		dbdefault="50"
		default="50";
	
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
	
	property
		name="lookupcount"
		ormtype="integer"  
		type="numeric"
		default="0"
		formula="SELECT count(1) FROM lookup l WHERE l.log_id = log_id";

	property
		name="lastsubmissiontype"
		ormtype="string"
		type="string"
		default=""
		formula="SELECT IFNULL(s.eventtype,'') FROM submission s WHERE s.log_id = log_id ORDER BY s.created DESC LIMIT 1";

	property
		name="postbackcount"
		ormtype="integer"  
		type="numeric"
		default="0"
		formula="SELECT count(1) FROM postback pb WHERE pb.submission_id IN (SELECT s.submission_id FROM submission s WHERE s.log_id = log_id)";

	property
		name="lastpostbackstatus_code"
		ormtype="integer"  
		type="numeric"
		default="0"
		formula="SELECT IFNULL(pb.status_code,0) FROM postback pb WHERE pb.submission_id IN (SELECT s.submission_id FROM submission s WHERE s.log_id = log_id) ORDER BY pb.created DESC LIMIT 1";

	public boolean function hasValidPostbackURL() {
		if( !IsNull(getPostbackURL()) && Len(Trim(getPostBackURL())) ) {
			return isValid('url',getPostbackURL());
		}
		return false;
	}

	public struct function toJSON() {
		var d = {};
		d['id']					= getID();
		d['comment']			= getComment().toJSON();
		d['postbackurl']		= getPostbackURL();
		d['spamconfidence']		= getSpamConfidence();
		if( hasLookup() ) {
			d['lookups']		= arrayToJSON( getLookups() );
		}
		if( hasPostbackData() ) {
			d['postbackdata']	= getPostbackData().toJSON();
		}
		if( hasSubmission() ) {
			d['submissions']	= arrayToJSON( getSubmissions() );
		}
		if( hasApp() ) {
			d['app']			= getApp().toJSON();
		}
		d['created']			= getCreated();
		d['updated']			= getUpdated();
		return d;
	}

}