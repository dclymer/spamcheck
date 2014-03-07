import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		super.init("Comment", "Comment.query.cache", true );
		return this;
	}
	
	
}