describe "User", ->
  describe "#canDrink", ->
    assertCanDrink = (name, age, canDrink) ->
      it "Age:#{age}, CanDrink:#{canDrink}", ->
        user = new User(name, age)
        expect(user.canDrink()).toBe(canDrink)

    gss = new GoogleSpreadsheetsParser(
      'https://docs.google.com/spreadsheets/d/1LjDMRm8j_0XHJiOF7DZuYWUXQHYpZ6MxRnMkh25plZ8/pubhtml'
      {sheetTitle: 'v001', hasTitle: true}
    )

    # target = [
    #   {no: 1, name: 'User1', age: 18, canDrink: false}
    #   {no: 2, name: 'User2', age: 19, canDrink: false}
    #   {no: 3, name: 'User3', age: 20, canDrink: true}
    #   {no: 4, name: 'User4', age: 21, canDrink: true}
    #   {no: 5, name: 'User5', age: 22, canDrink: true}
    # ]
    target = JSON.parse(gss.toJson())

    for t in target
      assertCanDrink(t.name, parseInt(t.age), t.canDrink == 'true')

