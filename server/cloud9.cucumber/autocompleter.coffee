fs = require 'fs'
crypto = require 'crypto'
async = require 'async'
_ = require 'underscore'
watch = require 'watch'



module.exports = class AutoCompleter
	constructor: (projectDir) ->			
		@phrases = {}
		@files = {}
		watcher = watch.createMonitor projectDir, {'ignoreDotFiles': on}, (monitor) =>
			monitor.on "created", (file, stat) =>
				if file.split('.').pop() isnt 'feature'
					return
				console.log 'File ' + file + ' was created'
				#update
				@_getPhrasesFromFile file
				
			monitor.on "changed", (file, curr, prev) =>
				if file.split('.').pop() isnt 'feature'
					return
				console.log 'File ' + file + ' was changed'
				#remove from index
				@_removeFromIndex file
				#update
				@_getPhrasesFromFile file

			monitor.on "removed", (file, stat) =>
				if file.split('.').pop() isnt 'feature'
					return
				console.log 'File ' + file + ' was removed'
				if stat.nlink is 0
					#remove from index
					@_removeFromIndex file

			@_readPath projectDir



	_readPath: (rootPath) ->
		if not rootPath?
			return
		fs.stat rootPath, (err, stat) =>
			if err?
				return console.log err
			if stat.isFile() and rootPath.split('.').pop() is 'feature'
				return @_getPhrasesFromFile rootPath
			if stat.isDirectory()
				fs.readdir rootPath, (err, paths) =>
					if err?
						return console.log err
					# console.log "Dir #{rootPath} was readed, paths = #{paths}" 
					for path in paths
						@_readPath rootPath + '/' + path				



	_removeFromIndex: (path) ->
		hash = crypto.createHash 'md5'
		hash.update path, 'utf8'
		pathHash = hash.digest 'hex'
		if not @files[pathHash]?
			return
		file = @files[pathHash]
		phrases = file.phrases
		for phraseHash in phrases
			if not @phrases[phraseHash]?
				continue
			index = @phrases[phraseHash].paths.indexOf pathHash
			if index isnt -1
				@phrases[phraseHash].paths.splice index, 1
		delete @files[pathHash]	



	_getPhrasesFromFile: (file) ->
		console.log 'Read file ' + file
		fs.readFile file, (err, data) =>
			if err?
				return console.log err
			data = data.toString()
			if data is ''
				return console.log 'File ' + file + ' is empty'
			data = data.replace /\b[0-9]{1,}\b/g, '$d'
			steps = data.match /(Given|When|Then|And).+/gm
			tags = data.match /@(\w|\W).+/gm
			phrases = []
			if tags? and tags.length
				phrases = tags 
			if steps? and steps.length
				phrases = phrases.concat steps
			if phrases.length is 0
				return
			hash = crypto.createHash 'md5'
			hash.update file, 'utf8'
			pathHash = hash.digest 'hex'
			if not @files[pathHash]?
				@files[pathHash] = {path: file, phrases: []}
			for phrase in phrases
				hash = crypto.createHash 'md5'
				hash.update phrase, 'utf8'
				phraseHash = hash.digest 'hex'
				if not @phrases[phraseHash]?
					@phrases[phraseHash] = {paths: [pathHash], phrase: phrase}
				else
					if @phrases[phraseHash].paths.indexOf(pathHash) is -1
						@phrases[phraseHash].paths.push pathHash
				if @files[pathHash].phrases.indexOf(phraseHash) is -1
					@files[pathHash].phrases.push phraseHash
			console.log 'Phrases is '
			console.log @phrases
			console.log 'Files is '
			console.log @files
			


	_onFileChanged: (event, file) =>
		fs.exists file, (exists) =>
			if not exists
				return console.log 'File ' + file + ' was deleted'
			@_getPhrasesFromFile file



	getPhrases: (query) ->
		result = []
		query = query.replace /\b[0-9]{1,}\b/, '$d'
		for phraseHash, phraseObject of @phrases
			if phraseObject.phrase.indexOf(query) > -1
				result.push phraseObject.phrase
		result.sort (phrase1, phrase2) ->
			if phrase1.length < phrase2.length
				return 1
			return -1
