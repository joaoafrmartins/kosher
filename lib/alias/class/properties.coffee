kosher.alias 'properties', (list...) ->

  list.should.be.Array

  kosher.instance.should.be.Object

  list.map (prop) ->

    { name, type, value } = prop

    if not name then name = prop

    expect(name of kosher.instance).to.be.ok

    if typeof prop is "string" then return null

    if type then expect(typeof kosher.instance[name]).to.eql type

    if value then expect(kosher.instance[name]).to.eql value
