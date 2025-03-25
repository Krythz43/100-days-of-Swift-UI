we can’t modify properties in our views because they are structs, and are therefore fixed.

@propertyWrapper public struct State<Value> : DynamicProperty {
That @propertyWrapper attribute is what makes this into @State for us to use.

public var wrappedValue: Value { get nonmutating set }
