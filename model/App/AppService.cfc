import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="UserService" inject="UserService";

	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		super.init("App", "App.query.cache", true );
		return this;
	}
	
	
	public any function getAppByUser(
		Required	Any		AppID,
		Required	Any		UserID
	) {
		var criteria = {
			id = Val(arguments.AppID),
			user = UserService.get( Val(arguments.UserID) )
		};
		/*
		var _appid = LSParseNumber(arguments.AppID);
		var _userid = LSParseNumber(arguments.UserID);
		*/
		return super.findWhere(Criteria=criteria);
	}
	
	
	public any function appExistsByUser(
		Required	Any		AppID,
		Required	Any		UserID
	) {
		return ( IsNull( getAppByUser(argumentCollection=arguments) ) ? false : true );
	}


}