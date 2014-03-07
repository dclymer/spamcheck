<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Description :
	Base handler
----------------------------------------------------------------------->
<cfcomponent output="false">
<cfscript>

	function preHandler(event){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		
		// module root
		rc.root = event.getModuleRoot();
		// exit handlers
		rc.xehHome 			= "logbox/logs";
		rc.xehLogViewer 	= "logbox/logs";
		rc.xehLogHelp		= "logbox/logs.help";
	}

</cfscript>
</cfcomponent>