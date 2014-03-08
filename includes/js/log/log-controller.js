function LogController(){
	this.Init();
};
LogController.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = '/api/v1/spam';
	
	
	$('#togglehams').on('click',
		function( objEvent ) {
			var $this = $(this);
			var radios = $('input[type="radio"][value="ham"]');
			var names = {};
			radios.each(function() { names[$(this).attr('name')] = true; });
		    var count = 0;
		    $.each(names, function() { count++; });
		    if ( $('input[type="radio"][value="ham"]:checked').length === count) {
		    	radios.prop("checked", false);
		    } else {
		    	radios.prop("checked", true);
		    };
			objEvent.preventDefault();
			return( false );
		}
	);
	$('#togglespams').on('click',
		function( objEvent ) {
			var $this = $(this);
			var radios = $('input[type="radio"][value="spam"]');
			var names = {};
			radios.each(function() { names[$(this).attr('name')] = true; });
	    	var count = 0;
	    	$.each(names, function() { count++; });
	    	if ( $('input[type="radio"][value="spam"]:checked').length === count) {
	    		radios.prop("checked", false);
	    	} else {
	    		radios.prop("checked", true);
	    	};
			objEvent.preventDefault();
			return( false );
		}
	);
	
	$('button#submittypes').on('click',
		function( objEvent ) {
			var $this = $(this);
			var radios = $('input[type="radio"][class="submittype"]:checked');
			objSelf.submitControls( radios );
			objEvent.preventDefault();
			return( false );
		}
	);


};

LogController.prototype.submitControls = function( jElms ) {
	var objSelf = this;
	var submissions = [];
	
	jElms.each(function() {
		var e = $(this);
		submissions.push({
			id:		e.data('id'),
			type:	e.val()
		});
		e.parents('tr').addClass('unselectable');
	});

	var req = $.ajax({
		type: 'POST',
		url: objSelf.endpoint + '/submit',
		data: JSON.stringify({
			submissions: submissions
		}), 
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.submitControlsDone(data, textStatus, jqXHR, jElms )
	})
	.fail(objSelf.submitControlsFail);
	return;
};
LogController.prototype.submitControlsDone = function(data, textStatus, jqXHR, jElms) {
	var objSelf = this;
	if( data.hasOwnProperty('code') && data.code === 200 ) {
		jElms.each(function() {
			var e = $(this);
			objSelf.refreshTR(
				e.data('id'),
				e.parents('tr')
			);
			e.parents('tr').removeClass('unselectable');
		});
	};
};
LogController.prototype.submitControlsFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error submitting');
};




LogController.prototype.refreshTR = function( id, target ) {
	var objSelf = this;

	var req = $.ajax({
		type: 'get',
		url: '/log/log_tr/'+id,
		dataType: 'html',
		contentType: 'text/plain; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.refreshTRDone(data, textStatus, jqXHR, target )
	})
	.fail(objSelf.refreshTRFail);
	return;
};
LogController.prototype.refreshTRDone = function(data, textStatus, jqXHR, target) {
	var objSelf = this;
	//console.log(target.html());
	console.log( $(data).html() );
	//target.fadeOut().replaceWith($(data).fadeIn());
	target.fadeOut();
	target.html( $(data).html() );
	target.fadeIn();
};
LogController.prototype.refreshTRFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error refreshing');
};







$(function() { new LogController(); });



