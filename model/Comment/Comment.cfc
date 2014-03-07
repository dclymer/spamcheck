component table="comment" persistent=true extends="spamcheck.model.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="comment_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="Log"
		fieldtype="many-to-one"
		cfc="Log"
		fkcolumn="log_id"
    	missingRowIgnored="false";	

	property
		name="author"
		index="author"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="authoremail"
		index="authoremail"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="authorurl"
		index="authorurl"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="commenttype"
		index="commenttype"
		ormtype="string"
		type="string"
		length="250";
	
	property
		name="permalink"
		index="permalink"
		ormtype="string"
		type="string"
		length="250";

	property
		name="blogurl"
		index="blogurl"
		ormtype="string"
		type="string"
		length="250";

	property
		name="content"
		index="content"
		ormtype="clob"
		type="string";
	
	property
		name="user_ip"
		index="user_ip"
		ormtype="string"
		type="string"
		length="15";

	property
		name="user_agent"
		index="user_agent"
		ormtype="string"
		type="string"
		length="250";
		
	property
		name="referrer"
		index="referrer"
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
		d['id']					= getID();
		d['author']				= getauthor();
		d['authoremail']		= getauthoremail();
		d['authorurl']			= getauthorurl();
		d['commenttype']		= getcommenttype();
		d['permalink']			= getpermalink();
		d['blogurl']			= getblogurl();
		d['content']			= getcontent();
		d['user_ip']			= getuser_ip();
		d['user_agent']			= getuser_agent();
		d['referrer']			= getreferrer();
		d['created']			= getCreated();
		d['updated']			= getUpdated();
		return d;
	}

}
