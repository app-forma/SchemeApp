/*jslint node: true, plusplus: true, vars: true, maxerr: 200, regexp: true, white: true */

var port = 30368,
	express = require("express"),
	app = express(),
	util = require('util'),
	spawn = require('child_process').spawn,
	fs = require('fs'),
	config = require('./config/config.js'),
	mongoose = require('./config/mongoose.js').dbInit(config);

var models_path = __dirname + '/app/models';
fs.readdirSync(models_path).forEach(function (file) {
  require(models_path+'/'+file);
});

app.use(express.static(__dirname + "/adminClient"));
app.use(express.bodyParser());
app.use(express.cookieParser());

app.get("/restart", function (req, res) {
	var output = '',
		updateScript = spawn('bash', ['updatetest.sh']);

	updateScript.stdout.on('data', function (data) {
		output = output + data;
	});

	updateScript.stderr.on('data', function (data) {
		output = output + data;
	});

	updateScript.on('exit', function (code) {
		res.json({
			exitCode: code,
			output: output
		});
	});
});


app.get("/populate", function (req, res) {
	res.json({
		populate: true,
		output: 'populated database.\n'
	});



});



console.log("SchemeAppAdmin server running at port " + port + '...');

app.listen(port);