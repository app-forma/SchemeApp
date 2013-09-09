// ****************************************************************************
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*- LOAD DEPENDENCIES -*-*-*-*-*-*-*-*-*-*-*-*-*-
// ****************************************************************************
var config = require('./config/config.js'), express = require('express'), fs = require('fs');

var app = express();
/**
*	Bootstrap express
*/
require('./config/express.js')(app, config);

/**
*	Init database connection and the database object
*/
var mongoose = require('./config/mongoose.js').dbInit(config);

/**
*	Bootstrap models
*/
var models_path = __dirname + '/app/models';
fs.readdirSync(models_path).forEach(function (file) {
  require(models_path+'/'+file);
});

/**
*	Bootstrap routes
*/
require('./app/controllers/routes.js')(app);

if(process.env.NODE_ENV === 'development') {
  console.log(config.project.name + ' ' + config.project.verß + ' initialization complete\t\t\t\t\t\t[OK]');
  console.log('Http server running @ ' + config.http.host + ':' + config.http.port + ' in ' + process.env.NODE_ENV + ' mode\t\t[OK]');
}
app.listen(config.http.port);