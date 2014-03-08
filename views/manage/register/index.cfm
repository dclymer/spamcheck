<cfset addAsset("/includes/js/manage/register.js") />
	
<cfoutput>
	

<div class="panel-body" id="register-container">
	<div class="panel panel-default">
		<div class="panel-heading">Register</div>
		<div class="panel-body">
		

			<form class="form-horizontal" role="form" id="register" data-endpoint="/manage/register">
	
				<div class="form-group" id="email">
					<label for="input-email" class="col-sm-2 control-label">Email</label>
					<div class="col-sm-10">
						<input type="text" class="form-control" placeholder="Email" name="email" id="input-email">
						<ul class="errors"></ul>
					</div>
				</div>
	
				<div class="form-group" id="password">
					<label for="input-password" class="col-sm-2 control-label">Password</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" placeholder="Password" name="password" id="input-password">
						<ul class="errors"></ul>
					</div>
			  	</div>

				<div class="form-group" id="verifypassword">
					<label for="input-verifypassword" class="col-sm-2 control-label">Verify Password</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" placeholder="Verify Password" name="verifypassword" id="input-verifypassword">
						<ul class="errors"></ul>
					</div>
			  	</div>

				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10">
						<button type="submit" class="btn btn-default">Register</button>
					</div>
				</div>
	
			</form>

	
		</div>
	</div>
</div>

</cfoutput>

