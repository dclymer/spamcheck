component singleton {

	
	property name="LogService" inject="LogService";
	property name="LookupService" inject="LookupService";
	property name="CommentService" inject="CommentService";
	property name="PostbackService" inject="PostbackService";
	property name="SpamCheckService" inject="SpamCheckService"; 
	
	property name="Logger" inject="logbox:logger:{this}";
	

	public any function init(){
		return this;
	}
	
	public array function getLogSpamHamStats(
		Required	Numeric		breakPoint	= 50
	) {
		//var results = ORMExecuteQuery('SELECT new map(day(l.created) as day, month(l.created) as month, year(l.created) as year, l.spamconfidence as spamconfidence, count(*) as s) FROM Log l ORDER BY l.created desc GROUP BY day');
		var results = ORMExecuteQuery('SELECT new map(DAY(l.created) AS day, MONTH(l.created) AS month, YEAR(l.created) AS year, count(*) AS c) FROM Log l GROUP BY day(l.created) order by l.created desc');
		return results;
	}

	public struct function getLookupSpamStats() {
		var result = {
			spam = {
				percent = 0,
				sources = {}
			},
			ham = {
				percent = 0,
				sources = {}
			}
		};

		var totalLookups = ORMExecuteQuery('SELECT COUNT(*) FROM Lookup', false)[1];
		result['spam']['percent'] = Round(ORMExecuteQuery('SELECT COUNT(*) FROM Lookup l WHERE l.isspam = true', false)[1] / totalLookups * 100);
		result['ham']['percent'] = Round(ORMExecuteQuery('SELECT COUNT(*) FROM Lookup l WHERE l.isspam = false', false)[1] / totalLookups * 100);


		var services = SpamCheckService.getServices();
		// this could be a lot more efficent by calculating the percentage directly but that would need to be done in sql not hql, brute force for now.
		for(var s in services) {
			var name = replaceNoCase(s.name,'Service','','one');
			result['spam']['sources'][name] = ORMExecuteQuery("SELECT COUNT(*) FROM Lookup l WHERE l.service = ? AND l.isspam = true", [s.name], false)[1];
			result['ham']['sources'][name] = ORMExecuteQuery("SELECT COUNT(*) FROM Lookup l WHERE l.service = ? AND l.isspam = false", [s.name], false)[1];
		}
		
		var spamTotal = 0;
		for(var key in result.spam.sources) {
			spamTotal = spamTotal+result.spam['sources'][key];
		}
		var hamTotal = 0;
		for(var key in result.ham.sources) {
			hamTotal = hamTotal+result.ham['sources'][key];
		}
		
		for(var s in services) {
			var name = replaceNoCase(s.name,'Service','','one');
			result['spam']['sources'][name] = Round(result['spam']['sources'][name] / spamTotal * 100);
			result['ham']['sources'][name] = Round(result['ham']['sources'][name] / hamTotal * 100);
		}

		return result; 
	}


	public struct function getLogSpamStats(Required Numeric breakPoint = 50) {
		var result = {
			ham = 0,
			spam = 0
		};
		result['ham'] = new Query(sql="SELECT count(1) FROM log l WHERE l.spamconfidence lte 50").execute().getResult();
		result['spam'] = new Query(sql="SELECT count(1) FROM log l WHERE l.spamconfidence gt 50").execute().getResult();
		return result; 
	}

}