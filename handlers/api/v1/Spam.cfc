﻿component output="false" extends="baseAPI" singleton {	this.Event_cache_suffix = "";	this.prehandler_only = "";	this.prehandler_except = "";	this.posthandler_only = "";	this.posthandler_except = "";	this.aroundHandler_only = "";	this.aroundHandler_except = "";	this.allowedMethods = {};		function preHandler(event,rc,prc,action){		super.preHandler(argumentCollection=arguments);	}	function postHandler(event,rc,prc,action){		super.postHandler(argumentCollection=arguments);	}	function onError(event,rc,prc,faultAction,exception){		super.onError(argumentCollection=arguments);	}		public void function checkSpam(event,rc,prc) {		var LogService = getModel('LogService');		var Log = LogService.process(argumentCollection=rc);		prc.response.data.results = Log.toJSON();
	}	public void function check(event,rc,prc) {		var LogService = getModel('LogService');		var Log = LogService.process(argumentCollection=rc);		var result = Log.toJSON();		structDelete(result.app,'appsettings');		prc.response.data.results = result;	}	public void function submit(event,rc,prc) {		var LogService = getModel('LogService');		var SpamCheckService = getModel('SpamCheckService');		var acceptTypes = 'ham,spam';		var subs = rc.submissions;				var ValidSubmissions = [];				for(var sub in rc.submissions) {			var Log = LogService.get(sub.id);			var Type = sub.type;			if( !listContainsNoCase(acceptTypes,type,',',false) ) {				throw(message="No submit type specified (type:Ham|Spam)", type="SpamAPI.InvalidType");			}			if( !Log.hasApp() || Log.getApp().getID() neq rc.App.getID() ) {				throw(message="Couldn't find Log###id# that belongs to requested AppID", type="SpamAPI.Unauthorized");			}			arrayAppend(ValidSubmissions,{				type	= Type,				Log		= Log			});		}				prc.response.data.results = SpamCheckService.submit( App=rc.App, Submissions=ValidSubmissions );	}		public void function submitSpam(event,rc,prc) {		var LogService = getModel('LogService');		var SpamCheckService = getModel('SpamCheckService');		var ids = listToArray(event.getValue('id',''),',',false);		var Logs = LogService.getAll( ids );		for(var Log in Logs) {			if( !Log.hasApp() || Log.getApp().getID() neq rc.App.getID() ) {				throw(message="Couldn't find Log###id# that belongs to requested AppID", type="SpamAPI.Unauthorized");			}		}		prc.response.data.results = SpamCheckService.submitSpam( Logs=Logs );
	}	public void function submitHam(event,rc,prc) {		var LogService = getModel('LogService');		var SpamCheckService = getModel('SpamCheckService');		var ids = listToArray(event.getValue('id',''),',',false);		var Logs = LogService.getAll( ids );		for(var Log in Logs) {			if( !Log.hasApp() || Log.getApp().getID() neq rc.App.getID() ) {				throw(message="Couldn't find Log###id# that belongs to requested AppID", type="SpamAPI.Unauthorized");			}
		}		prc.response.data.results = SpamCheckService.submitHam( Logs=Logs );	}}