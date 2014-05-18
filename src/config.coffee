# Server Configuration
# =================================================
# To configure the system add some `config.cml` file in the `local` folder like
# done in the `src` folder.

# Node Modules
# -------------------------------------------------

# include base modules
fs = require 'alinex-fs'
path = require 'path'
async = require 'async'
yaml = require 'js-yaml'
debug = require('debug')('server:startup')
errorHandler = require 'alinex-error'

# Merge configuration
# -------------------------------------------------
# Merge the configuration from `src` and `locale` into `lib`.
module.exports.merge = (cb = ->) ->
  dir = path.join ROOT_DIR, 'src', 'config'
  # search for all configuration files
  fs.find dir, { include: '*.yml' }, (err, list) ->
    return cb err if err
    # process each possible config file
    async.each list, (file, cb) ->
      #
      async.map [
        path ROOT_DIR, 'src', 'config', file
        path ROOT_DIR, 'local', 'config', file
      ], (file, cb) ->
        fs.exists file, (exists) ->
          return cb null, {} unless exists
        fs.readfile file, 'utf8', (err, data) ->
          return cb err if err
          cb yaml.safeLoad data
      , (err, results) ->
        return cb err if err
        # merge results
        return cb null, results[0] unless results[1]
        cb ull, util.deepExtend results[0], results[1]
    , cb
