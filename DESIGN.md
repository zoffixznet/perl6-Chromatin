# Design Notes

## Overall Goals

The goal of Chromatin is to be a tool assisting development of Perl 6
module distributions, from the very start, to "finish" (i.e. maintainenace
of the distro).

### Chromatin Core

The core needs to be as lean as possible and should not do much more than
handle:

1. Parsing of [`chroma.ini` configuration file](#configuration-chromaini)
2. Loading and execution of plugins and plugin bundles specified in
    [`chroma.ini`](#configuration-chromaini)
3. Providing meta data in the [`chroma.ini`](#configuration-chromaini)
    to the executed plugins
4. Provide information on the current
    [`chroma` execution cycles](#chroma-execution-cycles) to the
    executed plugins

### Plugins

All of the operational features provided by Chromatin are to be implemented as
plugins. The core distribution will include a bundle of plugins to make the
Chromatin core usable.

A single plugin can create any number of [commands](#command-plugins) as well
as perform any number of operations during any
[`chroma` execution cycle](#chroma-execution-cycles). The latter requires
the inclusion of the plugin
in the [`chroma.ini` file](#configuration-chromaini).

#### Command Plugins

A command plugin is one that provides a `Chroma::Command::foo` class, where
`foo` is the name of the command. The installation of such a class would make
`foo` command available to the [`chroma` executable](#execution), like so:

```bash
    chroma foo           # merely execute the command
    chroma foo gibblets  # execute the command with parameters
```

A command plugin can also introduce an
[execution cycle](#chroma-execution-cycles), in which case any plugins
specified in `chroma.ini` and that requested this particular execution cycle
will be called.

#### Execution Cycle Plugins

A plugin can excercise its features during any of the
[execution cycle](#chroma-execution-cycles) declared by
[command plugins](#command-plugins). To access this, the plugin must register
to be executed under a particular cycle and its name must also be included
in `chroma.ini`. For example:

```perl6
    # In lib/Chroma/Plugin/AwesomeTester.pm
    unit class Chroma::Plugin::CheckWeHaveTests;
    method register ($chroma) {
        given $chroma {
            .cycle('test'   ).execute: &tests;
            .cycle('xtest'  ).execute: &xtests;
            .cycle('release').execute: &release-tests;
        }
    }
    method tests   ($conf) { say "Running regular tests" }
    method xtests  ($conf) {
        $conf<no_author_tests> and die "Y u no run author tests?";
    }
    method release ($conf) { say "Running release tests" }
```

```ini
    ; In chroma.ini
    [AwesomeTester]
    no_author_tests = 1
```

## Configuration (`chroma.ini`)

## Execution

### `chroma` execution cycles