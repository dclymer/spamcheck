component output="false" extends="coldbox.system.Interceptor" hint="Listener for spamcheck lookup related modules." {
	
	public void function configure() {
		//variables.LookupService = getModel("LookupService");
		//setProperty('ConfigurationTime', now() );
	}
	
	public void function SpamCheckModuleLoaded(Required Event, interceptData) {
		//var moduleName = Reverse(listGetAt(reverse( md.name ),'2','.'))
		/*
		if( structKeyexists(interceptData,'tt') ) {
			writedump(interceptData.m);
			var md = getMetaData(interceptData.m);
			writedump( Reverse(listGetAt(reverse( md.name ),'2','.')) );
			abort;
		}
		*/
		var SpamCheckService = controller.getWireBox().getInstance("SpamCheckService");
		SpamCheckService.addService( interceptData );
		
		registerModuleSettings(argumentCollection=arguments);
		writeLog(text="module loaded fired",file="SpamCheck");
		//writedump( interceptData );
		//abort;
	}
	
	public void function SpamCheckModuleUnLoaded(Required Event, interceptData) {
		var SpamCheckService = controller.getWireBox().getInstance("SpamCheckService");
		SpamCheckService.removeService( interceptData );
		writeLog(text="module unloaded fired",file="SpamCheck");
		//writedump( interceptData );
		//abort;
	}
	
	public void function registerModuleSettings(Required Event, interceptData) {
		//var moduleName = Reverse(listGetAt(reverse( getMetaData(arguments.interceptData).name ),'2','.'));
		var moduleName = listGetAt(getMetaData(arguments.interceptData).fullname,'2','.');
		var AppSettingService = controller.getWireBox().getInstance("AppSettingService");
		//writedump(getMetaData(arguments.interceptData));
		//writedump(moduleName);
		//writedump(arguments);
		//abort;
		AppSettingService.registermodule( moduleName );
	}
	           
}