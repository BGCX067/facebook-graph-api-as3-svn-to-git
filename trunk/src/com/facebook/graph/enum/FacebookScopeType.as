
/**		
 * 
 *	com.facebook.graph.enum.FacebookScopeType
 *	
 *	@version 1.00 | Jul 23, 2010
 *	@author Justin Windle
 *  
 **/
 
package com.facebook.graph.enum 
{

	/**
	 * FacebookScopeType
	 * @see http://developers.facebook.com/docs/authentication/permissions
	 */
	public class FacebookScopeType 
	{
		//	----------------------------------------------------------------
		//	Publishing Permissions
		//	----------------------------------------------------------------
		
		/// Enables your application to post content, comments, and likes to a user's stream and to the streams of the user's friends, without prompting the user each time.
		public static const PUBLISH_STREAM : String = "publish_stream";
		
		/// Enables your application to create and modify events on the user's behalf
		public static const CREATE_EVENT : String = "create_event";
		
		/// Enables your application to RSVP to events on the user's behalf
		public static const RSVP_EVENT : String = "rsvp_event";
		
		/// Enables your application to send messages to the user and respond to messages from the user via text message
		public static const SMS : String = "sms";
		
		/// Enables your application to perform authorized requests on behalf of the user at any time. By default, most access tokens expire after a short time period to ensure applications only make requests on behalf of the user when the are actively using the application. This permission makes the access token returned by our OAuth endpoint long-lived.
		public static const OFFLINE_ACCESS : String = "offline_access";
		
		//	----------------------------------------------------------------
		//	Page Permissions
		//	----------------------------------------------------------------
		
		/// Enables your application to retrieve access_tokens for pages the user administrates. The access tokens can be queried using the "accounts" connection in the Graph API. This permission is only compatible with the Graph API.
		public static const MANAGE_PAGES : String = "manage_pages";
		
		//	----------------------------------------------------------------
		//	Data Permissions
		//	----------------------------------------------------------------
		
		/// Provides access to the user's primary email address in the email property. Do not spam users. Your use of email must comply both with Facebook policies and with the CAN-SPAM Act.
		public static const EMAIL : String = "email";
		
		/// Provides read access to the Insights data for pages, applications, and domains the user owns.
		
		/// Provides access to all the posts in the user's News Feed and enables your application to perform searches against the user's News Feed
		
		/// Provides the ability to read from a user's Facebook Inbox. You must request to be whitelisted before you can prompt for this permission.
		
		/// Provides the ability to manage ads and call the Facebook Ads API on behalf of a user.
		
		/// Provides applications that integrate with Facebook Chat the ability to log in users.
		
		/// Provides access to the "About Me" section of the profile in the about property
		
		/// Provides access to the user's list of activities as the activities connection
		
		/// Provides access to the full birthday with year as the birthday_date property
		
		/// Provides access to education history as the education property
		
		/// Provides access to the list of events the user is attending as the events connection
		
		/// Provides access to the list of groups the user is a member of as the groups connection
		
		/// Provides access to the user's hometown in the hometown property
		
		/// Provides access to the user's list of interests as the interests connection
		
		/// Provides access to the list of all of the pages the user has liked as the likes connection
		
		/// Provides access to the user's current location as the current_location property
		
		/// Provides access to the user's notes as the notes connection
		
		/// Provides access to the user's online/offline presence
		
		/// Provides access to the photos the user has been tagged in as the photos connection
		
		/// Provides access to the photos the user has uploaded
		
		/// Provides access to the user's family and personal relationships and relationship status
		
		/// Provides access to the user's religious and political affiliations
		
		/// Provides access to the user's most recent status message
		
		/// Provides access to the videos the user has uploaded
		
		/// Provides access to the user's web site URL
		
		/// Provides access to work history as the work property
		
		/// Provides read access to any friend lists the user created. A user's friends are provided as part of basic data.
		
		/// Provides read access to the user's friend requests
		
		 
		 
	}
}