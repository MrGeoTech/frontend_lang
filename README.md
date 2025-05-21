# Frontend Language

A language designed for user interface development, with an emphasis on developer experience and enforced completeness. This means forcing developers to use secure practices and consider things often overlooked, such as accesibility.

The language is designed similar to configuration languages such as yaml and nix.

## File Structure

The file system is a major part of how the language works, with directories acting as a package and files acting as interface components. There are two main file types, `.fel` and `.feo`. `.fel` files are used to describe interface components. `.feo` files are used to describe objects/types.

To better understand, have a look at the following `component.feo` file:

```feo
contents: string | component[] < Hello world!
style: ?ui/component_style
```

As you can see, the object files follow the general pattern of `<name>: <type>`. In this example, the object has two fields. The first one is `contents`, which is either a string or a list of components. It has default value of `Hello world!`. The second is `style`, which is an optional component style. Optional fields can be exculuded in initialization of the objects. 
