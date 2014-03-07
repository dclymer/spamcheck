<cfif structKeyExists(rc,'Log')>
	<cfset Log = rc.Log />
<cfelse>
	
</cfif>
<cfoutput>
        	    <tr data-id="#Log.getID()#">
					<td>
						<a data-toggle="modal" href="#Event.buildLink(linkTo='log.infowin',queryString=Log.getID())#" data-target="##log-detail-modal">
							#Log.getID()#
						</a>
					</td>
					<td>
						<cfif Log.hasApp()>
							#Log.getApp().getID()#
						</cfif>
					</td>
					<td class="l">
						<cfif Log.hasComment()>
							<span style="display:inline-block; width:120px;">
								#Log.getComment().getUser_IP()#
							</span>
							<span>
								#Log.getComment().getAuthor()#
							</span>
							<br />
							#Left(HTMLEditFormat(Log.getComment().getContent()),300)#
							<!---
							<dl class="dl-horizontal">
								<dt style="text-align:left; font-weight:normal;">#Log.getComment().getAuthor()#&nbsp;</dt>
								<dd style="text-align:right;">#Log.getComment().getUser_IP()#&nbsp;</dd>
								
								
								<dd style="margin-left:0;">
									#Left(HTMLEditFormat(Log.getComment().getContent()),300)#
								</dd>
							</dl>
							--->
							
						</cfif>
					</td>
					<td>
						#Log.getLookupCount()#
					</td>
					<td>
						#Log.getSpamConfidence() & '%'#
					</td>
					<td>
						#DateFormat(Log.getCreated(),'medium')# <br />
						#TimeFormat(Log.getCreated(),'medium')#
					</td>
					<td>
						<input type="radio" class="submittype" name="submittype-#Log.getID()#" value="ham" data-id="#Log.getID()#" />
					</td>
					<td>
						<input type="radio" class="submittype" name="submittype-#Log.getID()#" value="spam" data-id="#Log.getID()#" />
					</td>
					<td class="l">
						<cfif Log.hasSubmission()>
							Submissions: #arrayLen(Log.getSubmissions())#<br />
							<span style="display:inline-block; width:105px;">
								Action: #Log.getLastSubmissionType()#
							<span>
							<cfif Log.getLastPostBackStatus_Code() eq 200>
								<cfset submission_title_info = "Postback Successful: #Log.getLastPostBackStatus_Code()#" />
								<cfset submission_icon_class = "fa-check-square" />
							<cfelseif Log.getLastPostBackStatus_Code() eq 500>
								<cfset submission_title_info = "Postback ERROR: #Log.getLastPostBackStatus_Code()#" />
								<cfset submission_icon_class = "fa-exclamation-triangle" />
							</cfif>
							<cfif !IsNull(submission_title_info) && !IsNull(submission_icon_class)>
								<a data-toggle="modal" href="#Event.buildLink(linkTo='log.submissionswin',queryString=Log.getID())#" data-target="##log-submissions-modal" title="#submission_title_info#" class="fa #submission_icon_class#" style="float:right; margin-top:3px;"></a>
							</cfif>
						</cfif>
					</td>
					<!---
					<td class="l">
						<cfif Log.getLastPostBackStatus_Code() eq 0>
						<cfelseif Log.getLastPostBackStatus_Code() eq 200>
							<span data-toggle="tooltip" title="Postback Successful: #Log.getLastPostBackStatus_Code()#" class="fa fa-check-square"></span>
						<cfelse>
							<span data-toggle="tooltip" title="Postback ERROR: #Log.getLastPostBackStatus_Code()#" class="fa fa-exclamation-triangle"></span>
						</cfif>
						#Log.getpostbackcount()# 
					</td>
					--->
					
					<!---
					<cfif !len(trim(Log.getLastSubmissionType()))>
						<td>
							<input type="radio" class="submittype" name="submittype-#Log.getID()#" value="ham" data-id="#Log.getID()#" />
						</td>
						<td>
							<input type="radio" class="submittype" name="submittype-#Log.getID()#" value="spam" data-id="#Log.getID()#" />
						</td>
					<cfelse>
						<td>
							<cfif Log.getLastSubmissionType() eq 'ham'>
								<span class="fa fa-check"></span>
							</cfif>
						</td>
						<td>
							<cfif Log.getLastSubmissionType() eq 'spam'>
								<span class="fa fa-check"></span>
							</cfif>
						</td>
					</cfif>
					--->
				</tr>
</cfoutput>