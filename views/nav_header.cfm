<cfset addAsset('/includes/js/login.js') />
<cfoutput>
	<cfset ce = getRequestContext().getCurrentEvent() />

	<ul class="nav navbar-nav">
		
		<li class="#(ce eq 'stats'				? 'active' : '')#"	><a href="/stats"								title="System Stats"							><span class="fa fa-signal fa-2x"				></span></a></li>
		
		<li class="#(ce eq 'relaxer'			? 'active' : '')#"	><a href="/console/home/relaxer"				title="API Console & Docs"		target="_blank"><span class="fa fa-compress fa-2x"				></span></a></li>
		
		
		<li <cfif !getPlugin('SessionStorage').exists('user')>style="display:none;"</cfif> class="loginrequired #(ce eq 'status'				? 'active' : '')#"	><a href="/manage/apps"				title="My Apps"		><span class="fa fa-cogs fa-2x"				></span></a></li>
		<li <cfif !getPlugin('SessionStorage').exists('user')>style="display:none;"</cfif> class="loginrequired #(ce eq 'log'					? 'active' : '')#"	><a href="/log"						title="Latest"		><span class="fa fa-th-list fa-2x"			></span></a></li>
		
		<li <cfif !getPlugin('SessionStorage').exists('user')>style="display:none;"</cfif> class="loginrequired #(ce eq 'logout'			? 'active' : '')#"	><a href="##"						title="Logout"		><span class="fa fa-unlock fa-2x"			></span></a></li>
		
		<li class="dropdown" title="Login" <cfif getPlugin('SessionStorage').exists('user')>style="display:none;"</cfif>>
			<a href="##" class="dropdown-toggle" data-toggle="dropdown"> <span class="fa fa-lock fa-2x"></span> </a>
			<form action="##" class="form-horizontal dropdown-menu" role="form" style="width:300px;" id="login-form" data-endpoint="/main">
				<div class="form-group" style="margin-left:5px; margin-right:5px;" align="center">
					<input type="email" class="form-control" name="email" placeholder="Email">
					<br />
							
					<input type="password" class="form-control" name="password" placeholder="Password">
					<br />
					<button type="button" class="btn btn-default pull-left register">Register</button>
					
					<button type="submit" class="btn btn-default pull-right">Sign in</button>
				</div>
			</form>
		</li>
		
	</ul>

</cfoutput>

