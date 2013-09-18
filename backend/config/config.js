var configuration = {};

configuration.project = {
	name: 'SchemeApp',
	ver: '0.0.1'
};

process.env.NODE_ENV = 'production'; // 'development' or 'production'

configuration.http = {
	port: 13564,
	host: '127.0.0.1'
};

configuration.express = {};

configuration.db = {
	port: 27017,
	host: '127.0.0.1',
	database: 'schemeApp'
};
configuration.db.url = 'mongodb://' + configuration.db.host + ':' + configuration.db.port + '/' + configuration.db.database;

module.exports = configuration;