function LogInfo(){
	this.Init();
};
LogInfo.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = '/log';
	
	$('.loginfo-win').on('click',
		function( objEvent ) {
			var $this = $(this);
			var id = $this.data('id');
			objSelf.showLogInfoWin( id );
			objEvent.preventDefault();
			return( false );
		}
	);


};

LogInfo.prototype.showLogInfoWin = function( id ) {
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
LogInfo.prototype.saveDone = function(data, textStatus, jqXHR, jForm) {
	var objSelf = this;
	jForm.find('div.has-error').removeClass('has-error');
	jForm.find('ul.errors').empty();

	if( data.hasOwnProperty('user') ) {
		window.location = '/';
	} else {
		
		for (var key in data.errors) {
			var obj = data[key];
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

	}

};
LogInfo.prototype.saveFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Saving');
};

$(function() { new LogInfo(); });



