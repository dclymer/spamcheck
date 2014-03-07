<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Description :
	Relax Module Configuration
----------------------------------------------------------------------->
<cfcomponent output="false" hint="Relaxed Configuration">
<cfscript>
	// Module Properties
	this.title 				= "LogBox";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "RESTful Tools For Lazy Experts";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "logbox";
	
	function configure(){
		
		// Relax Configuration Settings
		settings = {
			// Relax Version: DO NOT ALTER
			version = this.version,
			// logbox integration information needed for log viewer to work
			// this means that it can read tables that are written using the logbox's DB Appender.
			logboxLogs = {
				// THE CF DATASOURCE NAME
				datasource = "spamcheck",
				// THE DB TO USE FOR LOGS, AVAILABLE ADAPTERS ARE: mysql, mssql, postgres, oracle
				adapter = "mysql",
				// THE TABLE WHERE THE LOGS ARE
				table 	= "api_logs",
				// PAGING MAX ROWS
				maxRows = 50,
				// PAGING CARROUSEL BANDGAP
				bandGap = 3
			}
		};
		
		// Layout Settings
		layoutSettings = { defaultLayout = "logbox.cfm" };
		
		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="logs",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}	
		];			
		
		
		// RelaxLogs Bindings
		binder.map("logService@logboxlogs").to("#moduleMapping#.model.logbox.LogService");
		binder.map("MSSQL_DAO@logboxlogs").to("#moduleMapping#.model.logbox.MSSQL_DAO");
		binder.map("MYSQL_DAO@logboxlogs").to("#moduleMapping#.model.logbox.MYSQL_DAO");
		binder.map("ORACLE_DAO@logboxlogs").to("#moduleMapping#.model.logbox.ORACLE_DAO");
		binder.map("POSTGRES_DAO@logboxlogs").to("#moduleMapping#.model.logbox.POSTGRES_DAO");
			
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){	
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}	
	
	
	function preProcess(event,interceptData) eventPattern="^logbox.*"{
	}
	
	
	function loadDefaultAPI(){
	}
</cfscript>
</cfcomponent>