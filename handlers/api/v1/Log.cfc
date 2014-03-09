﻿component output="false" extends="baseAPI" singleton {	this.Event_cache_suffix = "";	this.prehandler_only = "";	this.prehandler_except = "";	this.posthandler_only = "";	this.posthandler_except = "";	this.aroundHandler_only = "";	this.aroundHandler_except = "";	this.allowedMethods = {};		function preHandler(event,rc,prc,action){		super.preHandler(argumentCollection=arguments);	}	function postHandler(event,rc,prc,action){		super.postHandler(argumentCollection=arguments);	}	function onError(event,rc,prc,faultAction,exception){		super.onError(argumentCollection=arguments);	}		public void function get(event,rc,prc) {		var LogService = getModel('LogService');		var id = event.getValue('id',0);		var Log = LogService.get( id );		if( Log.hasApp() && Log.getApp().hasUser() && Log.getApp().getUser().getID() eq rc.User.getID() ) {			prc.response.data.results = Log.toJSON();
		} else {			throw(message="Couldn't find Log###id# that belongs to requested apiKey", type="LogAPI.Unauthorized");
		}
	}}