TemplateListView = require './template-list-view'
UpdateTemplateView = require './update-template-view'

fs = require 'fs-plus'
path = require 'path'

module.exports =
  class UpdateTemplateListView extends TemplateListView
    confirmed: (item) ->
      @cancel()
      updateTemplateView = new UpdateTemplateView(item)
      updateTemplateView.attach()
