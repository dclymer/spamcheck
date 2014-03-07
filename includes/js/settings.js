function Settings(){
	this.Init();
};
Settings.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = $('table#settings-admin').data('endpoint');
	
	$('table#settings-admin').on('click','button#save',
		function( objEvent ) {
			var inputs = $(this).parents('table').find('input[name="value"]');
			var settingsArr = [];
			for(var i=0; i < inputs.length; i++) {
				var input = $(inputs[i]);
				settingsArr.push({
					key		: input.data('key'),
					value	: input.val()
				});
			};
			objSelf.saveSettings( settingsArr );
			objEvent.preventDefault();
			return( false );
		}
	);

	$('table#settings-admin').on('click','a.delete',
		function( objEvent ) {
			objSelf.deleteSettings( $(this) );
			objEvent.preventDefault();
			return( false );
		}
	);

};

Settings.prototype.saveSettings = function( settingsArr ) {
	var objSelf = this;
	var req = $.ajax({
		type: 'POST',
		url: objSelf.endpoint + '.save',
		data: JSON.stringify({
			settings: settingsArr
		}),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done(objSelf.saveSettingsDone)
	.fail(objSelf.saveSettingsFail);
	return;
};
Settings.prototype.saveSettingsDone = function(data, textStatus, jqXHR) {
};
Settings.prototype.saveSettingsFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Saving');
};

Settings.prototype.deleteSettings = function( jElm ) {
	var objSelf = this;
	var req = $.ajax({
		type: 'POST',
		url: objSelf.endpoint + '.delete',
		data: JSON.stringify({
			key: jElm.data('key')
		}),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done(function(data, textStatus, jqXHR){
		objSelf.deleteSettingsDone(data, textStatus, jqXHR, jElm)
	})
	.fail(objSelf.deleteSettingsFail);
	return;
};
Settings.prototype.deleteSettingsDone = function(data, textStatus, jqXHR, jElm) {
	jElm.parents('tr').fadeOut();
};
Settings.prototype.deleteSettingsFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Deleting');
};


$(function() { new Settings(); });



