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

    cancel: ->
      super
      @panel.hide()
      atom.workspace.getActivePane().activate()

    attached: ->
      @setItems _.values(@templateList())

    getFilterKey: ->
      "name"

    templateList: ->
      file = fs.readFileSync path.join(atom.config.get('file-templates.templateStore'), 'index.json'), "utf8"
      JSON.parse file
