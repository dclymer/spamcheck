import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="SpamCheckService" inject="SpamCheckService";
	property name="LookupService" inject="LookupService";
	property name="CommentService" inject="CommentService";
	property name="PostbackDataService" inject="PostbackDataService";
	
	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		super.init("Log", "Log.query.cache", true );
		return this;
	}


	public any function getByUserIDLogID(
		Required	Numeric		userId,
		Required	Numeric		logId,
					Boolean		retrunObj	= true
	) {
		var Log = super.get(arguments.logId);
		if( !IsNull(Log) && Log.hasApp() && Log.getApp().hasUser() && Log.getApp().getUser().getID() eq arguments.userId ) {
			return Log;
		} else if( arguments.retrunObj ) {
			return super.new();
		}
	}




	public Log function process(
		Required	App			App,
					Any			PostbackData	= ''
	) {
		
		transaction action="begin" {
			
			try {
				var Log = newLog(argumentCollection=arguments);
				
				if( arguments.App.hasPostbackURL() ) {
					Log.setPostbackURL( arguments.PostbackURL );
				}
		
				var PostbackData = PostbackDataService.create(arguments.PostbackData);
				Log.setPostbackData( PostbackData );
				PostbackData.setLog(Log);
		
				save(Log);
				
				transaction action="commit";
				
			} catch(any e) {
				transaction action="rollback";
    			rethrow;
			}
			
		}	
		
		return Log;
	}

	public Log function newLog(
		Required	App		App,
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	) {
		var Log = super.new();
		Log.setApp(arguments.App);
		var Comment = CommentService.new();
		super.populate(target=Comment, memento=arguments);
		CommentService.save( Comment );
		Log.setComment(Comment);
		Comment.setLog(Log);
		LookupService.lookupLog( Log );
		save( Log );
		return Log;
	}
	
	public void function reProcessLog(
		Required	Log		Log
	) {
		LookupService.lookup( Log );
		save( Log );
		EntityReload(Log);
	}
	

	public void function save(Required Log) {
		reCalculateSpamConfidence(arguments.Log);
		super.save(arguments.Log);
	}



	public void function reCalculateSpamConfidence(
		Required	Log		Log
	) {
		/* broken formula
		var SpamConfidence = 0;
		var HamConfidence = 0;

		for(var Lookup in arguments.Log.getLookups()) {
			if( Lookup.getIsSpam() ) {
				SpamConfidence = SpamConfidence+Lookup.getScoreWeight();
			} else {
				HamConfidence = HamConfidence+Lookup.getScoreWeight();
			}
		}
		
		var Confidence = ( HamConfidence-SpamConfidence )+.001 / arrayLen(arguments.Log.getLookups()) * 10;
		if( Confidence lt 0 ) {
			Confidence = Confidence+100;
		}
		if( Confidence gt 100 ) {
			Confidence = 100;
		}
		Confidence = Round(Confidence);
		arguments.Log.setSpamConfidence( Confidence );
		*/
		
		
		
		/*
		//simple, easy, fast and 'works'
		var TotalWeight = 0;
		var SpamVote = 0;

		for(var Lookup in arguments.Log.getLookups()) {
			TotalWeight = TotalWeight+Lookup.getScoreWeight();
			if( Lookup.getIsSpam() ) {
				SpamVote = SpamVote+Lookup.getScoreWeight();
			}
		}
		
		if( SpamVote gt 0 ) {
			var Confidence = ( SpamVote / TotalWeight ) * 100;
		} else {
			var Confidence = 0;
		}

		Confidence = Round(Confidence);
		arguments.Log.setSpamConfidence( Confidence );
		*/

		
		// new formula from aj@sigmaprojects.org to better account for weighted scores, its a little offset but may be more accurate 
		var SpamVotes = [];
		var HamVotes = [];

		for(var Lookup in arguments.Log.getLookups()) {
			arrayAppend(( Lookup.getIsSpam() ? SpamVotes : HamVotes ),Lookup.getScoreWeight());
		}
		
		if( arrayLen(SpamVotes) lte arrayLen(HamVotes) ) { 
     		var Confidence = arrayAvg(SpamVotes) * (arrayLen(SpamVotes)/arrayLen(HamVotes)) - arrayAvg(HamVotes);
		}

		if( arrayLen(HamVotes) lte arrayLen(SpamVotes) ) { 
     		var Confidence = arrayAvg(SpamVotes) - arrayAvg(HamVotes) * ( arrayLen(HamVotes)/arrayLen(SpamVotes) );
		}
		
		Confidence = (Confidence+10)*5;

		if( Confidence gt 100 ) { Confidence = 100; }
		if( Confidence lt 0 ) { Confidence = 0; }
		arguments.Log.setSpamConfidence( Confidence );
	}

}
