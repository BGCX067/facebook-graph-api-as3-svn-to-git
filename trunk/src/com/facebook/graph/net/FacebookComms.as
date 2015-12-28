package com.facebook.graph.net 
{
	import com.facebook.graph.enum.FacebookAuthorizeDisplayType;
	import flash.net.navigateToURL;
	import com.adobe.serialization.json.JSON;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	/**
	 *  FacebookComms
	 */
	public class FacebookComms 
	{
		private static const EXCHANGE_SESSIONS_URI : String = "https://graph.facebook.com/oauth/exchange_sessions";
		private static const REQUEST_URI : String = "https://graph.facebook.com/";
		private static const ACCESS_TOKEN_URI : String = "https://graph.facebook.com/oauth/access_token";		private static const AUTH_URI : String = "https://graph.facebook.com/oauth/authorize";		private static const DEFAULT_ID : String = "me";
		
		private var _authenticated:Boolean = false;
		private var _exchangeSessionsSuccess:Function;
		private var _exchangeSessionsFail:Function;
		private var _retrieveAccessTokenSuccess : Function;		private var _retrieveAccessTokenFail : Function;
		private var _callbacks : Dictionary = new Dictionary();
		private var _accessToken:String;
		
		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		public function authorize(__appID : String, __redirectURI : String, __scope : Array = null, __display : String = FacebookAuthorizeDisplayType.POPUP) : void
		{
			var variables : URLVariables = new URLVariables();
			
			variables["client_id"] = __appID;
			variables["redirect_uri"] = __redirectURI;
			variables["scope"] = __scope.join(',');
			variables["display"] = __display;
			
			var urlRequest : URLRequest = new URLRequest(AUTH_URI);
			urlRequest.data = variables;
			
			navigateToURL(urlRequest);
		}
		
		public function retrieveAccessToken(__success : Function, __fail : Function, __appID : String, __secret : String, __appURI : String, __authCode : String) : void
		{
			_retrieveAccessTokenSuccess = __success;
			_retrieveAccessTokenFail = __fail;
			
			var variables : URLVariables = new URLVariables();
			
			variables["code"] = __authCode;
			variables["client_id"] = __appID;			variables["client_secret"] = __secret;
			variables["redirect_uri"] = __appURI;
			
			var urlRequest : URLRequest = new URLRequest(ACCESS_TOKEN_URI);
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = variables;
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.load(urlRequest);
			
			urlLoader.addEventListener(Event.COMPLETE, retrieveAccessTokenCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, retrieveAccessTokenIOErrorHandler);
		}
		public function exchangeSessions(__success:Function, __fail:Function, __appID:String, __sessionKey:String, __secret:String):void
		{
			if(_authenticated)
			{
				__success.call(this);
				return;
			}
			
			_exchangeSessionsSuccess = __success;
			_exchangeSessionsFail = __fail;
			
			var variables : URLVariables = new URLVariables();
			variables["type"] = "client_cred";
			variables["client_id"] = __appID;
			variables["client_secret"] = __secret;
			variables["sessions"] = __sessionKey;
			
			var urlRequest : URLRequest = new URLRequest(EXCHANGE_SESSIONS_URI);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.load(urlRequest);
			
			urlLoader.addEventListener(Event.COMPLETE, exchangeSessionsCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, exchangeSessionsIOErrorHandler);
		}
		
		public function insights(__success:Function, __fail:Function, __appID:String, __refinement:String = "", __since:String = null, __until:String = null):void
		{
			var uri:String = REQUEST_URI + __appID + "/insights" +  __refinement;
			
			var variables : URLVariables = new URLVariables();
			if(_accessToken) variables["access_token"] = _accessToken;
			if(__since) variables["since"] = __since;
			if(__until) variables["until"] = __until;
			
			var urlRequest : URLRequest = new URLRequest(uri);
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = variables;
			
			call(urlRequest, __success, __fail);
		}
		
		public function fetch(__success:Function, __fail:Function, __id:String, __connection:String = "", __filters:Object = null):void
		{
			var uri:String = REQUEST_URI + (__id || DEFAULT_ID) + (__connection.length > 0 ? "/" + __connection : "");
			
			var variables : URLVariables = new URLVariables();
			if(_accessToken) variables["access_token"] = _accessToken;
			
			if(__filters)
			{
				for (var i : String in __filters)
				{
					variables[i] = __filters[i];
				}
			}
			
			var urlRequest : URLRequest = new URLRequest(uri);
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = variables;
			
			call(urlRequest, __success, __fail);
		}
		
		public function search(__success:Function, __fail:Function, __q:String, __type:String):void
		{
			var uri:String = REQUEST_URI + "/search";
			
			var variables : URLVariables = new URLVariables();
			if(_accessToken) variables["access_token"] = _accessToken;
			variables["q"] = __q;
			variables["type"] = __type;
			
			var urlRequest : URLRequest = new URLRequest(uri);
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = variables;
			
			call(urlRequest, __success, __fail);
		}
		
		public function picture(__success:Function, __fail:Function, __id:String, __size:String = ""):void
		{
			var uri:String = REQUEST_URI + (__id || DEFAULT_ID) + "/picture" + "?access_token=" + _accessToken + (__size.length > 0 ? "&type=" + __size : "");
			
			load(uri, __success, __fail);
		}
		
		public function publish(__success:Function, __fail:Function, __id:String, __connection:String, __params:Object = null):void
		{
			
			var uri:String = REQUEST_URI + (__id || DEFAULT_ID) + "/" + __connection;
			
			var variables : URLVariables = new URLVariables();
			if(_accessToken) variables["access_token"] = _accessToken;
			
			if(__params)
			{
				for (var i : String in __params)
				{
					variables[i] = __params[i];
				}
			}
			
			var urlRequest : URLRequest = new URLRequest(uri);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
			
			call(urlRequest, __success, __fail);
		}
		
		public function remove(__success:Function, __fail:Function, __id:String, __connection:String = ""):void
		{
			var uri:String = REQUEST_URI + (__id || DEFAULT_ID) + (__connection.length > 0 ? "/" + __connection : "");
			
			var variables : URLVariables = new URLVariables();
			if(_accessToken) variables["access_token"] = _accessToken;
			variables["method"] = "delete";
			
			var urlRequest : URLRequest = new URLRequest(uri);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
			
			call(urlRequest, __success, __fail);
		}
		
		public function extractParam(__paramName : String, __source : String) : String
		{
			return __source.match(new RegExp("(?<=" + __paramName + "\=)[^&]+((?=&))?", 'g'))[0] || '';
		}

		public function getAppID(__application:DisplayObject):String
		{
			return LoaderInfo(__application.root.loaderInfo).parameters["fb_sig_app_id"] as String;
		}
		
		public function getSessionKey(__application:DisplayObject):String
		{
			return LoaderInfo(__application.root.loaderInfo).parameters["fb_sig_session_key"] as String;
		}
		
		public function getUserID(__application:DisplayObject):String
		{
			return LoaderInfo(__application.root.loaderInfo).parameters["fb_sig_user"] as String;
		}
		
		public function getOAuthCode(__application : DisplayObject) : String
		{
			return LoaderInfo(__application.root.loaderInfo).parameters["code"] as String;
		}
		
		//	----------------------------------------------------------------
		//	GETTERS/SETTERS
		//	----------------------------------------------------------------
		
		public function get authenticated() : Boolean
		{
			return _authenticated;
		}
		
		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------
		
		private function call(__urlRequest:URLRequest, __success:Function, __fail:Function):void
		{
			var urlLoader : URLLoader = new URLLoader();
			
			_callbacks[urlLoader] = new Object();
			_callbacks[urlLoader].success = __success;
			_callbacks[urlLoader].fail = __fail;
			
			urlLoader.addEventListener(Event.COMPLETE, callCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, callIOErrorHandler);
			
			urlLoader.load(__urlRequest);
		}
		
		private function load(__uri:String, __success:Function, __fail:Function):void
		{
			var loader:Loader = new Loader();
			
			_callbacks[loader] = new Object();
			_callbacks[loader].success = __success;
			_callbacks[loader].fail = __fail;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
			loader.load(new URLRequest(__uri));
		}
		
		//	----------------------------------------------------------------
		//	EVENT HANDLERS
		//	----------------------------------------------------------------
		
		/*private function authenticateCompleteHandler(event : Event) : void
		{
			var loaderInfo : LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, authenticateCompleteHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, authenticateIOErrorHandler);
			
			_authenticateSuccess.call(_callbacks[loaderInfo.loader], loaderInfo.loader);
		}

		private function authenticateIOErrorHandler(event : IOErrorEvent) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, authenticateCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, authenticateIOErrorHandler);
			
			trace("authenticateIOErrorHandler" + urlLoader.data);
			
			_authenticateFail.call(this, urlLoader.data);
		}*/
				
		private function callIOErrorHandler(event : IOErrorEvent) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, callCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, callIOErrorHandler);
			
			trace("callIOErrorHandler" + urlLoader.data);
			
			if(!_callbacks[urlLoader]) return;
			
			_callbacks[urlLoader].fail.call(_callbacks[urlLoader], urlLoader.data);
			
			delete _callbacks[urlLoader];
		}

		private function callCompleteHandler(event : Event) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, callCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, callIOErrorHandler);
			
			trace("callCompleteHandler" + urlLoader.data);
			
			if(!_callbacks[urlLoader]) return;
			
			_callbacks[urlLoader].success.call(_callbacks[urlLoader], urlLoader.data);
			
			delete _callbacks[urlLoader];
		}
		
		private function loadIOErrorHandler(event : IOErrorEvent) : void
		{
			var loaderInfo : LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
			
			if(!_callbacks[loaderInfo.loader]) return;
			
			_callbacks[loaderInfo.loader].fail.call(_callbacks[loaderInfo.loader], loaderInfo.loader);
			
			delete _callbacks[loaderInfo.loader];
		}

		private function loadCompleteHandler(event : Event) : void
		{
			var loaderInfo : LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadIOErrorHandler);
			
			if(!_callbacks[loaderInfo.loader]) return;
			
			_callbacks[loaderInfo.loader].success.call(_callbacks[loaderInfo.loader], loaderInfo.loader);
			
			delete _callbacks[loaderInfo.loader];
		}

		private function exchangeSessionsIOErrorHandler(event : IOErrorEvent) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, exchangeSessionsCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, exchangeSessionsIOErrorHandler);
			
			trace("exchangeSessionsIOErrorHandler" + urlLoader.data);
			
			_exchangeSessionsFail.call(this, urlLoader.data);
		}

		private function exchangeSessionsCompleteHandler(event : Event) : void
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, exchangeSessionsCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, exchangeSessionsIOErrorHandler);
			
			var data : Object = JSON.decode("" + urlLoader.data);
			
			_accessToken = data[0]["access_token"];
			
			_authenticated = true;
			
			_exchangeSessionsSuccess.call(this, urlLoader.data);
		}
		
		private function retrieveAccessTokenCompleteHandler(event : Event) : void 
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, retrieveAccessTokenCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, retrieveAccessTokenIOErrorHandler);
			
			_accessToken = extractParam("access_token", urlLoader.data);
			_authenticated = true;
			
			_retrieveAccessTokenSuccess.call(this, urlLoader.data);
		}

		private function retrieveAccessTokenIOErrorHandler(event : IOErrorEvent) : void 
		{
			var urlLoader : URLLoader = URLLoader(event.target);
			urlLoader.removeEventListener(Event.COMPLETE, retrieveAccessTokenCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, retrieveAccessTokenIOErrorHandler);
			
			trace("retrieveAccessTokenIOErrorHandler" + urlLoader.data);
			
			_retrieveAccessTokenFail.call(this, urlLoader.data);
		}
		
		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		public function get accessToken() : String
		{
			return _accessToken;
		}
	}
}
