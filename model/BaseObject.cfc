component name="BaseObject" cache=false accessors=true {

	public string function getIDName() {
		var classname = ListLast( GetMetaData( This ).fullname, "." );
		return ORMGetSessionFactory().getClassMetadata( classname ).getIdentifierColumnNames()[1];
	}
	
	public any function setIDValue(Required ID) {
		return Evaluate( "set" & getIDName() & "(#ID#)" );
	}

	public any function getIDValue() {
		return Evaluate( "get" & getIDName() & "()" );
	}

	public array function arrayToJSON(Array Arr) {
		var jsonarr = [];
		if(structKeyExists(arguments,'Arr') && IsArray(arguments.Arr)) {
			for(var Obj in Arr) {
				if( structKeyExists(Obj,'toJSON') ) {
					arrayAppend( jsonarr,Obj.toJSON() );
				}
			}
		}
		return jsonarr;
	}

}