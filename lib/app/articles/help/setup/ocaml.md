## Installing OCaml

Follow the [installation instructions](https://github.com/realworldocaml/book/wiki/Installation-Instructions) of the excellent [Real World OCaml](https://realworldocaml.org/) book. Afterwards be sure to install [OUnit](http://ounit.forge.ocamlcore.org/) using

```bash
opam install ounit
```

## Running Tests

Because OCaml is a compiled language you need to compile your submission and the test code before you can run the tests. Compile with

```bash
$ corebuild -quiet test.native
```

and when successful run the tests by running the `test.native` executable:

```bash
./test.native
```

Alternatively just type

```bash
make
```

## Creating Your First OCaml Module

To create a module that can be used with the test in the `bob` exercise put the following in a file named `bob.ml`:

```ocaml
open Core.Std let response_for input = failwith "TODO"
```

## Recommended Learning Resources

Exercism provides exercises and feedback but can be difficult to jump into for those learning OCaml for the first time. These resources can help you get started:

* [Documentation for the Standard Library](http://caml.inria.fr/pub/docs/manual-ocaml/libref/index.html)
* [OCaml at JaneStreet](https://ocaml.janestreet.com/)
* [Documentation for the Core Library](https://ocaml.janestreet.com/ocaml-core/latest/doc/core/index.html)
* [Caml programming guidelines](http://caml.inria.fr/resources/doc/guides/guidelines.en.html)

OCaml's documentation is spread over multiple projects and can be hard to find because there is what is sometimes called the standard library (the rather minimal library that comes with the compiler) and a Core library (a separate project by Jane Street that aims to provide a more complete and consistent standard library).

Confusingly the standard library is sometimes referred to as the core library (though rarely as the Core library).

The Core library itself consists of two parts: Core and Core_kernel where Core extends Core_kernel. Often a Core module includes a Core_kernel module, if that's the case the documentation will have a link to the Core_kernel module's documentation page. If you can't find a function it's often hidden in an included module. Note that when you do `open Core.Std` (which is a good idea) you're using the Core library which shadows some of the modules from the standard library.

For example, instead of [`List`](http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html) you get [`Core_kernel`'s `Core_list`](https://ocaml.janestreet.com/ocaml-core/latest/doc/core_kernel/Core_list.html) (`open Core.Std` makes this available under the name `List`).

There are some subtle and not so subtle differences between the standard library `List` module and `Core`'s `List`, for example in the standard library `List.for_all` has signature

```ocaml
val for_all : ('a -> bool) -> 'a list -> bool
```

whereas in the Core library it has

```ocaml
val for_all : 'a t -> f:('a -> bool) -> bool
```

The consequence is that to check if all numbers in a list are lower than 10 you have to write the following with the compiler core List module:

```ocaml
List.for_all (fun x -> x < 10) list
```

and with the Core List module you need to write:

```ocaml
List.for_all list (fun x -> x < 10)
```

or (preferably):

```ocaml
List.for_all ~f:(fun x -> x < 10) list
```

A piece of advice: focus on the Core library and ignore the standard library unless you really can't find what you need in Core.
