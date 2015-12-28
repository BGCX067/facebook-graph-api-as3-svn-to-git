package com.facebook.graph.examples 
{
	import com.facebook.graph.net.FacebookComms;
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.enum.FacebookObjectType;
	import com.facebook.graph.enum.FacebookPictureType;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 *  Tab
	 */
	public class TabExample extends Sprite 
	{
		private static const SECRET:String = "cffa205c89915718f298203ec38f701b";
		
		private var _comms:FacebookComms = new FacebookComms();
		private var _output:TextField = new TextField();

		public function TabExample()
		{
			addChild(_output);
			_output.width = 200;
			_output.height = 400;
			_output.y = 100;
			
			_comms.exchangeSessions(exchangeSessionsSuccess, exchangeSessionsFail, _comms.getAppID(this), _comms.getSessionKey(this), SECRET);
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function exchangeSessionsSuccess(__data:Object):void
		{
			getUser();
			getPicture();
			getEvents();
		}
		
		private function exchangeSessionsFail(__data:Object):void
		{
			
		}
		
		private function getPicture():void
		{
			_comms.picture(getPictureSuccess, getPictureFail, _comms.getUserID(this), FacebookPictureType.LARGE);
		}

		private function getPictureSuccess(__loader:Loader):void
		{
			addChild(__loader);
		}
		
		private function getPictureFail(__loader:Loader):void
		{
			
		}
		
		private function getUser():void
		{
			_comms.fetch(getUserSuccess, getUserFail, _comms.getUserID(this));
		}
		
		private function getUserSuccess(__data:Object):void
		{
			var data : Object = JSON.decode("" + __data);
			
			_output.appendText("name: " + data["name"] + "\n");
		}
		
		private function getUserFail(__data:Object):void
		{
			
		}
		
		private function getEvents():void
		{
			_comms.fetch(getEventsSuccess, getEventsFail, _comms.getUserID(this), FacebookObjectType.EVENTS);
		}

		private function getEventsSuccess(__data:Object):void
		{
			
		}
		
		private function getEventsFail(__data:Object):void
		{
			
		}
	}
}
