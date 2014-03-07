function Lookup(){
	this.Init();
};
Lookup.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = '/api/v1/lookup';
	
	$('body').on('click', '.lookup-comment',
		function( objEvent ) {
			var $this = $(this);
			var id = $this.data('id');
			objSelf.lookupComment( id );
			objEvent.preventDefault();
			return( false );
		}
	);


};

Lookup.prototype.lookupComment = function( id ) {
	var objSelf = this;
	var req = $.ajax({
		type: 'GET',
		url: objSelf.endpoint + '/lookup/' + id,
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.lookupCommentDone(data, textStatus, jqXHR )
	})
	.fail(objSelf.lookupCommentFail);
	return;
};
Lookup.prototype.lookupCommentDone = function(data, textStatus, jqXHR) {
	var objSelf = this;
	
	if( data.hasOwnProperty('code') && data.code === 200 ) {
		
		var target = $('hr.lookups-spacer:first');
		
		for(var i=0; i < data.results.length; i++) {
			
			var item = data.results[i];
			
			var breaker = $('<hr class="lookups-spacer" />');
			breaker.insertAfter(target).hide().slideDown("slow");

			var dt4 = $('<dt>Score Weight</dt>');
			var dd4 = $('<dd></dd').text(item.scoreweight);
			dd4.insertAfter(target).hide().slideDown("slow");
			dt4.insertAfter(target).hide().slideDown("slow");

			var dt3 = $('<dt>Spam</dt>');
			var dd3 = $('<dd></dd').text(item.isspam);
			dd3.insertAfter(target).hide().slideDown("slow");
			dt3.insertAfter(target).hide().slideDown("slow");
			
			var dt2 = $('<dt>Service</dt>');
			var dd2 = $('<dd></dd').text(item.service);
			dd2.insertAfter(target).hide().slideDown("slow");
			dt2.insertAfter(target).hide().slideDown("slow");
			
			var created = moment(item.created).format('M/D/YY h:m A');
			var dt1 = $('<dt>Date</dt>');
			var dd1 = $('<dd></dd').text(created);
			dd1.insertAfter(target).hide().slideDown("slow");
			dt1.insertAfter(target).hide().slideDown("slow");
		}
	}
};
Lookup.prototype.lookupCommentFail = function(jqXHR, textStatus, errorThrown) {
	alert('Error Looking up');
};

$(function() { new Lookup(); });



