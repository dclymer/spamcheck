component output="false" extends="coldbox.system.Interceptor" hint="Listener for spamcheck services." {
	
	public void function configure() {
		//variables.LookupService = getModel("LookupService");
		//setProperty('ConfigurationTime', now() );
	}
	
	public void function postSubmitSpam(Required Event, interceptData) {
		writeLog(text="postSubmitSpam fired log## #interceptData['Log'].getID()#",file="SpamCheck");
		interceptData['EventType'] = 'Spam';
		var SubmissionService = controller.getWireBox().getInstance("SubmissionService");
		SubmissionService.submit( argumentCollection=interceptData );
	}
	
	public void function postSubmitHam(Required Event, interceptData) {
		writeLog(text="postSubmitHam fired log## #interceptData['Log'].getID()#",file="SpamCheck");
		interceptData['EventType'] = 'Ham';
		var SubmissionService = controller.getWireBox().getInstance("SubmissionService");
		SubmissionService.submit( argumentCollection=interceptData );
	}

	public void function postSaveSubmission(Required Event, interceptData) {
		writeLog(text="postSaveSubmission fired log## #interceptData['Log'].getID()#",file="SpamCheck");
		var PostbackService = controller.getWireBox().getInstance("PostbackService");
		PostbackService.postback( argumentCollection=interceptData );
	}

	public void function postbackSaved(Required EVent, interceptData) {
		
	}
}