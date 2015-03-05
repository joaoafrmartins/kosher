kosher.alias 'argv', (argv...) ->

  process._argv ?= process.argv

  if argv.length is 0

    old = process.argv

    process.argv = process._argv

    return old

  return process.argv = [null, null].concat argv
