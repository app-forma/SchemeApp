var server = (function () {
	"use strict";
	var request = function (path, method, callback, data) {
		var xhr = new XMLHttpRequest(),
			success = true;
		xhr.open(method, location.protocol + '//' +  location.host + '/' + path, true);
		xhr.onreadystatechange = function () {
			if (xhr.readyState === 4) {
				if (xhr.status >= 400) {
					success = false;
				}
				callback(success, JSON.parse(xhr.responseText), xhr.status);
			}
		};
		if (data) {
			xhr.setRequestHeader("Content-type", "application/json");
			xhr.send(JSON.stringify(data));
		} else {
			xhr.send();
		}
		return xhr;
	};
	return {
		get: function (path, callback) {
			return request(path, "GET", callback);
		},
		del: function (path, callback) {
			return request(path, "DELETE", callback);
		},
		post: function (path, data, callback) {
			return request(path, "POST", callback, data);
		},
		put: function (path, data, callback) {
			return request(path, "PUT", callback, data);
		}
	};
}());
