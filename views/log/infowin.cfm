<!---
<div class="modal-content">
--->


<style type="text/css">
dl.logdetail {}
dl.logdetail dd:after {
	content: "\00a0";
}
dl.logdetail hr {
	margin-top:5px;
	margin-bottom:5px;
}
</style>
<cfoutput>

<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
	<h4 class="modal-title">Log###rc.Log.getID()# Detail</h4>
</div>

<div class="modal-body">

	<dl class="dl-horizontal logdetail">
		
		<dt>Created</dt>
		<dd>#dateFormat(rc.Log.getCreated(),'medium')# #timeFormat(rc.Log.getCreated(),'medium')#</dd>
		
		<dt>Spam Confidence</dt>
		<dd> #rc.Log.getSpamConfidence()#% </dd>

		<cfif rc.Log.hasComment()>
			<dt>Author</dt>
			<dd>#rc.Log.getComment().getauthor()#</dd>

			<dt>Author Email</dt>
			<dd>#rc.Log.getComment().getauthoremail()#</dd>
	
			<dt>Author URL</dt>
			<dd>#rc.Log.getComment().getauthorurl()# </dd>

			<dt>Comment Type</dt>
			<dd>#rc.Log.getComment().getcommenttype()#</dd>

			<dt>Permalink</dt>
			<dd>#rc.Log.getComment().getpermalink()#</dd>

			<dt>User IP</dt>
			<dd>#rc.Log.getComment().getuser_ip()#</dd>

			<dt>User Agent</dt>
			<dd>#rc.Log.getComment().getuser_agent()#</dd>

			<dt>Referrer</dt>
			<dd>#rc.Log.getComment().getreferrer()#</dd>

			<dt>Content</dt>
			<dd>#HTMLEditFormat(rc.Log.getComment().getcontent())#</dd>

			<dt>BlogURL</dt>
			<dd>#rc.Log.getComment().getblogurl()#</dd>
		<cfelse>
			<dt>NO COMMENT DATA FOUND</dt>
			<dd></dd>
		</cfif>
		
		<cfif rc.Log.hasLookup()>
			<dt>Lookups</dt>
			<dd>
				#rc.Log.getLookupCount()#
				<button class="lookup-comment" data-id="#rc.Log.getComment().getID()#">Recheck</button>
			</dd>
			<cfloop array="#rc.Log.getLookups()#" index="Lookup">
				
				<hr class="lookups-spacer" />
				
				<dt>Date</dt>
				<dd>#dateFormat(Lookup.getCreated(),'short')# #timeFormat(Lookup.getCreated(),'short')#</dd>
				
				<dt>Service</dt>
				<dd>#Lookup.getService()#</dd>
				
				<dt>Spam</dt>
				<dd>#YesNoFormat(Lookup.getisSpam())#</dd>
				
				<dt>Score Weight</dt>
				<dd>#Lookup.getScoreWeight()#</dd>
				
			</cfloop>
		</cfif>
		
	</dl>
</div>

</cfoutput>
<!---
	</div>
--->