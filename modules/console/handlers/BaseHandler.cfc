component output="false" {

	function preHandler(event,rc,prc){
		
		// module root
		rc.root = event.getModuleRoot();
		// exit handlers
		/*
		rc.xehHome 			= "console/home";
		rc.xehRelax			= "console/home.relax";
		rc.xehRelaxer		= "console/home.relaxer";
		rc.xehRelaxUpdates	= "console/Home.checkUpdates";
		rc.xehDSLDocs		= "console/home.DSLDocs";
		rc.xehLogViewer 	= "console/logs";
		rc.xehLogHelp		= "console/logs.help";
		*/
		rc.xehHome 			= "console/home.relaxer";
		rc.xehRelax			= "console/home.relaxer";
		rc.xehRelaxer		= "console/home.relaxer";
		rc.xehRelaxUpdates	= "console/home.relaxer";
		rc.xehDSLDocs		= "console/home.DSLDocs";
		rc.xehLogViewer 	= "console/logs";
		rc.xehLogHelp		= "console/logs.help";
	}

}