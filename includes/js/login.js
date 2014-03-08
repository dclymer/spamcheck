function Login(){
	this.Init();
};
Login.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = $('form#login-form').data('endpoint');
	
	$('form#login-form').on('submit',
		function( objEvent ) {
			var $this = $(this);
			objSelf.send( $this );
			objEvent.preventDefault();
			return( false );
		}
	);

	$('ul.navbar-nav li').on('click', 'a[title="Logout"]',
		function( objEvent ) {
			var $this = $(this);
			objSelf.logout( $this );
			objEvent.preventDefault();
			return( false );
		}
	);

	$('form#login-form').on('click', 'button.register',
		function( objEvent ) {
			var $this = $(this);
			window.location = '/manage/register';
			return( false );
		}
	);	

};

Login.prototype.send = function( jForm ) {
	var objSelf = this;
	jForm.addClass('unselectable');
	var data = {
		email: jForm.find('input[name="email"]').val(),
		password: jForm.find('input[name="password"]').val()
	};
	var req = $.ajax({
		type: 'POST',
		url: objSelf.endpoint + '.login',
		data: JSON.stringify(data),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.sendDone(data, textStatus, jqXHR, jForm)
	})
	.fail(objSelf.sendFail);
	return;
};
Login.prototype.sendDone = function(data, textStatus, jqXHR, jForm) {
	var objSelf = this;
	jForm.find('div.has-error').removeClass('has-error');
	jForm.removeClass('unselectable');

	if( data ) {
		jForm.parent().hide();
		$('ul.navbar-nav li a[title="Logout"]').parent().show();
		$('ul.navbar-nav li.loginrequired').show();
	} else {
		jForm.find('div.form-group').addClass('has-error');
	}

};
Login.prototype.sendFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error logging in');
};


Login.prototype.logout = function( jElm ) {
	var objSelf = this;
	var req = $.ajax({
		type: 'POST',
		url: objSelf.endpoint + '.logout',
		data: JSON.stringify({}),
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.logoutDone(data, textStatus, jqXHR, jElm)
	})
	.fail(objSelf.logoutFail);
	return;
};
Login.prototype.logoutDone = function(data, textStatus, jqXHR, jElm) {
	var objSelf = this;
	$('form#login-form').parent().show();
	jElm.parent().hide();
};
Login.prototype.logoutFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error logging out');
};

$(function() { new Login(); });



