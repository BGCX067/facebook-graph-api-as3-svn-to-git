
/**		
 * 
 *	com.facebook.graph.examples.OAuthExample
 *	
 *	@version 1.00 | Jul 22, 2010
 *	@author Justin Windle
 *  
 **/
 
package com.facebook.graph.examples 
{
	import com.facebook.graph.enum.FacebookObjectType;
	import com.facebook.graph.enum.FacebookAuthorizeDisplayType;
	import com.facebook.graph.enum.FacebookScopeType;
	import com.facebook.graph.net.FacebookComms;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * OAuthExample
	 */
	public class OAuthExample extends Sprite 
	{
		//	----------------------------------------------------------------
		//	CONSTANTS
		//	----------------------------------------------------------------
		
		private static const APP_ID : String = "xxx";
		private static const APP_SECRET : String = "xxx";
		private static const APP_URI : String = "xxx";
		
		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------
		
		private var _comms : FacebookComms = new FacebookComms();
		
		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		public function OAuthExample()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function initialise() : void
		{
			// Check whether an oauth code has been passed in via flashvars
			var code : String = _comms.getOAuthCode(this);
			
			// For testing, populate the code anyway
			//code = "xxx";
			
			if(!code)
			{
				// We haven't been authorised yet, so do so now...
				_comms.authorize(APP_ID, APP_URI, [FacebookScopeType.PUBLISH_STREAM], FacebookAuthorizeDisplayType.POPUP);
			}
			else
			{
				// We have been authorised, so now we just need the access token
				_comms.retrieveAccessToken(accessTokenSuccess, accessTokenFail, APP_ID, APP_SECRET, APP_URI, code);
			}
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		private function onAddedToStage(event : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initialise();
		}

		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function accessTokenSuccess(data : Object) : void
		{
			trace("accessTokenSuccess: " + data);
			trace("Access Token: " + _comms.accessToken);
			
			var params : Object = {};
						params.message = "Check out my Posterous...";
			params.link = "http://soulwire.posterous.com/";
			
			params.name = "Soulwire's Posterous";			params.caption = "A scrapbook of interesting things...";			params.description = "This is where I bookmark amazing work that I see or interesting articles that I read.";						params.picture = "http://files.posterous.com/user_profile_pics/412858/sw-logo.jpg";
			
			// Passing null as user ID will force comms to use 'me' as default
			_comms.publish(publishSuccess, publishFail, null, FacebookObjectType.FEED, params);
		}

		private function accessTokenFail(data : Object) : void
		{
			trace("accessTokenFail: " + data);
		}
		
		private function publishSuccess(data : Object) : void
		{
			trace("publishSuccess: " + data);
		}
		
		private function publishFail(data : Object) : void
		{
			trace("publishFail: " + data);
		}
	}
}
