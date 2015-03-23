TemplateListView = require './template-list-view'

fs = require 'fs-plus'
path = require 'path'

module.exports =
  class DeleteTemplateView extends TemplateListView
    confirmed: (item) ->
      @cancel()
      pathToDelete = path.join(atom.config.get('file-templates.templateStore'), item.hash + '.template')
      fs.unlinkSync pathToDelete
      templates = @templateList()
      delete templates[item.hash]

      json = JSON.stringify templates

      fs.writeFileSync path.join(atom.config.get('file-templates.templateStore'), 'index.json'), json

      atom.notifications.addSuccess("Template #{item.name} deleted")
