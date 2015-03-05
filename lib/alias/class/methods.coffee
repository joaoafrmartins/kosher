kosher.alias 'methods', (list...) ->

  list.should.be.Array

  if list.length is 1 and Array.isArray list[0]

    list = list[0]

  expect(kosher.instance).to.be.ok

  list.map (fn) ->

    expect(kosher.instance[fn]).to.be.ok

    kosher.instance[fn].should.be.Function
