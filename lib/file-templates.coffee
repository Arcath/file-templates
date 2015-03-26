path = require 'path'

DeleteTemplateView = require './views/delete-template-view'
NewFileView = require './views/new-file-view'
NewTemplateView = require './views/new-template-view'
UpdateTemplateListView = require './views/update-template-list-view'

module.exports =
  config:
    templateStore:
      type: 'string'
      default: path.join atom.getUserInitScriptPath(), '../', 'file-templates'

  deleteTemplateView: null
  newFileView: null
  newTemplateView: null
  updateTemplateListView: null

  activate: ->
    atom.commands.add 'atom-workspace', 'file-templates:delete-template', => @deleteTemplate()
    atom.commands.add 'atom-workspace', 'file-templates:new-file', => @newFile()
    atom.commands.add 'atom-workspace', 'file-templates:new-template', => @newTemplate()
    atom.commands.add 'atom-workspace', 'file-templates:update-template', => @updateTemplate()

    @deleteTemplateView = new DeleteTemplateView
    @newFileView = new NewFileView
    @newTemplateView = new NewTemplateView
    @updateTemplateListView = new UpdateTemplateListView

  newFile: ->
    @newFileView.attach()

  newTemplate: ->
    @newTemplateView.attach()

  deleteTemplate: ->
    @deleteTemplateView.attach()

  updateTemplate: ->
    @updateTemplateListView.attach()
