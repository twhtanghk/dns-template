path = require 'path'

module.exports =
  ect: (req, res) ->
    src = path.join sails.config.templateDir, 'src'
    dst = path.join sails.config.templateDir, 'dst'
    sails.services.template.ect src, dst
      .then res.ok
      .catch res.serverError
