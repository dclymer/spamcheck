component output="false" singleton{	public void function index(event,rc,prc){		var SettingService = getModel('SettingService');		rc.settings = SettingService.list(orderBy='category asc, key asc');		event.setView("manage/settings/index");	}	public void function save(event,rc,prc) {		if( structKeyExists(rc,'settings') && isArray(rc.settings) ) {			for(var data in rc.settings) {				getModel('SettingService').setValue( argumentCollection=data );
			}
		}		event.renderData(data=true,type='json');
	}		public void function delete(event,rc,prc) {		var SettingService = getModel('SettingService');		if( len(trim(Event.getValue('key',''))) ) {			SettingService.delete( SettingService.get(rc.key) );		}		event.renderData(data=true,type='json');
	}	}