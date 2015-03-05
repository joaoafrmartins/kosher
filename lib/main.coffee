# requires

{ resolve } = require 'path'

require 'should'

chai = require 'chai'

spies = require 'chai-spies'

chai.use spies

# globals

{ resolve: global.resolve, basename: global.basename } = require 'path'

{ expect: global.expect, assert: global.assert, spy: global.spy } = chai

{ existsSync } = require 'fs'

Kosher = require resolve __dirname, 'kosher'

kosher = new Kosher global.kosher

global.kosher = kosher

# setup

kosher.setup()

# spec

describe "#{kosher.suite}", () ->

  # specs

  kosher.specs()

# teardown

kosher.teardown()
