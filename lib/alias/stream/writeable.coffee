{Writable} = require 'stream'

class WriteableStream extends Writable

  constructor: (options={}) ->

    super options

  write: (data) -> @emit 'data', data

  end: () -> @emit 'end'

  destroy: () -> @emit 'close'

kosher.alias 'WriteableStream', WriteableStream
