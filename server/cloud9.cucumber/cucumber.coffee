util = require "util"
Plugin = require "../cloud9.core/plugin"
AutoCompleter = require './autocompleter'


name = "cucumber"
module.exports = setup = (options, imports, register) ->
    imports.ide.register name, CucumberPlugin, register


CucumberPlugin = (ide, workspace) ->
    Plugin.call @, ide, workspace

    @workspaceId = workspace.workspaceId
    @workspaceDir = ide.workspaceDir
    @completer = new AutoCompleter @workspaceDir
    @hooks = ["command"]
    @name = name

util.inherits CucumberPlugin, Plugin

( ->

    @metadata = {
        "commands": {
            "autocomplete" : {
                "hint": "autocomplete tag or step"
            }
        }
    }

    @command = (user, message, client) ->
        if not @["command-" + message.command]
            return off

        if message.runner? and message.runner isnt "cucumber"
            return off

        @["command-" + message.command.toLowerCase()](message)

        return on


    @["command-cucumber-autocomplete"] = (message) ->
        matches = @completer.getPhrases message.line
        console.log matches
        @sendResult 0, "cucumber-autocomplete", {
            matches: matches,
            line: message.line
        }
).call CucumberPlugin.prototype
