import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(
		Any	controller	Inject="coldbox",
		Any	configBean	Inject="coldbox:configBean"
	){
		super.init("AppSetting", "AppSetting.query.cache", true );
		variables.controller = arguments.controller;
		variables.configBean = arguments.configBean;
		variables.modules = {};
		return this;
	}

	public void function onDIComplete() onDIComplete {
		
	}

	public void function saveSettings(
		Required	App		App,
		Required	Array	Settings
	) {
		for(var Setting in Settings) {
			var AppSetting = getOrCreate(
				App		= arguments.App,
				Section	= Setting.Section,
				Category= Setting.Category,
				Key		= Setting.Key,
				Value	= Setting.Value
			);
			super.populate( target=AppSetting, memento=Setting, exclude="appsetting_id" );
			AppSetting.setApp(App);
			if( !App.hasAppSetting(AppSetting) ) {
				App.addAppSetting(AppSetting);
			}
			save(AppSetting);
		}
	}
	
	public any function getOrCreate(
		Required	App			App,
		Required	String		Section,
		Required	String		Category,
		Required	String		Key,
		Required	String		Value
	) {
		var Criteria = {
			App = arguments.app,
			section = arguments.Section,
			category = arguments.Category,
			key = arguments.Key
		};
		if( IsNull(super.findWhere(Criteria=Criteria)) ) {
			var AppSetting = super.new();
		} else {
			var AppSetting = super.findWhere(Criteria=Criteria);
		}
		return AppSetting;
	}
	

	public void function registermodule(Required String module) {
		
			var moduleObj = variables.configBean.getKey("modules")[arguments.module];
			variables.modules[arguments.module] = {
				settings		= duplicate(moduleObj.settings), // playing it safe for now.
				title			= moduleObj.title,
				author 			= moduleObj.author,
				webURL 			= moduleObj.webURL,
				description 	= moduleObj.description,
				version			= moduleObj.version
			};
		try {
		} catch(any e) {}
	}
	public any function getmodulesettings(Required String module) {
		
			return variables.modules[arguments.module].settings;
		try {
		} catch(any e) {
			return {};
		}
	}
	public struct function getAvailableSettings() {
		return variables.modules;
	}

	public any function getModuleSettingForApp(
		Required	String		Module,
		Required	String		Key,
		Required	App			App
	) {
		return super.findWhere(
			Criteria = {
				section = 'module',
				category = arguments.Module,
				App = arguments.App,
				key = arguments.key
			}
		);
	}

	public boolean function isModuleSettingValidForApp(
		Required	String	Module,
		Required	Struct	Setting,
		Required	App		App
	) {
		var settings = getmodulesettings( arguments.Module );
		
		for(var key in settings) {
			
			var AppSetting = super.findWhere(
				Criteria = {
					section = 'module',
					category = arguments.Module,
					App = arguments.App,
					key = key
				}
			);
			
			//var AppSetting = getModuleSettingForApp(argumentCollection=arguments);
			if( !IsNull(AppSetting) ) {
				if( structKeyExists(settings[key],'required') && !IsNull(AppSetting.getValue()) && len(trim(AppSetting.getValue())) ) {
					return true;
				}
			}
		}

		return false;
	}


	public void function save(Required AppSetting) {
		super.save(arguments.AppSetting);
	}
	
	public void function delete(Required AppSetting) {
		super.delete(arguments.AppSetting);
	}



	
}