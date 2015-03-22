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

    confirmed: (item) ->
      @cancel()
      atom.workspace.open().then ->
        contents = fs.readFileSync path.join(atom.config.get('file-templates.templateStore'), item.hash + '.template'), "utf8"
        grammar = atom.grammars.grammarForScopeName(item.grammarScope)

        atom.workspace.getActiveEditor().setText(contents)
        if grammar
          atom.workspace.getActiveEditor().setGrammar(grammar)

    cancel: ->
      super
      @panel.hide()
      atom.workspace.getActivePane().activate()

    attached: ->
      file = fs.readFileSync path.join(atom.config.get('file-templates.templateStore'), 'index.json'), "utf8"
      json = JSON.parse file

      @setItems _.values(json)

    getFilterKey: ->
      "name"
