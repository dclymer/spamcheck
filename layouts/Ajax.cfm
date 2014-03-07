<cfsetting showdebugoutput="false">
<cfset event.showdebugpanel("false")>
<cfset viewContent = renderView() />
<cfoutput>#viewContent#</cfoutput>