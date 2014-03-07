import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(
		Any	controller	Inject="coldbox"
	){
		variables.controller	= arguments.controller;
		super.init("Submission", "Submission.query.cache", true );
		return this;
	}


	public void function submit(
		Required	String		EventType,
		Required	Log			Log
	) {
		
		var Submission = super.new();
		
		Submission.setEventType( arguments.EventType );
		Submission.setLog( arguments.Log );
		arguments.Log.addSubmission( Submission );
		
		save( Submission );
		
		var interceptData = {
			EventType	= arguments.EventType,
			Log			= arguments.Log,
			Submission	= Submission
		};
		
		
		variables.controller.getInterceptorService().processState( state='postSaveSubmission', interceptData=interceptData );
		
	}

	
	public void function save(Required Submission) {
		super.save(arguments.Submission);
	}
	
}