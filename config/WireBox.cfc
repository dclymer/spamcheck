component extends="coldbox.system.ioc.config.Binder"{
	
	/**
	* Configure WireBox, that's it!
	*/
	function configure(){
		
		// The WireBox configuration structure DSL
		wireBox = {
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wireBox"
			},

			// DSL Namespace registrations
			customDSL = {
				// namespace = "mapping name"
			},
			
			// Custom Storage Scopes
			customScopes = {
				// annotationName = "mapping name"
			},
			
			// Package scan locations
			scanLocations = ['/model'],
			
			// Stop Recursions
			stopRecursions = [],
			
			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = "",
			
			// Register all event listeners here, they are created in the specified order
			listeners = [
				// { class="", name="", properties={} }
			]			
		};
		
		// Map Bindings below
		
	
		map("SpamCheckService").to("spamcheck.model.SpamCheck.SpamCheckService").into(this.SCOPES.REQUEST).asEagerInit();
		
		map("SettingService").to("spamcheck.model.Setting.SettingService").into(this.SCOPES.SINGLETON).asEagerInit();
		
		map("UserService").to("spamcheck.model.User.UserService").into(this.SCOPES.REQUEST).asEagerInit();

		map("AppService").to("spamcheck.model.App.AppService").into(this.SCOPES.SINGLETON).asEagerInit();

		map("AppSettingService").to("spamcheck.model.AppSetting.AppSettingService").into(this.SCOPES.SINGLETON).asEagerInit();
		
		map("LogService").to("spamcheck.model.Log.LogService").into(this.SCOPES.REQUEST);
		
		map("LogSearchService").to("spamcheck.model.Log.LogSearchService").into(this.SCOPES.REQUEST);
		
		map("LookupService").to("spamcheck.model.Lookup.LookupService").into(this.SCOPES.REQUEST);
		
		map("CommentService").to("spamcheck.model.Comment.CommentService").into(this.SCOPES.REQUEST);
		
		map("PostbackDataService").to("spamcheck.model.PostbackData.PostbackDataService").into(this.SCOPES.REQUEST);
		map("PostbackService").to("spamcheck.model.Postback.PostbackService").into(this.SCOPES.REQUEST);
		
		map("SubmissionService").to("spamcheck.model.Submission.SubmissionService").into(this.SCOPES.REQUEST);
		
		map("StatsService").to("spamcheck.model.Stats.StatsService").into(this.SCOPES.REQUEST);
		
	}	

}