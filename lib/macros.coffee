Macroses =
  'timestamp': -> (new Date()).toISOString()
  'author':    -> atom.project.getRepositories()[0].getConfigValue('user.name')
  'email':     -> atom.project.getRepositories()[0].getConfigValue('user.email')

module.exports.process = (text) ->
  text.replace /@(\w+)@/g, (_, $1) -> try
    Macroses[$1]()
  catch error
    '@'+$1
