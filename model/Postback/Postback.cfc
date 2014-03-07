component table="postback" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="postback_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	
	property
		name="Submission"
		cfc="Submission"
		fieldtype="many-to-one"
		fkcolumn="submission_id"
    	missingRowIgnored="false";

	property
		name="eventtype"
		index="eventtype"
		ormtype="string"
		type="string"
		length="250";

	property
		name="charset"
		index="charset"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="http_version"
		index="http_version"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="mimetype"
		index="mimetype"
		ormtype="string"
		type="string"
		length="250";

	property
		name="status_text"
		index="status_text"
		ormtype="string"
		type="string"
		length="250";
		
	property
		name="statuscode"
		index="statuscode"
		ormtype="string"
		type="string"
		length="250";
		
	property
		name="content_type"
		index="content_type"
		ormtype="string"
		type="string"
		length="250";
		
	property
		name="status_code"
		index="status_code"
		ormtype="integer"  
		type="numeric"
		length="8";
	
	property
		name="header"
		ormtype="clob"
		type="string";
	
	property
		name="errordetail"
		ormtype="clob"
		type="string";
	
	property
		name="filecontent"
		ormtype="clob"
		type="string";

	property
		name="responseheader"
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

	property
		name="postbackretrycount"
		index="postbackretrycount"
		ormtype="integer"  
		type="numeric"
		length="5";

	public struct function toJSON() {
		var d = {};
		d['id']				= getID();
		d['eventtype']		= geteventtype();
		d['charset']		= getcharset();
		d['http_version']	= gethttp_version();
		d['mimetype']		= getmimetype();
		d['status_text']	= getstatus_text();
		d['statuscode']		= getstatuscode();
		d['content_type']	= getcontent_type();
		d['status_code']	= getstatus_code();
		d['header']			= getheader();
		d['errordetail']	= geterrordetail();
		d['filecontent']	= getfilecontent();
		d['responseheader']	= getresponseheader();
		d['created']		= getCreated();
		d['updated']		= getUpdated();
		return d;
	}

}
