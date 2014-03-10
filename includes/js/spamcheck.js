$(function() { 
	$.ajaxSetup({
		beforeSend: function (xhr) {
			try {
				xhr.setRequestHeader("apiKey",$('body').data('user').apikey);
			} catch(e) {
				console.log(e);
			}
		}
	});
});