function Register(){
	this.Init();
};
Register.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = $('form#register').data('endpoint');
	
	$('form#register').on('submit',
		function( objEvent ) {
			var $this = $(this);
			objSelf.save( $this );
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

Register.prototype.save = function( jForm ) {
	var objSelf = this;
	var data = {
		email: jForm.find('input[name="email"]').val(),
		password: jForm.find('input[name="password"]').val(),
		verifypassword: jForm.find('input[name="verifypassword"]').val(),
	};
	var req = $.ajax({
		type: 'POST',
		url: objSelf.endpoint + '.save',
		data: JSON.stringify(data),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.saveDone(data, textStatus, jqXHR, jForm)
	})
	.fail(objSelf.saveFail);
	return;
};
Register.prototype.saveDone = function(data, textStatus, jqXHR, jForm) {
	var objSelf = this;
	jForm.find('div.has-error').removeClass('has-error');
	jForm.find('ul.errors').empty();

	if( data.hasOwnProperty('user') ) {
		window.location = '/';
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
		
		/*
		for (var key in data.errors) {
			var obj = data.errors[key];
			for (var prop in obj) {
				if(obj.hasOwnProperty(prop)){
					var formElm = $('div#'+prop);
					formElm.addClass('has-error');
					for(var i in obj[prop]) {
						var entry = obj[prop][i];
						if( entry.hasOwnProperty('message') ) {
							var msghtml = $('<li></li>').text( entry.message );
							formElm.find( 'ul.errors' ).append(msghtml);
						}
					}
				}
			}
		}
		*/
	}

};
Register.prototype.saveFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Saving');
};

$(function() { new Register(); });



