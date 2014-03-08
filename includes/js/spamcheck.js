$(function() { 
	$.ajaxSetup({
		beforeSend: function (xhr) {
			xhr.setRequestHeader("apiKey",$('body').data('user').apikey);
		}
	});
});