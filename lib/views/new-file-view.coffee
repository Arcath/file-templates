TemplateListView = require './template-list-view'

fs = require 'fs-plus'
path = require 'path'

module.exports =
  class NewFileView extends TemplateListView
    confirmed: (item) ->
      @cancel()
      atom.workspace.open().then ->
        contents = fs.readFileSync path.join(atom.config.get('file-templates.templateStore'), item.hash + '.template'), "utf8"
        grammar = atom.grammars.grammarForScopeName(item.grammarScope)

        atom.workspace.getActiveTextEditor().setText(contents)
        if grammar
          atom.workspace.getActiveTextEditor().setGrammar(grammar)
