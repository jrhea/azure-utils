var aad;
(function(aad) {
	aad._authContext = null;
    function authenticate(clientId,postLogoutRedirectUri,tenant) {
		// Set up ADAL
		_authContext = new AuthenticationContext({
			clientId: clientId,
			postLogoutRedirectUri: postLogoutRedirectUri,
			popUp : false,
			tenant : tenant,
			cacheLocation : 'localStorage'
		});

		if (_authContext.isCallback(window.location.hash)) {
			// Handle redirect after token requests
			_authContext.handleWindowCallback();

			var err = _authContext.getLoginError();
			if (err) {
			   console.log('LOGIN ERROR:\n\n' + err);
			}

		}
		else {
			if(!_authContext.getCachedUser()){
				_authContext.login();
			}
		}
		return _authContext.getCachedUser();
	}
	function acquireToken(onSuccess,onFail) {
		_authContext.acquireToken(
			'https://graph.microsoft.com',
			function (error, token) {
				if (error || !token) { 
					onFail(error);
				}
				else {
					onSuccess(token);
				}
			});
	}
	function queryUserInfo(endpoint,onSuccess,onFail) {
        var auth_token = null;
		acquireToken(function(token){
			//on success
			auth_token = token;
		},
		function(error){
			//on fail
			console.log(error);
		});
		
		var xhr = new XMLHttpRequest();
		xhr.open('GET', endpoint, true);
		xhr.setRequestHeader('Authorization', 'Bearer ' + auth_token);
		xhr.onreadystatechange = function () {
			var responseText = xhr.responseText
			if (xhr.readyState === 4 && xhr.status === 200) {
				onSuccess(responseText);
			} 
			else if (xhr.status !== 200){
				onFail(responseText);
			}
		};
		xhr.send();
	}
	aad.authenticate = authenticate;
	aad.acquireToken = acquireToken;
	aad.queryUserInfo = queryUserInfo;
	
})(aad || (aad = {}));