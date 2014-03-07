interface { 
	
	public boolean function isReady();
	 
	public boolean function checkSpam(
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	);
	
	public string function submitSpam(
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	);
	
	public string function submitHam(
		Required	String	author,
		Required	String	authorEmail,
		Required	String	authorURL,
		Required	String	content,
		Required	String	permalink,
		Required	String	blogURL,
		Required	String	user_ip,
		Required	String	user_agent,
		Required	String	referrer,
					String	commentType		= "comment"
	); 
}

/*
author,
authorEmail,
authorURL,
content,
permalink,
blogURL,
user_ip,
user_agent,
referrer,
commentType
*/