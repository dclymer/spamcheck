component output="false" singleton {

	function preHandler(event,rc,prc,action){
		// default REST response to JSON
		event.paramValue("format", "json");

		event.paramValue("contentType", "application/json", true);
		// create response data packet
		var defaultReponse = {};
		defaultReponse['type']			= rc.format; 
		defaultReponse['data']			= {};
		defaultReponse['contentType']	= prc.contentType; 
		defaultReponse['encoding']		= 'utf-8';
		defaultReponse['statusCode']	= 200;
		defaultReponse['statusText']	= '';
		event.paramValue("response",defaultReponse,true);
		
		event.paramValue('apiKey','82dfd8ed26fce71217af843ed8d2288e29e06583');
		event.paramValue('appid','48f545670e2acee193c1b4078f9d3bca0250629b');
		
		if( !Len(Trim(Event.getValue('apikey',''))) ) {
			throw(message='Missing APIKey in header.',type="Unauthorized.MissingAPIKey");
		}
		var User = getModel('UserService').findByApiKey(rc.apiKey);
		if( IsNull( User ) ) {
			throw(message='Invalid APIKey.',type="Unauthorized.InvalidAPIKey");
		}
		
		if( !Len(Trim(Event.getValue('appid',''))) ) {
			throw(message='Missing AppID in header.',type="Unauthorized.MissingAppID");
		}
		var Criteria = {
			User = User,
			appid = rc.appid
		};
		var App = getModel('AppService').findWhere(Criteria=Criteria);
		if( IsNull( App ) ) {
			throw(message='Invalid AppID.',type="Unauthorized.InvalidAppID");
		}
		rc.App = App;
		rc.User = User;
		
		prc.BaseObject = new spamcheck.model.BaseObject();

	}

	function postHandler(event,rc,prc,action){
			/*
			//Get URIs for ressource childs
			if( structKeyExists(prc.response,'data') && isStruct(prc.response.data) && structKeyExists(prc.response.data,"results")){
				for (var item in prc.response.data.results){
					defineChildsURI(item);
				}
			} else {
				defineChildsURI(prc.response.data);
			}
			*/
		try {
			prc.response['data']['code']	= prc.response.statusCode;
			prc.response['data']['status']	= prc.response.statusText;
			if( !structKeyExists(prc.response.data,'results') ) {
				prc.response['data']['results']	= {};
			}
		} catch ('LogAPI.Unauthorized' e) {
			prc.response['data']['code']	= 401;
			prc.response['data']['status']	= 'unauthorized';
			prc.response['statusText']		= e.message;
		} catch(any e) {
			prc.response['data']['code']	= 500;
			prc.response['data']['status']	= 'error';
			prc.response['statusText']		= e.message;
		}
		event.renderData(
			type			= rc.format, 
			data			= prc.response.data,
			contentType		= prc.response.contentType, 
			encoding		= prc.response.encoding, 
			statusCode		= prc.response.statusCode,
			statusText		= prc.response.statusText
		);
	}

	function onError(event,rc,prc,faultAction,exception){
		
		if( arguments.exception.type contains 'Unauthorized.') {
			prc.response.statusCode = 401;
		} else {
			prc.response.statusCode = 500;
		}
		
		//prc.response.statusCode = 500;
		prc.response.statusText = arguments.exception.message;
		prc.response.data = arguments.exception;
		postHandler(event,rc,prc);
	}



	//*********************************	HELPERS	*********************************
	private function populateAndSave(required any oEntity,required string JSONString){
		oEntity.populateFromJSON(JSONString=JSONString);
		oEntity.save(oEntity);
	}
	
	private function defineURI(oEntity){
		oEntity.URI = "/"&oEntity.getEntityName() &"/"&oEntity.getID();
	}
	
	private function defineChildsURI(oEntity){
		var stEntityMetaData = getMetadata(oEntity);
		if (structKeyExists(stEntityMetaData,"properties")){
			var properties = stEntityMetaData.properties;
			for (var property in properties){
				if (structKeyExists(property,"fieldtype")){
					if (listFind("one-to-one,one-to-many,many-to-one,many-to-many",property.fieldtype)){
						var oChildEntity = evaluate("oEntity.get#property.name#()");
						if (!isNull(oChildEntity)){
							if (isObject(oChildEntity)){
								defineURI(oChildEntity);
								oEntity[property.name] = oChildEntity;
							} else {
								oEntity[property.name&"URI"]= "/"&oEntity.getEntityName()&"/"&oEntity.getID()&"/"&property.name;
							}
						} else {
							oEntity[property.name]= "";
						}
					}
				}
			}
		}
	}	




}