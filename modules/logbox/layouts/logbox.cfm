<!---
<cfset x = Event.getCurrentEvent() />
<cfdump var='#x#' />
<cfabort>
--->
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--============================Head============================-->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex,nofollow" />	
	<!--- SES --->
	<base href="#getSetting('htmlBaseURL')#" />
	<!--=========Title=========-->
    <title>LogBox DB Logs</title> 
	<link href="#rc.root#/includes/images/favicon.ico" rel="shortcut icon" type="image/x-icon" />
	<!--=========Stylesheets=========-->
	<link href="#rc.root#/includes/css/style.css"	 	rel="stylesheet" type="text/css"/>
	<link href="#rc.root#/includes/css/teal.css" 		rel="stylesheet" type="text/css"/>
	<link href="#rc.root#/includes/css/invalid.css" 	rel="stylesheet" type="text/css"/>
    <link href="#rc.root#/includes/css/sort.css"	 	rel="stylesheet" type="text/css"/>
	<!--- loop around the cssAppendList, to add page specific css --->
	<cfloop list="#event.getValue("cssAppendList","")#" index="css">
		<cfset addAsset("#rc.root#/includes/css/#css#.css")>
	</cfloop>
	<cfloop list="#event.getValue("cssFullAppendList","")#" index="css">
		<cfset addAsset("#css#.css")>
	</cfloop>
	        
	<!--========= JAVASCRIPT -->
	<script type="text/javascript" src="#rc.root#/includes/javascript/jquery-1.4.4.min.js"></script> <!--Import jquery tools-->
	<script type="text/javascript" src="#rc.root#/includes/javascript/jquery.tools.min.js"></script> <!--Import jquery tools-->
	<script type="text/javascript" src="#rc.root#/includes/javascript/jquery.uitablefilter.js"></script>
	<script type="text/javascript" src="#rc.root#/includes/javascript/metadata.pack.js"></script>
	<script type="text/javascript" src="#rc.root#/includes/javascript/tablesorter.min.js"></script>
	<script type="text/javascript" src="#rc.root#/includes/javascript/relax.js"></script>
	<script type="text/javascript" src="#rc.root#/includes/javascript/jsonlint.js"></script>
	<!--- loop around the jsAppendList, to add page specific js --->
	<cfloop list="#event.getValue("jsAppendList", "")#" index="js">
		<cfset addAsset("#rc.root#/includes/javascript/#js#.js")>
	</cfloop>
	<cfloop list="#event.getValue("jsFullAppendList", "")#" index="js">
		<cfset addAsset("#js#.js")>
	</cfloop>

</head>
<!--End Head-->
<!--============================Body============================-->
<body>

<!--============================ Template Content Background ============================-->
<div id="content_bg" class="clearfix">
	<!--============================ Main Content Area ============================-->
	<div class="content wrapper clearfix">
		#renderView()#		
	</div>
<!--End main content area-->
</div>

<!--End Template Content bacground-->
<!--============================Footer============================-->
<div id="footer">
	<div class="wrapper">
	</div>
</div>
<!--End Footer-->

<!--- ============================ confirm it modal dialog ============================ --->
<div id="confirmIt"> 
	<div> 
		<h2 id="confirmItTitle">Are you sure?</h2> 
		<p id="confirmItMessage">Are you sure you want to perform this action?</p> 
		<hr />
		<p class="textRight">
			<button class="close button" 	data-action="cancel"> Cancel </button>
			<button class="close buttonred" data-action="confirm"> Confirm </button>
		</p>
	</div> 
</div>
<!--- ============================ end Confirmit ============================ --->

<!--- ============================ Remote Modal Window ============================ --->
<div id="remoteModal">
	<div id="remoteModelContent">
		<img src="#rc.root#/includes/images/ajax-loader-blue.gif" alt="loader" />
	</div>
</div>
<!--- ============================ end Confirmit ============================ --->

</body>
<!--End Body-->
</html>
</cfoutput>