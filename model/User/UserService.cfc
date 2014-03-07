import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="SessionStorage" inject="coldbox:plugin:SessionStorage";
	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		super.init("User", "User.query.cache", true );
		return this;
	}
	
	
	public boolean function login(
		Required	String		Email,
		Required	String		Password
	) {
		var User = super.findByEmail( arguments.Email );
		if( !IsNull(User) ) {
			if( Hash(arguments.password & User.getSalt(), "SHA-512") eq User.getPassword() ) {
				setUserSession( User );
				return true;
			}
		}
		return false;
	}
	
	public void function setUserSession(Required User) {
		SessionStorage.setVar('user',arguments.User.toJSON());
	}
}