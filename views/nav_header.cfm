<cfset addAsset('/includes/js/login.js') />
<cfoutput>
	<cfset ce = getRequestContext().getCurrentEvent() />

	<ul class="nav navbar-nav">

		<li class="#(ce eq 'status'				? 'active' : '')#"	><a href="/manage/apps"				title="My Apps"		><span class="fa fa-cogs fa-2x"				></span></a></li>
		<li class="#(ce eq 'log'				? 'active' : '')#"	><a href="/log"						title="Latest"		><span class="fa fa-th-list fa-2x"			></span></a></li>
		
		<!---
		no longer used, migrated per-app-settings
		<li class="#(ce eq 'settings'			? 'active' : '')#"	><a href="/manage/settings"			title="Settings"	><span class="fa fa-check-square-o fa-2x"	></span></a></li>
		--->
		
		<li <cfif !getPlugin('SessionStorage').exists('user')>style="display:none;"</cfif> class="#(ce eq 'logout'			? 'active' : '')#"	><a href="##"						title="Logout"		><span class="fa fa-unlock fa-2x"			></span></a></li>
		
		<li class="dropdown" title="Login" <cfif getPlugin('SessionStorage').exists('user')>style="display:none;"</cfif>>
			<a href="##" class="dropdown-toggle" data-toggle="dropdown"> <span class="fa fa-lock fa-2x"></span> </a>
			<form action="##" class="form-horizontal dropdown-menu" role="form" style="width:300px;" id="login-form" data-endpoint="/main">
				<div class="form-group" style="margin-left:5px; margin-right:5px;" align="center">
					<input type="email" class="form-control" name="email" placeholder="Email">
					<br />
							
					<input type="password" class="form-control" name="password" placeholder="Password">
					<br />
					<button type="submit" class="btn btn-default">Sign in</button>
				</div>
			</form>
		</li>
		
	</ul>

</cfoutput>

