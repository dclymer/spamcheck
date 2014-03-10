function Stats(){
	this.Init();
};
Stats.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.endpoint = '/stats';
	
	objSelf.loadPieDonut( $('div#piedonut') );

};

Stats.prototype.loadPieDonut = function( jElm ) {
	var objSelf = this;
	jElm.addClass('unselectable');
	var req = $.ajax({
		type: 'GET',
		url: objSelf.endpoint + '.getLookupSpamStats',
		dataType: 'json',
		contentType: 'application/json; charset=utf-16',
	})
	.done( function(data, textStatus, jqXHR){
		objSelf.loadPieDonutDone(data, textStatus, jqXHR, jElm)
	})
	.fail(objSelf.loadPieDonutFail);
	return;
};
Stats.prototype.loadPieDonutDone = function(data, textStatus, jqXHR, jElm) {
	var objSelf = this;
	jElm.removeClass('unselectable');
	console.log(data);
	
	var colors = Highcharts.getOptions().colors,
	categories = ['Spam', 'Ham'],
	name = 'Spam Stats',
	chartData = [{
			y: data.spam.percent,
			color: colors[0],
			drilldown: {
				name: 'Spam',
				//categories: ['Akismet', 'ProjectHoneyPot', 'LinkSleeve'],
				//categories: Object.keys(data.spam),
				categories: $.map(data.spam.sources, function(v,i){ return i; }),
				data: $.map(data.spam.sources, function(v,i){ return v; }),
				color: colors[0]
			}
		}, {
			y: data.ham.percent,
			color: colors[1],
			drilldown: {
				name: 'Ham',
				//categories: Object.keys(data.ham),
				//data: [33.33, 33.33, 33.33],
				categories: $.map(data.ham.sources, function(v,i){ return i; }),
				data: $.map(data.ham.sources, function(v,i){ return v; }),
				color: colors[1]
			}
		}
	];


	// Build the data arrays
	var totalData = [];
	var moduleData = [];
	for (var i = 0; i < chartData.length; i++) {

		// add totals data
		totalData.push({
			name: categories[i],
			y: chartData[i].y,
			color: chartData[i].color
		});

		// add modules data
		for (var j = 0; j < chartData[i].drilldown.data.length; j++) {
			var brightness = 0.2 - (j / chartData[i].drilldown.data.length) / 5 ;
			moduleData.push({
				name: chartData[i].drilldown.categories[j],
				y: chartData[i].drilldown.data[j],
				color: Highcharts.Color(chartData[i].color).brighten(brightness).get()
			});
		}
	}
	
	// Create the chart
	jElm.highcharts({
		chart: {
			type: 'pie',
			backgroundColor:'rgba(255, 255, 255, 0.1)'
		},
		title: {
			text: 'Lookup Module Results'
		},
		plotOptions: {
			pie: {
				shadow: false,
				center: ['50%', '50%']
			}
		},
		tooltip: {
			valueSuffix: '%'
		},
		series: [{
			name: 'Total',
			data: totalData,
			size: '50%',
			dataLabels: {
				formatter: function() {
					return this.y > 5 ? this.point.name : null;
				},
				color: 'white',
				distance: -30
			}
		}, {
			name: 'Reported',
			data: moduleData,
			size: '80%',
			innerSize: '60%',
			dataLabels: {
				formatter: function() {
					// display only if larger than 1
					return this.y > 1 ? '<b>'+ this.point.name +':</b> '+ this.y +'%'  : null;
				}
			}
		}]
	});

};
Stats.prototype.loadPieDonutFail = function(jqXHR, textStatus, errorThrown) {
	jElm.removeClass('unselectable');
	alert('Error loading PieDonut Chart');
};



$(function() { new Stats(); });



