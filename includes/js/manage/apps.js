function EditApps(){
	this.Init();
};
EditApps.prototype.Init = function(){
	var objSelf = this;
	
	
	$('div#applist').on('click','div.list-group-item',
		function( objEvent ) {
			var App = $(this).data('app');
			var jForm = $('form#saveapp');
			//jForm.parents('div.panel').find('.panel-title').text('Edit App');
			$('#apptabs').find('a:first').text('Edit App');
			$('#apptabs').find('li:last').show();
			jForm.find('input[name="id"]').val( App.id );
			jForm.find('input[name="name"]').val( App.name );
			jForm.find('input[name="postbackurl"]').val( App.postbackurl );
			jForm.find('input[name="appid"]').val( App.appid );
			jForm.find('#appid').show();
			jForm.find('#deleteapp').show();
			
			var jSettingsForm = $('form#savesettings');
			/*
			if( !$(this).data('newappsaved') ) {
				$.each( jSettingsForm.find('input'), function() {
					var input = $(this);
					input.data('section','');
					input.data('category','');
					input.data('description','');
					input.data('key','');
					input.val('');
				});
			}
			*/

			for(var i=0;i < App.appsettings.length; i++) {
				var AppSetting = App.appsettings[i];
				var input = jSettingsForm.find('input[name="'+AppSetting.key+'"][data-section="'+AppSetting.section+'"][data-category="'+AppSetting.category+'"]');
				input.data('section',AppSetting.section);
				input.data('category',AppSetting.category);
				input.data('description',AppSetting.description);
				input.data('key',AppSetting.key);
				input.val(AppSetting.value);
			}

			
			$.each( jSettingsForm.find('input'), function() {
				var input = $(this);
				if( input.val().length == 0 ) {
					input.val( input.data('default') );
				}
			});
			
			$('#apptabs').find('a:first').trigger('click');
			window.location.hash = '#applist';
			window.location.hash = '#editapp';
			objEvent.preventDefault();
			return( false );
		}
	);

	$('form#saveapp').on('submit',
		function( objEvent ) {
			objSelf.saveApp( $(this) );
			objEvent.preventDefault();
			return( false );
		}
	);

	$('form#saveapp').on('reset',
		function( objEvent ) {
			var jForm = $(this);
			//jForm.parents('div.panel').find('.panel-title').text('New App');
			$('#apptabs').find('a:first').text('New App');
			$('#apptabs').find('li:last').hide();
			jForm.find('#appid').hide();
			jForm.find('#deleteapp').hide();
			jForm.find('div.has-error').removeClass('has-error');
			jForm.find('ul.errors').empty();
		}
	);

	$('form#savesettings').on('submit',
		function( objEvent ) {
			objSelf.saveSettings( $(this) );
			objEvent.preventDefault();
			return( false );
		}
	);
	
};

EditApps.prototype.saveApp = function( jForm ) {
	var objSelf = this;
	var data = {};
	$.each(jForm.serializeArray(),function() {
		data[this.name] = this.value;
	});
	$('#editarea').addClass('unselectable');
	var req = $.ajax({
		type: 'POST',
		url: jForm.data('endpoint'),
		data: JSON.stringify(
			data
		),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.saveAppDone(data, textStatus, jqXHR, jForm)
	})
	.fail(objSelf.saveAppFail);
	return;
};
EditApps.prototype.saveAppDone = function(data, textStatus, jqXHR, jForm) {
	var objSelf = this;
	jForm.find('div.has-error').removeClass('has-error');
	jForm.find('ul.errors').empty();
	
	$('#editarea').removeClass('unselectable');
	
	var clearform = true;
	var listgroup = $('div.list-group-item[data-id="'+jForm.find('input[name="id"]').val()+'"]');
	
	if( listgroup.length == 0 && data.hasOwnProperty('app') ) {
		var newlistgroup = $('<div class="list-group-item" style="cursor:pointer;" data-id="'+data.app.id+'"></div>');
		newlistgroup.append( $('<div class="pull-right"></div>') );
		newlistgroup.append( $('<h4 class="list-group-item-heading">'+data.app.name+'</h4>') );
		newlistgroup.append( $('<p class="list-group-item-text pull-left">'+data.app.postbackurl+'</p><br />') );
		newlistgroup.data('app',data.app);
		newlistgroup.data('newappsaved',true);
		$('#applist').append(newlistgroup);
		listgroup = newlistgroup;
		var clearform = false;
	}
	
	if( data.hasOwnProperty('app') ) {
		listgroup.data('id',data.app.id);
		listgroup.data('app',data.app);
		listgroup.find('h4').text(data.app.name);
		listgroup.find('p').text(data.app.postbackurl);
		if( clearform ) {
			jForm.find('button[type="reset"]').trigger('click');
		} else {
			listgroup.trigger('click');
			$('#apptabs li a:last').trigger('click');
			return;
		}
	} else if( data.hasOwnProperty('delete') ) {
		jForm.find('button[type="reset"]').trigger('click');
		listgroup.remove();
	} else {
		
		for (var key in data.errors) {
			var obj = data.errors[key];
			var formElm = $('div#'+key);
			formElm.addClass('has-error');
			for(var i=0; i < obj.length; i++) {
				var innerObj = obj[i];
				if( innerObj.hasOwnProperty('message') ) {
					var msghtml = $('<li></li>').text( innerObj.message );
					formElm.find( 'ul.errors' ).append(msghtml);
				}
			}
		}

	}
};
EditApps.prototype.saveAppFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Saving');
};




EditApps.prototype.saveSettings = function( jForm ) {
	var objSelf = this;
	$('#editarea').addClass('unselectable');
	var inputs = jForm.find('input');
	var settingsArr = [];
	for(var i=0; i < inputs.length; i++) {
		var input = $(inputs[i]);
		settingsArr.push({
			key			: input.data('key'),
			value		: input.val(),
			section		: input.data('section'),
			category	: input.data('category'),
			description	: input.data('description'),
		});
	};
	
	var req = $.ajax({
		type: 'POST',
		url: jForm.data('endpoint'),
		data: JSON.stringify({
			appsettings: settingsArr,
			id: $('form#saveapp').find('input[name="id"]').val()
		}),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.saveSettingsDone(data, textStatus, jqXHR, jForm)
	})
	.fail(objSelf.saveSettingsFail);
	return;
};
EditApps.prototype.saveSettingsDone = function(data, textStatus, jqXHR, jForm) {
	var objSelf = this;
	jForm.find('div.has-error').removeClass('has-error');
	jForm.find('ul.errors').empty();
	$('#editarea').removeClass('unselectable');
	
	if( data.hasOwnProperty('app') ) {

		window.location.reload();
		
	} else {
		
		for (var key in data.errors) {
			var obj = data.errors[key];
			var formElm = $('div#'+key);
			formElm.addClass('has-error');
			for(var i=0; i < obj.length; i++) {
				var innerObj = obj[i];
				if( innerObj.hasOwnProperty('message') ) {
					var msghtml = $('<li></li>').text( innerObj.message );
					formElm.find( 'ul.errors' ).append(msghtml);
				}
			}
		}

	}
};
EditApps.prototype.saveSettingsFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Saving');
};






$(function() { new EditApps(); });



