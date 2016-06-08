Promise = require 'bluebird'
path = require 'path'
ECT = require 'ect'
_ = require 'lodash'
fs = require 'fs-extra'
dns = require 'dns'
dns.resolve = Promise.promisify dns.resolve
glob = Promise.promisify require 'glob'

reload = ->
  config = require('require-reload') path.join '../..', sails.config.templateDir, 'config'
  Promise
    .all _.map config.service, (name) ->
      Promise
        .all [dns.resolve(name, 'A'), dns.resolve(name, 'SRV')]
        .then (res) ->
          config[name] =
            a: res[0]
            srv: res[1]
    .then ->
      config

module.exports = 
  ect: (srcDir, destDir) ->
    renderer = ECT root: srcDir
    reload().then (config) ->
      glob path.join srcDir, '**/*.ect'
        .each (file) ->
          sails.log.info "rendering #{file}"
          rel = path.relative srcDir, file
          [folder, base] = [path.dirname(rel), path.basename(rel, '.ect')]
          dest = path.join destDir, folder, base
          fs.mkdirsSync path.dirname dest
          fs.writeFileSync dest, renderer.render(rel, config)
