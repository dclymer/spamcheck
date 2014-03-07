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

	public struct function search(
		Any			author,
		Any			authorEmail,
		Any			authorURL,
		Any			content,
		Any			permalink,
		Any			blogURL,
		Any			user_ip,
		Any			user_agent,
		Any			referrer,
		Any			commentType,
		Any			user_id,
		Any			app_id,
		Numeric		Max					= 50,
		Numeric		Offset				= 0,
		Numeric		Timeout				= 0,
		String		sortOrder			= 'created desc',
		Boolean		ignoreCase			= true,
		Boolean		asQuery				= false
	) {
		var results = {};
		results['count'] = 0;
		results['entries'] = [];
		var c = newCriteria();
		var r = c.restrictions;
		
		var Aliases = [];

		if( structKeyExists(arguments,'Keyword') ) {
			var KeywordArray = ( IsArray(arguments.Keyword) ? arguments.Keyword : listToArray(arguments.Keyword) );
			
			for(var RawWord in KeywordArray) {
				var Word = trim(RawWord);
				if( Len(Word) gt 1 ) {
					var NameorCriteria = [];
					
					if( !arrayContains(Aliases,'Comment') ) { arrayAppend(Aliases,'Comment'); c.createAlias( 'Comment', 'c'); }
					
					ArrayAppend(NameorCriteria, r.ilike( 'c.author', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.authoremail', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.authorurl', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.content', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.permalink', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.blogurl', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.user_ip', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.user_agent', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.referrer', '%#explodeKeyword(Word)#%' ));
					ArrayAppend(NameorCriteria, r.ilike( 'c.commenttype', '%#explodeKeyword(Word)#%' ));

					// append disjunction to main criteria
					c.disjunction( NameorCriteria );
				}
			}
		}

		var _UserIDs = extractParamArray(arguments,'user_id');
		if( arrayLen(_UserIDs) ) {
			if( !arrayContains(Aliases,'App.User') ) { arrayAppend(Aliases,'App.User'); c.createAlias( 'App.User', 'au'); }
			c.isin('au.id', c.convertIDValueToJavaType( propertyName="au.id", value=_UserIDs ) );
		}
		
		var _AppIDs = extractParamArray(arguments,'app_id');
		if( arrayLen(_AppIDs) ) {
			if( !arrayContains(Aliases,'App') ) { arrayAppend(Aliases,'App'); c.createAlias( 'App', 'a'); }
			c.isin('a.id', c.convertIDValueToJavaType( propertyName="a.id", value=_AppIDs ) );
		}

		
		if( listContainsNoCase(arguments.sortOrder,'a.') && !arrayContains(Aliases,'App') ) { c.createAlias( 'App', 'a'); }
		if( listContainsNoCase(arguments.sortOrder,'c.') && !arrayContains(Aliases,'Comment') ) { c.createAlias( 'Comment', 'c'); }
		/*
		writedump(c);
		writedump( c.getnativeCriteria().toString() );
		abort;
		*/
		//c.cache(false);
		results['count'] = c.count();
		results['entries'] = c.list(max=max, offset=offset, timeout=timeout, sortOrder=sortOrder, ignoreCase=ignoreCase, asQuery=asQuery);
		return results;
	}



	private string function explodeKeyword(Required String Keyword='') {
		var str = trim(keyword);
		str = replaceNoCase(str,' ','%','all');
		str = replaceNoCase(str,'-','%','all');
		str = replaceNoCase(str,'+','%','all');
		str = replaceNoCase(str,"'",'%','all');
		str = replaceNoCase(str,chr(35),'','all');
		return str;
	}

	private array function extractParamArray(
		Required	Struct	Args,
		Required	String	Key
	) {
		var Values = [];
		if( structKeyExists(Args,Key) ) {
			if( isArray(Args[key]) ) {
				Values = Args[key];
			} else if( isSimpleValue(Args[Key]) ) {
				Values = listToArray(Args[Key]);
			}
		}
		return Values;
	}

}