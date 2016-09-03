module.exports =
  macros:
    timestamp: ->
      (new Date()).toISOString()

    author: ->
      atom.project.getRepositories()[0].getConfigValue('user.name')

    email: ->
      atom.project.getRepositories()[0].getConfigValue('user.email')

  process: (text) ->
    text.replace /@(\w+)@/g, (_, $1) -> try
      module.exports.macros[$1]()
    catch error
      '@' + $1 + '@'
