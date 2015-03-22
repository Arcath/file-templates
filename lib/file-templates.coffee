path = require 'path'

NewFileView = require './views/new-file-view'
NewTemplateView = require './views/new-template-view'

module.exports =
  config:
    templateStore:
      type: 'string'
      default: path.join atom.getUserInitScriptPath(), '../', 'file-templates'

  newTemplateView: null

  activate: ->
    atom.commands.add 'atom-workspace', 'file-templates:new-file', => @newFile()
    atom.commands.add 'atom-workspace', 'file-templates:new-template', => @newTemplate()

    @newFileView = new NewFileView
    @newTemplateView = new NewTemplateView

  newFile: ->
    @newFileView.attach()

  newTemplate: ->
    @newTemplateView.attach()
