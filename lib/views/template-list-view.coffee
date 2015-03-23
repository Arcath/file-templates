{SelectListView} = require 'atom-space-pen-views'

_ = require 'underscore'
fs = require 'fs-plus'
path = require 'path'

{$, $$, View} = require 'space-pen'

module.exports =
  class NewFileView extends SelectListView
    viewForItem: (item) ->
      $$ -> @li(item.name)

    attach: ->
      @panel = atom.workspace.addModalPanel(item: this)
      @storeFocusedElement()
      @filterEditorView.focus()
      @setItems _.values(@templateList())

    cancel: ->
      super
      @panel.hide()
      atom.workspace.getActivePane().activate()

    getFilterKey: ->
      "name"

    templateList: ->
      indexPath = path.join(atom.config.get('file-templates.templateStore'), 'index.json')
      if fs.existsSync(indexPath)
        file = fs.readFileSync indexPath, "utf8"
        return JSON.parse file
      else
        return {}
