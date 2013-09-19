var server, log = document.getElementById("log"),
	logText = "";

document.getElementById("restart").onclick = function () {
	addLogText('Restarting server, please wait...\n');
	requestAt('restart');
};

document.getElementById("populate").onclick = function () {
	addLogText('Flushing and repopulating server, please wait...\n');
	requestAt('populate');
};

function requestAt(url) {
	server.get(url, function (success, response) {
		if (success) {
			addLogText(response.output);
		} else {
			addLogText("Could not execute command.");
		}
	});
}

function addLogText(text) {
	logText = text + logText;
	log.innerHTML = logText;
}