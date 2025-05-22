# Frontend Language

A language designed for user interface development, with an emphasis on developer experience and enforced completeness. This means forcing developers to use secure practices and consider things often overlooked, such as accessibility.

The language is designed similar to configuration languages such as yaml and nix.

## File Structure

The file system is a major part of how the language works, with directories acting as a package and files acting as interface components. There are two main file types, `.fel` and `.feo`. `.fel` files are used to describe interface components. `.feo` files are used to describe objects/types.

To better understand, have a look at the following `customer.feo` file:

```feo
name: string
location: ?geo/location < 'null'
```

As you can see, the object files follow the general pattern of `<name>: <type> (< <defualt_value>)`. The types can either builtin types, like `string`, `int`, `bool`, etc. or other objects, in which the type is the root path to the file. For this example, `location` is of type `object`, defined by `src/geo/location.feo`. Types can also be composed and/or be defined as literals. `null` is just a special literal that has additional language support. Otherwise, it can be treated as a literal.

The following lines of code are equivalent, though the first one will get you a compiler error so that nobody does it.
```feo
name: 'null' | string
name: ?string
```

Another feature of the language is that if an object is composed of fields, all with default values, all fields of that object type will be treated like they have a default value. For example:

If you have the following `object_1.feo`
```feo
field_1: string < 'Hello'
field_2: string < 'World!'
```
the following `object_2.feo` are equivalent, with the first one generating a compiler error as well.
```feo
/ What are we doing here?
object_instance: object_1 < { field_1: 'Hello', field_2: 'World!' }
```

```feo
/ This is better. No errors!
object_instance: object_1
```
You can still have default values, they just have to be different from the implied default, like so:
```feo
/ This is fine
object_instance: object_1 < { field_1: 'Goodbye', field_2: 'World!' }
```

To then convert these state object into a user interface, you have to use `.fel` files. Try to keep the files as small and single purpose as possible. This helps with code organization. I know that this may be uncomfortable for some people and may feel like more work but the language is designed to compose many small, single focus components together. Any time "wasted" when writing will be compensated for with the ease of modifiablity and correctness.

An example of displaying the previously created customer object follows:

`customer_name_label.fel`:
```fel
content: 'Name:'
accessibility: 'text'
```
