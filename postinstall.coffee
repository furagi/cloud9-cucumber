fs = require 'fs'
async = require 'async'
path = require 'path'
ncp = require('ncp').ncp


paths = {
	modeList: path.resolve __dirname + '/../ace/lib/ace/ext/modelist.js'
	modeGherkin: path.resolve __dirname + '/../../plugins-client/lib.ace/www/mode/mode-gherkin.js'
	serverPluginsDir: path.resolve __dirname + '/../../plugins-server/cloud9.cucumber'
	nodeModulesDir: path.resolve __dirname + '/../watch'
};
async.waterfall [
	(next) -> fs.readFile paths.modeList, next
	(data, next) ->
		data = String data
		indexStart = data.indexOf 'var supportedModes'
		indexStart = 1 + data.indexOf '{', indexStart
		indexEnd = data.indexOf '}', indexStart
		if data.substring(indexStart, indexEnd).indexOf('gherkin') isnt -1
			return next()
		dataStart = data.substring 0, indexStart
		dataEnd = data.substring indexStart
		data = dataStart + '\ngherkin: ["gherkin|feature"],' + dataEnd
		fs.writeFile paths.modeList, data, next
	(next) -> fs.readFile 'mode-gherkin.js', next
	(data, next) -> fs.writeFile paths.modeGherkin, data, next
	(next) -> ncp './server/cloud9.cucumber', paths.serverPluginsDir,  next
	(next) -> ncp './node_modules/watch', paths.nodeModulesDir, next
], (err) ->
	if err
		console.log err