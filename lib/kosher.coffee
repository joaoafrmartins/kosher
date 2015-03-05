{ EOL } = require 'os'

{ dirname } = require 'path'

{ existsSync } = require 'fs'

requireTree = require 'require-tree'

class Kosher

  mockery: require 'mockery'

  constructor: (@options={}) ->

    options = @options

    specDirname = options.specDirname or 'spec'

    global.kosher = @

    caller = dirname(module.parent.parent)

    @root ?= resolve options.root or dirname(caller) or process.cwd()

    @suite ?= options.suite or basename(@root).replace(/\.[a-z]+$/,'')

    @specRoot ?= options.spec or caller or resolve(@root, specDirname)

    @aliasMap ?= options.aliasMap or {}

    @cache ?= {}

    @conf ?=

      warnOnReplace: false

      warnOnUnregistered: false

    @mockRoot ?= options.mock or resolve @specRoot, 'spec', 'mocks'

    if existsSync @mockRoot

      requireTree @mockRoot

  alias: (alias, object) ->

    _file = () =>

      @aliasMap ?= {}

      file = @aliasMap[alias] or @root or process.cwd()

      @aliasMap[alias] = file

      return require file

    @[alias] = object or @[alias] or _file()

  resolve: (pieces...) ->

    pieces.unshift  @root

    return resolve.apply null, pieces

  module: (options) ->

    _camelize = (str) ->

      return str.replace /[-_\s]+(.)?/g, (match, c) ->

        return if c then c.toUpperCase() else ''

    _underscorize = (str) ->

      return str

        .replace(/([a-z\d])([A-Z]+)/g, '$1_$2')

        .replace(/[-\s]+/g, '_').toLowerCase()

    _capitalize = (str) ->

      return str.charAt(0).toUpperCase() + str.slice(1)

    if typeof options is "string" then options = root: options

    options ?= {}

    options.root ?= resolve @root, 'lib'

    options.filter ?= (file) ->

      return !file.match /main\.[a-z]+$/

    options.name ?= (obj, file) =>

      @aliasMap ?= {}

      alias = file.replace /\.[a-z]+$/, ''

      alias = _capitalize _camelize _underscorize alias

      @aliasMap[alias] = file

      return alias

    _module = requireTree options.root, options

    for alias, definition of _module

      @alias alias, definition

  mock: (mocklist...) ->

    @mockery.deregisterAll()

    _push = (args) =>

      mocks = []

      for mock in args

        if typeof mock is "string"

          if typeof @cache[mock] is "undefined"

            throw new Error "mock #{mock} is missing"

          mocks.push @cache[mock]

        if typeof mock is "object"

          { module, mock: definition } = mock

          if not module or not definition

            throw new Error "invalid #{mock} definition"

          @cache[module] = mock

          mocks.push @cache[module]

      return mocks

    _register = (mocks) =>

      mocks.map (mock) =>

        @mockery.registerMock mock.module, mock.mock

    if mocklist.length > 0

      _register _push mocklist

      @mockery.enable @conf

    else @mockery.disable()

  setup: () ->

    shell = null

    Object.defineProperty @, 'shell',

      get: () -> return shell = require 'shelljs/global'

    specRoot = null

    Object.defineProperty @, 'spec',

      get: () ->

        try

          throw new Error "context"

        catch context

          lines = context.stack.split EOL

          context = lines[2]

          val = context.

            replace(/^.*\(/,'').

            replace(/\:[0-9]+\:[0-9]+\).*$/,'')

          while not existsSync resolve val, 'package.json'

            val = resolve val, '..'

          specRoot = resolve val, @options.specDirname or 'spec'

          mockRoot = resolve specRoot, @options.specDirname or 'mocks'

          if existsSync mockRoot

            requireTree mockRoot

          return requireTree specRoot,

            filter: (file) -> return !file.match /^specs/


    tmp = null

    Object.defineProperty @, "tmp",

      get: () ->

        return tmp

      set: (dir) ->

        @shell

        if dir is null

          rm "-Rf", resolve(specRoot, "tmp")

        else if dir

          dir = resolve specRoot, "tmp", dir

          if test "-e", dir

            rm "-Rf", dir

          mkdir "-p", dir

          tmp = dir

    requireTree resolve __dirname, 'alias'

  specs: () ->

    require resolve @root, 'spec', 'specs'

  teardown: () ->

    #@tmp = null

    #@spec = requireTree @specRoot,

    #  filter: (filename) ->

    #    return filename.match /^teardown/

module.exports = Kosher
