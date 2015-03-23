{TextEditorView} = require 'atom-space-pen-views'

crypto = require 'crypto'
fs = require 'fs-plus'
path = require 'path'

{$, View} = require 'space-pen'

module.exports =
  class NewTemplateView extends View
    @content: ->
      @div class: 'overlay from-top', =>
        @h4 'New Template'
        @label 'Template Name'
        @subview 'miniEditor', new TextEditorView(mini: true)
        @button outlet: 'createButton', class: 'btn', 'Create'

    initialize: ->
      atom.commands.add @element,
        'core:confirm': => @onConfirm(@miniEditor.getText())
        'core:cancel': => @destroy()

      @createButton.on 'click', => @onConfirm(@miniEditor.getText())

    attach: ->
      @panel = atom.workspace.addModalPanel(item: this)
      @miniEditor.focus()

    destroy: ->
      @panel.destroy()
      atom.workspace.getActivePane().activate()

    onConfirm: (name) ->
      contents = atom.workspace.getActiveTextEditor().getText()
      templateHash = crypto.createHash('sha1').update(name + contents).digest('hex')

      @destroy()
      @miniEditor.setText('')

      fs.readFile path.join(atom.config.get('file-templates.templateStore'), 'index.json'), (err, data) ->
        if err
          if err.code == "ENOENT"
            templates = {}
          else
            throw err
        else
          templates = JSON.parse(data)

        templates[templateHash] = {
          "name": name
          "author": 'local'
          "hash": templateHash
          "grammarScope": atom.workspace.getActiveTextEditor().getGrammar().scopeName
        }

        json = JSON.stringify templates

        fs.writeFileSync path.join(atom.config.get('file-templates.templateStore'), 'index.json'), json
        fs.writeFileSync path.join(atom.config.get('file-templates.templateStore'), templateHash + '.template'), contents

        atom.notifications.addSuccess("Template #{name} created")
