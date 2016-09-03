module.exports =
  macros:
    timestamp: ->
      (new Date()).toISOString()

    author: ->
      atom.project.getRepositories()[0].getConfigValue('user.name')

    email: ->
      atom.project.getRepositories()[0].getConfigValue('user.email')

  process: (text) ->
    macros = @merge @macros, process.fileTemplates?.macros
    text.replace /@(\w+)@/g, (_, $1) -> try
      macros[$1]()
    catch error
      '@' + $1 + '@'

  merge: (xs...) ->
    tap = (o, fn) -> fn(o); o

    if xs?.length > 0
      tap {}, (m) -> m[k] = v for k, v of x for x in xs
