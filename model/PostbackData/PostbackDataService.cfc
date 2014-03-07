import coldbox.system.orm.hibernate.*;
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		super.init("PostbackData", "PostbackData.query.cache", true );
		return this;
	}
	
	public PostbackData function create(
		Required	Any		Data
	) {
		
		var PostbackData = super.new();
			
		if( isSimpleValue( arguments.Data ) ) {
			var val = arguments.Data;
		} else if( isStruct(arguments.Data) ) {
			var val = serializeJson(arguments.Data);
		} else if( isArray(arguments.Data) ) {
			var val = serializeJson(arguments.Data);
		} else {
			try {
				var val = toString(arguments.Data);
			} catch(any e) {}
		}
			
		if( isNull(val) ) {
			throw(message="Could not store the PostbackData value, must be string or valid JSON", type="PostBackDataService.InvalidType");
		}

		PostbackData.setValue( val );
		save(PostbackData);
		
		return PostbackData;
	}
	
	/*
	public array function create(
		Required	Struct		Data
	) {
		var PostBackDataArray = [];
		
		var d = arguments.Data;

		for(var key in d) {
			var PostbackData = super.new();
			
			if( isSimpleValue( d[key] ) ) {
				var val = d[key];
			} else if( isStruct(d[key]) ) {
				var val = serializeJson(d[key]);
			} else if( isArray(d[key]) ) {
				var val = serializeJson(d[key]);
			} else {
				try {
					var val = toString(d[key]);
				} catch(any e) {}
			}
			
			if( isNull(val) ) {
				throw(message="Could not store the PostbackData value for '#key#', must be string or valid JSON", type="PostBackDataService.InvalidType");
			}
			PostbackData.setKey( key );
			PostbackData.setValue( val );
			save(PostbackData);
			arrayAppend(PostBackDataArray,PostbackData);
		}
		
		return PostBackDataArray;
	}
	*/
	
	public void function save(Required PostbackData) {
		super.save(arguments.PostbackData);
	}
	
}