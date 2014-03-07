component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

//import coldbox.system.orm.hibernate.*;
	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(
		Any	controller	Inject="coldbox"
	){
		super.init("Setting", "Setting.query.cache", true );
		variables.controller = arguments.controller;
		return this;
	}

	public void function onDIComplete() onDIComplete {
		
	}

	public void function setValue(
		Required	String		Key,
		Required	Any			Value,
					String		Category,
					String		Description
	) {
		if( super.exists(arguments.Key) ) {
			var Setting = super.get(arguments.Key);
		} else {
			var Setting = super.new();
			Setting.setKey(arguments.Key);
		}
		Setting.setValue(arguments.Value);
		if( structKeyExists(arguments,'Category') ) { Setting.setCategory(trim(arguments.Category)); }
		if( structKeyExists(arguments,'Description') ) { Setting.setDescription(trim(arguments.Description)); }
		save(Setting);
	}

	public string function getValue(
		Required	String		Key
	) {
		if( super.exists(arguments.Key) ) {
			return super.get(arguments.Key).getValue();
		}
		throw( message="Setting '#arguments.Key#' Not Found", type="SettingNotFound");
	}
	
	public string function getOrCreate(
		Required	String		Key,
					String		Value		= '',
					String		Category	= '',
					String		Description = ''
	) {
		try {
			return getValue(arguments.Key);
		} catch(SettingNotFound e) {
			setValue(argumentCollection=arguments);
			return getValue(arguments.Key);
		}
	}
	
	public void function save(Required Setting) {
		super.save(arguments.Setting);
		variables.controller.getInterceptorService().processState('settingSaved',arguments.Setting);
	}
	
	public void function delete(Required Setting) {
		super.delete(arguments.Setting);
		variables.controller.getInterceptorService().processState('settingDeleted',arguments.Setting);
	}

}