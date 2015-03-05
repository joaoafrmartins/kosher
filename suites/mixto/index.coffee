describe 'Mixto', () ->

  it 'before', () ->

    kosher.alias 'Mixto'

  describe 'methods', () ->

    it 'should have "extend" method', () ->

      kosher.Mixto.extend.should.be.Function

    it 'should have "includeInto" method', () ->

      kosher.Mixto.includeInto.should.be.Function
