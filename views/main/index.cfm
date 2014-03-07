<cfoutput>
</cfoutput>


<cfscript>
	/*
	s = getModel('SigmaService@Sigma');
	
	ap = getModel('AppService').get(34);
	
	writedump(s.init(ap).isReady());
	*/
	
	//t = getModel('tests');
	//writedump(t)
	
	
	ls = getModel('logservice');
	
	/*
	logs = entityload('Log');
	for(var l in logs) {
		ls.reCalculateSpamConfidence(l);
		ls.save(l);
	}
	*/
	/*
	l = ls.get(104);
	writedump(ls.reCalculateSpamConfidence(l));
	abort;
	*/
	
	/*
	l = ls.get(88);
	writedump(ls.reCalculateSpamConfidence(l));
	*/
	
	
	/*
	for(l in EntityLoad('Log')) {
		ls.save(l);
	}
	abort;
	
	*/
	/*
	l = ls.get(88);
	writedump(ls.reCalculateSpamConfidence(l));
	abort;
	*/
	
	
	//writedump(application);
	
	function callLogSave(boolean testing=false) {

		var oHTTP = new http(
			url			= 'https://spamcheck.sigmaprojects.org/api/v1/spam/check', 
			timeout		= 300,
			method		= 'post'
		);

		var params = getParams(arguments.testing);
		
		params['postbackURL']	= 'https://spamcheck.sigmaprojects.org/debug/postbackurltest';

		var pbd = {};
		pbd['foo']	 = 'oob';
		pbd['bar']	 = 'rab';
		pbd['obj']	 = {foobar='raboof'};
		pbd['arr']	 = [1,2,3,4];
		params['PostbackData']	= serializeJson(pbd);
		
		/**/
		// add params
		if( !structIsEmpty( params ) ){
			for( var thisParam in params ){
				oHTTP.addParam( name=thisParam,  type="formfield", value=params[ thisParam ] );
			}
		}
		
		var prefix = oHTTP.send().getPrefix();
		return prefix;
	}

	
	r = callLogSave(true);
	try {
		writedump( deserializeJson(r.filecontent) );
	} catch(any e) {
		writeoutput('<br />');
		writeoutput('Could not deserialize');
		writeoutput('<br />');
	}
	/*
	*/
	/*
	*/
	
	/*
	*/
		/*
	writedump(r);
	*/	

	public struct function getParams(boolean testing=false) {
		if( arguments.testing ) {
			var data = {
				author			= 'viagra-test-123',
				authorEmail		= 'viagra-test-123',
				authorURL		= 'viagra-test-123',
				content			= 'BUY VIAGRA NOW MAKE MONEY FROM HOME viagra-test-123',
				permalink		= 'viagra-test-123',
				blogURL			= 'viagra-test-123',
				user_ip			= '127.1.80.1',
				user_agent		= 'viagra-test-123',
				referrer		= 'viagra-test-123',
				commentType		= 'comment'
			};
		} else {
			var data = {
				author			= 'Mike Griffen',
				authorEmail		= 'MikeGriffen@gmail.com',
				authorURL		= '',
				content			= 'On your second question, yes. If a key passed to populateFromStruct matches a property in the target entity, the populator will try to compose the relationship represented by the key.',
				permalink		= 'http://www.truestreets.com/comments/',
				blogURL			= 'http://www.truestreets.com/comments/',
				user_ip			= '142.136.14.217',
				user_agent		= 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:27.0) Gecko/20100101 Firefox/27.0',
				referrer		= 'http://www.truestreets.com/',
				commentType		= 'comment'
			};
		}
		return data;
	}

	function testit(boolean testing=false) {
		ls = getModel('logService');
	
		if(testing) {
			l = ls.log(
				author			= 'viagra-test-123',
				authorEmail		= 'viagra-test-123',
				authorURL		= 'viagra-test-123',
				content			= 'BUY VIAGRA NOW MAKE MONEY FROM HOME viagra-test-123',
				permalink		= 'viagra-test-123',
				blogURL			= 'viagra-test-123',
				user_ip			= '127.1.80.1',
				user_agent		= 'viagra-test-123',
				referrer		= 'viagra-test-123',
				commentType		= 'comment'
			);
		} else {
			l = ls.log(
				author			= '',
				authorEmail		= '',
				authorURL		= '',
				content			= 'On your second question, yes. If a key passed to populateFromStruct matches a property in the target entity, the populator will try to compose the relationship represented by the key.',
				permalink		= '',
				blogURL			= '',
				user_ip			= '127.0.0.1',
				user_agent		= '',
				referrer		= '',
				commentType		= 'comment'
			);
		}
		writedump(l);
	}
</cfscript>