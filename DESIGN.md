# Design Notes

## Overall Goals

The goal of Chromatin is to be a tool assisting development of Perl 6
module distributions, from the very start, to "finish" (i.e. maintainenace
of the distro).

### Chromatin Core

The core needs to be as lean as possible and should not do much more than
handle:

    1. Parsing of `chroma.ini` configuration file
    2. Loading and execution of plugins and plugin bundles specified in
        `chroma.ini`
    3. Providing meta data in the `chroma.ini` to the executed plugins
    4. Provide information on the current
        [`chroma` execution cycles](#chroma-execution-cycles) to the
        executed plugins

### Plugins

All of the operational features provided by Chromatin are to be implemented as
plugins. The core distribution will include a bundle of plugins to make the
Chromatin core usable.

A single plugin can create any number of [commands](#command-plugins) as well
as perform any number of operations during any
[`chroma` execution cycle](#chroma-execution-cycles). The latter require
the inclusion of the plugin's name (without the `Chromatin::Plugin::` prefix)
in the `chroma.ini` file.

#### Command Plugins

## Configuration (`chroma.ini`)

## Execution

### `chroma` execution cycles