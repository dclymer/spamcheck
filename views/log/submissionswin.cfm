<!---
<div class="modal-content">
--->


<!---
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
dl.logdetail dd.scrolloverflow {
	overflow:auto;
}
</style>

<cfoutput>

<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
	<h4 class="modal-title">Log###rc.Log.getID()# Submissions</h4>
</div>

<div class="modal-body">
	
	<cfloop array="#rc.Submissions#" index="Submission">
	<dl class="dl-horizontal logdetail">
		
		<dt>Submitted</dt>
		<dd>#dateFormat(Submission.getCreated(),'medium')# #timeFormat(Submission.getCreated(),'medium')#</dd>
		
		<dt>Event Type:</dt>
		<dd> #Submission.getEventType()# </dd>
		
		<cfif Submission.hasPostback()>
			<cfset Postback = Submission.getPostback() />
			<dt>Postback HTTP Code</dt>
			<dd>
				#Postback.getStatus_Code()# / #Postback.getStatus_Text()#
				&nbsp; <button class="submit-postback" data-id="#Submission.getID()#">Resend</button>
			</dd>
							
			<dt>Date</dt>
			<dd>#dateFormat(Postback.getCreated(),'short')# #timeFormat(Postback.getCreated(),'short')#</dd>

			<dt>Content Type</dt>
			<dd>#Postback.getContent_Type()#</dd>
			
			<dt>Reponse:</dt>
			<dd class="scrolloverflow">
				#HTMLEditFormat(Postback.getfilecontent())#
			</dd>	
			
			<dt>Headers:</dt>
			<dd class="scrolloverflow">
				#HTMLEditFormat(Postback.getresponseheader())#
			</dd>
				
		</cfif>
	</dl>
	<hr class="lookups-spacer" />
	
	</cfloop>
</div>

</cfoutput>
<!---
	</div>
--->