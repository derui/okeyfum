# What is it? #
`Okeyfum` = OCaml key function mapper.

This product is key function mapper made with pure OCaml. Okeyfum provides some funcitons below.

- remapping key to key sequence
- load configuration from file
  - configuration is similar to 窓使いの憂鬱 that is old good one for keyboard remapper.


# how to run #
Using default configuration path is `$HOME/.okeyfum` . If you want to use another file, you need to pass `-f` option with path of it.

```
$ okeyfum [options] [keyboard device]
```

NOTICE: Sometimes you need root priviledges to run okeyfum, so you need to use `sudo` or run with root.

# develop #
OKeyfum use dune. So development is standard way with dune.

```
# build
$ dune build
```

```
# run test
$ dune runtest
```

# Licence #
MIT
