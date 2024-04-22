# Beansense

Beansense is a web finance application that uses
[beancount](https://beancount.github.io) as source of data.

WARNING: This repository is in very early stages of development and not ready for use yet.

## Development

This repository is using nix to manage all required dependencies and support
hermetic builds of the binary. Once you install nix, all other dependecies will
install automatically once you enter the directory (you will need to run
`direnv allow` to actually make it work).
