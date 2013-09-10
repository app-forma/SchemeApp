// ****************************************************************************
// *-*-*-*-*-*-*-*-*-*-*-*-*-* GLOBAL HELPER FN'S -*-*-*-*-*-*-*-*-*-*-*-*-*-*-
// ****************************************************************************
var passwordHash = require('password-hash'),
	uuid = require('node-uuid');

exports.isEmpty = function(obj) {
	if(typeof obj !== 'object')
	{
		return true;
	}
  return Object.keys(obj).length === 0;
};

exports.validateEmail = function(email) {
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
  };

exports.alphaNumTest = function(str) {
	re = /^[a-z0-9]+$/i;
	return re.test(str);
};

exports.stripString = function(str, callback) {
	str = str.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '');
	callback(str);
};

/*
**	This one dosn't let any signs pass, for signup etc
*/
exports.stripObj = function(obj, callback) {
	// Not async but this is super fast!
	var keys = Object.keys(obj);
	for(var i = 0, length = keys.length; i < length; i++) {
		obj[keys[i]] = obj[keys[i]].replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '');
		obj[keys[i]] = obj[keys[i]].trim();
		obj[keys[i]] = obj[keys[i]].replace(/\s/g, "");
	}
	callback(null, true);
};

exports.simpleValidation = function(str) {
	if(str === "" || str.trim() === "" || str.length < 3 || !str) {
		return false;
	} else {
		return true;
	}
};

exports.generateCryptoPassword = function(password) {
	return passwordHash.generate(password);
};

exports.validateCryptoPassword = function(password, hashedPassword) {
	return passwordHash.verify(password, hashedPassword);
};

exports.generateGuid = function(callback) {
	callback(uuid.v1());
};