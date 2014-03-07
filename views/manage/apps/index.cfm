<cfset addAsset("/includes/js/manage/apps.js") />

<cfoutput>

<ol class="breadcrumb">
  <li><a href="/">Home</a></li>
  <li class="active">My Apps</li>
</ol>

<div class="list-group" id="applist">
<cfloop array="#rc.apps#" index="App">

	<div class="list-group-item" style="cursor:pointer;" data-id="#App.getID()#" data-app='#serializeJson(App.toJSON())#'>
		<div class="pull-right"></div>

		<h4 class="list-group-item-heading">#App.getName()#</h4>
	
		<p class="list-group-item-text pull-left">
			#App.getPostbackURL()#
		</p>
		<br />
	</div>

</cfloop>
</div>

<!---<cfdump var="#getModel('AppSettingService').getAvailableSettings()#" />--->


<div class="panel panel-default" id="editarea">

	<ul class="nav nav-tabs" id="apptabs">
		<li class="active">
			<a href="##editapp" data-toggle="tab">New App</a>
		</li>
		<li style="display:none;">
			<a href="##editsettings" data-toggle="tab">Settings</a>
		</li>
	</ul>

	<div class="tab-content">
		
		<div class="tab-pane active" id="editapp">
			<div class="panel-body">

				<form role="form" id="saveapp" data-endpoint="/manage/apps.saveapp">
					<input type="hidden" name="id" value="" />
			
					<div class="form-group" id="name">
						<label for="input-name">Name</label>
						<input type="text" class="form-control" id="input-name" name="name" placeholder="My cool app">
						<ul class="errors"></ul>
					</div>
			
					<div class="form-group" id="postbackurl">
						<label for="input-postbackurl">Postback URL</label>
						<input type="text" class="form-control" id="input-postbackurl" name="postbackurl" placeholder="http://myappurl.com/spamcheck/postback">
						<ul class="errors"></ul>
					</div>
			
					<div class="form-group" id="appid" style="display:none;">
						<label for="input-appid">AppID Key</label>
						<input type="text" class="form-control" disabled="disabled" name="appid" id="input-appid" value="" />
						<ul class="errors"></ul>
					</div>
					
					<div class="form-group" id="deleteapp" style="display:none;">
						<label for="input-deleteapp">Delete</label>
						<input type="checkbox" name="delete" value="true" id="input-deleteapp" /> <label for="input-deleteapp" style="font-weight:normal;">Yes, delete this app.</label>
						<ul class="errors"></ul>
					</div>
			
					<button type="submit" class="btn btn-default">Save</button>
					&nbsp; &nbsp;
					<button type="reset" class="btn btn-default">Cancel</button>
				</form>

			</div>
		</div>


		<div class="tab-pane" id="editsettings">

			<cfset settings = getModel('AppSettingService').getAvailableSettings() />

			<div class="panel panel-default">
				<div class="panel-body">
					<form role="form-horizontal" id="savesettings" data-endpoint="/manage/apps.savesettings">
						<cfloop collection="#settings#" item="module">
							<cfset obj = settings[module] />
				
							<div class="panel panel-default">
					
								<div class="panel-heading">
									<strong>#obj.title#</strong> &nbsp; #obj.description# &nbsp; #obj.author# &nbsp; #obj.weburl#  &nbsp; #obj.version#
								</div>
								<div class="panel-body">

									<cfloop collection="#obj.settings#" item="key">
										<cfset info = obj.settings[key] />
							
										<div class="form-group" id="name">
								
											<label for="input-#module#-#key#" class="col-sm-2 control-label">#key# <cfif structKeyExists(info,'required') && info.required>*</cfif></label>
											<div class="col-sm-10">
												<input type="text" class="form-control" id="input-#HTMLEditFormat(module)#-#HTMLEditFormat(key)#" name="#HTMLEditFormat(key)#" data-key="#HTMLEditFormat(key)#" data-section="module" data-category="#HTMLEditFormat(module)#" data-description="#HTMLEditFormat(info.description)#" data-default="#( structKeyExists(info,'default') ? HTMLEditFormat(info.default) : '' )#" />
												<p class="help-block">#HTMLEditFormat(info.description)#</p>
												<ul class="errors"></ul>
											</div>

										</div>
							
									</cfloop>
						
								</div>
							</div>
				
						</cfloop>
						<button type="submit" class="btn btn-default">Save</button>
					</form>
				</div>
			</div>

		</div>


	</div>
</div>





</cfoutput>

