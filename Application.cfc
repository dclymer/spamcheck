/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component{
	// Application properties
	this.name = "SpamCheck11";
	this.applicationTimeout = createTimeSpan(0,0,0,1);
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;
	
	// Mappings Imports
	import coldbox.system.*;
	
	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath());
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING  = "";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE  = "spamcheck.config.coldbox";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY 	 = "";
	
	this.mappings["/spamcheck"] = COLDBOX_APP_ROOT_PATH;
	this.mappings["/model"] = COLDBOX_APP_ROOT_PATH & "model";

	this.defaultdatasource="spamcheck";
	this.ormenabled = "true";
	this.ormsettings = {
		datasource = "spamcheck",
		skipCFCWithError = true,
		autorebuild=true,
		dialect="org.hibernate.dialect.MySQL5InnoDBDialect",
		dbcreate="update",
		logSQL = true,
		flushAtRequestEnd = false,
		autoManageSession = false,
		eventHandling = true,
		eventHandler = "model.ORMEventHandler",
		cfclocation=["/model/"],
		searchenabled = true,
		search = {
			autoindex = false,
			language = "English",
			indexDir = "/includes/cache/ormindex"
		}
	};
	this.ormsettings.secondarycacheenabled = false;

	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new Coldbox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY);
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart(String targetPage){
		if(structKeyExists(url,"ormreload")) {
			ORMReload();
		}
		// Bootstrap Reinit
		if( not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit() ){
			lock name="coldbox.bootstrap_#this.name#" type="exclusive" timeout="5" throwonTimeout=true{
				structDelete(application,"cbBootStrap");
				application.cbBootstrap = new ColdBox(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			}
		}

		// ColdBox Reload Checks
		application.cbBootStrap.reloadChecks();

		//Process a ColdBox request only
		if( findNoCase('index.cfm',listLast(arguments.targetPage,"/")) ){
			application.cbBootStrap.processColdBoxRequest();
		}

		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd(struct sessionScope, struct appScope){
		arguments.appScope.cbBootStrap.onSessionEnd(argumentCollection=arguments);
	}

	public boolean function onMissingTemplate(template){
		return application.cbBootstrap.onMissingTemplate(argumentCollection=arguments);
	}
	
}