_ = require 'underscore'
fs = require 'fs-plus'
path = require 'path'

describe 'File Templates', ->
  [activationPromise, templateHash, indexPath] = []

  templateList = ->
    unless indexPath?
      indexPath = path.join(atom.config.get('file-templates.templateStore'), 'index.json')
    if fs.existsSync(indexPath)
      file = fs.readFileSync indexPath, "utf8"
      return JSON.parse file
    else
      return {}

  beforeEach ->
    activationPromise = atom.packages.activatePackage('file-templates')
    activationPromise.fail (reason) ->
      throw reason

  describe 'Adding a Template', ->
    it 'should appear at the top of the screen', ->
      modalCount = atom.workspace.getModalPanels().length
      editor = atom.workspace.getActiveTextEditor()

      atom.commands.dispatch atom.views.getView(atom.workspace), 'file-templates:new-template'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspace.getModalPanels().length).toBe (modalCount + 1)

    it 'should let you set a name', ->
      atom.commands.dispatch atom.views.getView(atom.workspace), 'file-templates:new-template'

      waitsForPromise ->
        activationPromise

      runs ->
        view = atom.workspace.getModalPanels()[0]

        view.item.miniEditor.setText('A Test Template')

    it 'should save the template', ->
      atom.commands.dispatch atom.views.getView(atom.workspace), 'file-templates:new-template'

      waitsForPromise ->
        activationPromise

      runs ->
        waitsForPromise ->
          atom.workspace.open()

        runs ->
          view = atom.workspace.getModalPanels()[0]
          delay = (Date.now() / 1000 | 0) + 2
          view.item.onConfirm 'SpecTestTemplate'

          waitsFor ->
            (Date.now() / 1000 | 0) == delay

          runs ->
            for template in _.values(templateList())
              templateHash = template.hash if template.name == 'SpecTestTemplate'

            expect(fs.existsSync(path.join(atom.config.get('file-templates.templateStore'), 'index.json'))).toBe true
            expect(fs.existsSync(path.join(atom.config.get('file-templates.templateStore'), templateHash + '.template'))).toBe true

  describe 'Listing Templates', ->
    it 'should have the template from earlier in the list', ->
      expect(templateList()[templateHash].name).toBe 'SpecTestTemplate'

      atom.commands.dispatch atom.views.getView(atom.workspace), 'file-templates:new-file'

      waitsForPromise ->
        activationPromise

      runs ->
        view = atom.workspace.getModalPanels()[0]

        found = false
        for templateLi in view.item.list.children('li')
          if templateLi.innerText == "SpecTestTemplate"
            found = true

        expect(found).toBe true

  describe 'Deleteting a Template', ->
    it 'should allow deletion of a template', ->
      atom.commands.dispatch atom.views.getView(atom.workspace), 'file-templates:delete-template'

      waitsForPromise ->
        activationPromise

      runs ->
        view = atom.workspace.getModalPanels()[0]
        delay = (Date.now() / 1000 | 0) + 2

        found = false
        for item in view.item.items
          if item.name == 'SpecTestTemplate'
            found = item

        expect(found).not.toBe false

        view.item.confirmed(item)

        waitsFor ->
          (Date.now() / 1000 | 0) == delay

        runs ->
          expect(templateList()[templateHash]).toBe undefined
