describe 'Emitter', () ->

  it 'before', () ->

    kosher.alias 'Emitter'

    kosher.alias 'instance', new kosher.Emitter

  describe 'methods', () ->

    it 'mixins', () ->

      kosher.methods(

        "on",

        "once",

        "off",

        "emit",

        "pauseEvents",

        "resumeEvents",

        "getSubscriptionCount"

      )
