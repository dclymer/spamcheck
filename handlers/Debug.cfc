﻿component output="false" singleton{	public void function index(event,rc,prc){		var PostbackService = getModel('PostbackService');		var LogService = getModel('LogService');				var Log = LogService.get(72);				var r = PostbackService.postback(eventType='submitSpam',Log=Log);		try {			writedump(r);		} catch(any e) {			writedump(e);
		}		abort;	}	public void function testsubmit(event,rc,prc) {		var LogService = getModel('LogService');		var SpamCheckService = getModel('SpamCheckService');		var submissions = [];		arrayAppend(submissions,{Log=LogService.get(72),type='spam'});		arrayAppend(submissions,{Log=LogService.get(71),type='spam'});		arrayAppend(submissions,{Log=LogService.get(70),type='spam'});						SpamCheckService.submit( Submissions=Submissions );		abort;
	}	public void function lookupComment(event,rc,prc) {		var Comment = getModel('CommentService').get(event.getValue('comment_id',97));		var r = getModel('LookupService').lookupComment(Comment);		try {			writedump(r);		} catch(any e) {			writedump(e);
		}		abort;
	}		public void function postbackurltest(event,rc,prc) {		var c = '';		savecontent variable="c" {writedump(rc)};		FileWrite(expandPath('/spamcheck/includes/cache/postbacklogs/#CreateUUID()#.html'),c);		event.renderData(data=true,type='json');
	}}