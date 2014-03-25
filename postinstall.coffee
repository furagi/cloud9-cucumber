fs = require 'fs'
async = require 'async'
path = require 'path'
# ncp = require('ncp').ncp


paths = {
	modeList: path.resolve __dirname + '/../ace/lib/ace/ext/modelist.js'
	modeGherkin: path.resolve __dirname + '/../../plugins-client/lib.ace/www/mode/mode-gherkin.js'
	pluginsList: path.resolve __dirname + '/../../configs/default.js'
	clientPluginsDir: path.resolve __dirname + '/../../plugins-client'
	serverPluginsDir: path.resolve __dirname + '/../../plugins-server'
	nodeModulesDir: path.resolve __dirname + '/../'
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
		fs.writeFile __dirname + paths.modeList, data, next
	(next) -> fs.readFile 'mode-gherkin.js', next
	(data, next) -> fs.writeFile paths.modeGherkin, data, next
	(next) -> fs.readFile paths.pluginsList, next
	(data, next) ->
		data = String data
		# var config = [
		indexStart = data.indexOf 'var config'
		indexStart = 1 + data.indexOf '[', indexStart
		indexEnd = data.indexOf ';', indexStart
		if data.substring(indexStart, indexEnd).indexOf('./cloud9.cucumber') is -1
			dataStart = data.substring 0, indexStart
			dataEnd = data.substring indexStart
			data = dataStart + '\n"./cloud9.cucumber",' + dataEnd
		fs.writeFile paths.pluginsList, data, next
	(next) -> ncp './client/ext.cucumber', paths.clientPluginsDir, next
	(next) -> ncp './server/cloud9.cucmber', paths.serverPluginsDir,  next
	(next) -> ncp './node_modules/watch', paths.nodeModulesDir, next
], (err) ->
	if err
		console.log err