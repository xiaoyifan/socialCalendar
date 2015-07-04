var JOB_NAME = process.argv[2];
var JENKINS_PORT = 8080;
var JENKINS_HOST = 'localhost';
var BUILD_NAME = 'lastBuild';

var listOfChanges = [];

var parseBuild = function (data) {
	
  var changes = data.changeSet.items;
  
  // list the current change set
  
  for (var i = 0; i < changes.length; i += 1) {
		listOfChanges.push(' - ' + changes[i].msg);
	}
	
  // If the change set for the current build isn't more 
  // than one item (usually "Bump Version Number")
  // OR
  // if the build was a failure,
  // then get the previous build's changeset as well.
  
	if (changes.length > 1 && data.result != "FAILURE") {
		console.log(listOfChanges.join("\n"));
	} else {
    
    var previousBuildNumber = Number(data.number) - 1;
    listOfChanges.push('\n-----\n');
    
    requestBuild({
    	host: JENKINS_HOST,
    	port: JENKINS_PORT,
    	path: '/job/' + JOB_NAME + '/' + previousBuildNumber + '/api/json?pretty=true'
    });
	}
};

var requestBuild = function(requestObject) {
  
  require('http').request(requestObject, function (resp) {
  	var json = '';
	  
  	resp.setEncoding('utf8');
	
  	resp.on('data', function (chunk) {
  		json += chunk;
  	}).on('end', function () {
  		parseBuild(JSON.parse(json));
  	});
  }).end();
  
};

requestBuild({
	host: JENKINS_HOST,
	port: JENKINS_PORT,
	path: '/job/' + JOB_NAME + '/' + BUILD_NAME + '/api/json?pretty=true'
});