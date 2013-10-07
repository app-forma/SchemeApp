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
	require(models_path + '/' + file);
});

app.use(express.static(__dirname + "/adminClient"));
app.use(express.bodyParser());
app.use(express.cookieParser());

/* -------------- Restart server -------------- */
app.get("/restart", function (req, res) {
	var output = '',
		updateScript = spawn('bash', ['update.sh']);
	updateScript.stdout.on('data', function (data) {
		output = output + data;
	});
	updateScript.stderr.on('data', function (data) {
		output = output + data;
	});
	updateScript.on('exit', function (code) {
		res.json({
			exitCode: code,
			output: 'Server restarted.\n' + output
		});
	});
});

/* -------------- Drop database -------------- */
app.get("/drop", function (req, res) {
	/*mongoose.connection.db.dropDatabase(function (err) {
		if (err) {
			res.json({
				output: 'Something went wrong!\n'
			});
		} else {
			res.json({
				output: 'Database dropped.\n'
			});
		}
	});*/
});

/* -------------- Populate -------------- */
/*app.get("/populate", function (req, res) {
	var json = fs.readFile('populationdata.json', 'utf-8', function (json) {
		if (json) {
			res.json({
				populate: true,
				output: json + '\n'
			});
		} else {
			res.json({
				populated: false,
				output: 'could not read population file.\n'
			});
		}
	});
});
*/
console.log("SchemeAppAdmin server running at port " + port + '...');

app.listen(port);