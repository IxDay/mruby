# Hello

This is a sample project to demonstrate the use of `mrake` in a Golang setup.

## Prerequisites

You need the following tools installed
- Golang
- Templ: https://templ.guide/
- MRuby and MRake obviously

## How to

You can simply list the tasks which can be executed with `mrake -T`.
The default task (by just typing `mrake`)
will build the binary of the project in the `out` directory.

**Features showcased**

- Build OS specific path in
- Glob pattern for file tasks
- Rules
- Directory creation ([hard to achieve through make][make_directory])

[make_directory]: https://stackoverflow.com/questions/1950926/create-directories-using-make-file
