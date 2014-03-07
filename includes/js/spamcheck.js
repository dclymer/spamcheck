function getReadableFileSizeString(fileSizeInBytes) {
    var i = -1;
    var byteUnits = [' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
    do {
        fileSizeInBytes = fileSizeInBytes / 1024;
        i++;
    } while (fileSizeInBytes > 1024);

    return Math.max(fileSizeInBytes, 0.1).toFixed(1) + byteUnits[i];
};

jQuery(document).ready(function(){
	jQuery('.filesize').each(
		function(i) {
			var elm = $(this);
			var HRFS = getReadableFileSizeString( elm.data('bytes') );
			elm.text(HRFS);
			//console.log( index + ": " + $( this ).text() );
		}
	);
});