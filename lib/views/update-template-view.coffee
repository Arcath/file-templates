{TextEditorView} = require 'atom-space-pen-views'

crypto = require 'crypto'
fs = require 'fs-plus'
path = require 'path'

{$, View} = require 'space-pen'

module.exports =
  class UpdateTemplateView extends View
    template: null

    @content: (template) ->
      @div class: 'overlay from-top', =>
        @h4 'Update Template'
        @label 'Name'
        @subview 'nameEditor', new TextEditorView(mini: true)
        @label 'Grammar'
        @subview 'grammarEditor', new TextEditorView(mini: true)
        @button outlet: 'updateButton', class: 'btn', click: 'updateTemplate', 'Update'
        @button outlet: 'editContentsButton', class: 'btn', click: 'editContents', 'Edit Template'

    initialize: (template) ->
      atom.commands.add @element,
        'core:cancel': => @destroy()

      @template = template
      @nameEditor.setText(template.name)
      @grammarEditor.setText(template.grammarScope)

    attach: ->
      @panel = atom.workspace.addModalPanel(item: this)
      @nameEditor.focus()

    destroy: ->
      @panel.destroy()
      atom.workspace.getActivePane().activate()

    updateTemplate: (event, element) ->
      @destroy()
      @template.name = @nameEditor.getText()
      @template.grammarScope = @grammarEditor.getText()

      list = @templateList()
      list[@template.hash] = @template

      json = JSON.stringify list

      console.dir json

      fs.writeFileSync path.join(atom.config.get('file-templates.templateStore'), 'index.json'), json

    editContents: (event, element) ->
      @destroy()
      item = @template
      atom.workspace.open(path.join(atom.config.get('file-templates.templateStore'), item.hash + '.template')).then ->
        grammar = atom.grammars.grammarForScopeName(item.grammarScope)

        if grammar
          atom.workspace.getActiveTextEditor().setGrammar(grammar)

    templateList: ->
      indexPath = path.join(atom.config.get('file-templates.templateStore'), 'index.json')
      if fs.existsSync(indexPath)
        file = fs.readFileSync indexPath, "utf8"
        return JSON.parse file
      else
        return {}
