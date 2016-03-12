describe "User", ->
  describe "#canDrink", ->
    assertCanDrink = (name, age, canDrink) ->
      user = new User(name, 25)
      expect(user.canDrink()).toBe(canDrink)

    target = [
      {name: 'User1', age: 18, canDrink: false}
      {name: 'User2', age: 19, canDrink: false}
      {name: 'User3', age: 20, canDrink: true}
      {name: 'User4', age: 21, canDrink: true}
      {name: 'User5', age: 22, canDrink: true}
    ]

    for t in target
      it "#{t.age}", ->
        assertCanDrink(t.name, t.age, t.canDrink)
