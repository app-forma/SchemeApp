module.exports.dbInit = function(config) {
  var mongoose = require('mongoose').connect(config.db.url);

  db = mongoose.connection;
  if (process.env.NODE_ENV === 'development') {
    mongoose.set('debug', true);
  }
  db.on('error', console.error.bind(console, 'connection error:'));
  db.once('open', function callback() {
    console.log('Connected to mongod @ ' + config.db.host + ':' + config.db.port);
  });
  return mongoose;
};