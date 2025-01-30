HelmYS
======

<!--
== Protect against not using --post-renderer helmys with something like:

=>:: {kind: ERROR See https://xyzzy.ai, apiVersion: E, name}
# Or:

#------------------------------------------------------------------------------
# This chart requires `helm install ... --post-renderer helmys` to install.
#
# Using `--post-renderer helmys` will remove the following lines.
#
# Not using `--post-renderer helmys` to install this chart will cause the lines
# to not be removed, which is intended to cause the install to fail and show
# the information of why it failed.
#------------------------------------------------------------------------------

apiVersion: apps/v1
kind: Deployment
metadata:
  name: |-
    ERROR 'helm install' requires --post-renderer helmys
    See https://github.com/kubeys/helmys
-->

Helm + YS - Support YAMLScript in Helm Templates


## Synopsis

Installation:

```
$ git clone https://github.com/kubeys/helmys
$ make -C helmys install PREFIX=$HOME/.local
```

Chart Setup:
```
$ helmys init <chart>
```

Usage:
```
$ helm install <name> <chart> --post-renderer helmys
```

or:
```
$ helmys install <name> <chart>
```


## Description

The `helmys` (pronounced "helm wise") command provides a way to use YAMLScript
for Helm templating.
You can use as much or as little [YAMLScript](https://yamlscript.org) in your
Helm templates as you wish, replacing all the Go templating syntax or none of
it.

Using YAMLScript for your templating needs is much cleaner than the standard Go
templating.
See this side by side template file comparison of a full conversion:
<https://yamlscript.org/doc/helmys>.

In addition, templates that use YAMLScript exclusively for templating are valid
YAML files, thus various YAML tools like `yamllint` can be used on them.


## Setting It Up

Setting up HelmYS is very simple.
Just install `helmys` and `ys` (the YAMLScript CLI binary), then initialize
your chart.


### Installing `helmys` and `ys`

In this directory, run:
```
make install PREFIX=~/.local
```

This will install `helmys` in `$PREFIX/bin/`.
It will also install the YAMLScript binary `ys` in `$PREFIX/bin/` if it is not
already there.

> **Note**: You can use any directory absolute path for `PREFIX` as long as it
> contains a `bin/` directory that is in your shell `PATH`.
> Also `ys` must be version `0.1.87` or higher.

You can also install each of these separately with:
```
make install-helmys PREFIX=~/.local
make install-ys PREFIX=~/.local
```


### Initializing your chart

Run:
```
helmys init <chart>
```

This will install the following 2 template files in your chart which is all you
need to start installing charts that use YAMLScript:

* `templates/helmys.yaml`
  Expose the Helm primary variables `Chart`, `Values` and `Release` as
  YAMLScript variables with the same names.
* `templates/helpers.yaml`
  A YAMLScript port of the default `_helpers.tpl` Go template file.
  This supports everything for the templates generated by `helm create`.
  You are encouraged to add your own functions and variables to it.


## Using `helm install ... --post-renderer helmys`

Just add the `--post-renderer helmys` option to your `helm install` commands.
```
$ helm install <name> <chart> --post-renderer helmys
```

That's it!
It's really that simple!


### Using `helmys` instead of `helm`

For convenience you can run any of these commands:
```
$ helmys install ...
$ helmys template ...
$ helmys upgrade ...
```

Instead of these commands:
```
$ helm install ... --post-renderer helmys
$ helm template ... --post-renderer helmys
$ helm upgrade ... --post-renderer helmys
```

When `helmys` is used in place of those `helm` commands it simply runs `helm`
with the same arguments and adds `--post-renderer helmys` to the end.


## Environment Variables

HelmYS has some environment variables that you might want to use.

These 3 are for debugging the YAML states during `helmys` post rendering.

* `HELMYS_DEBUG_INPUT=<file-name>`
  Name of a file to write the text that `helmys` read (from `helm`) on stdin.
* `HELMYS_DEBUG_THRUPUT=<file-name>`
  Name of a file to write the text after `helmys` altered it by moving the
  `helmys.yaml` template content to the front and adding the tags required by
  YAMLScript.
* `HELMYS_DEBUG_OUTPUT=<file-name>`
  Name of a file to write the text after `helmys` has evaluated everything as
  YAMLScript.

Templates using YAMLScript must start with a `!yamlscript/v0:` tag.
Use this in situations where a template may or may not have the tag but using
`helmys` is necessary:

* `HELMYS_AUTO_TAG=1`
  Add the `!yamlscript/v0:` to templates that don't have one.

See the shell function wrapping section below for:

* `HELMYS_PASSTHRU=1`
  Used to allow `--post-renderer helmys` to work on any chart.


## Try It Out

You can run `make test` which just runs the `test.sh` Bash script.

It creates a new Helm chart, runs `helmys init` on it, and then runs `helm
install` on it using the post renderer and printing all the commands as it
goes.

Next it does the same thing with all the templates converted to YAMLScript.

It writes all the YAML rendering transition states in files under
`test/debug/`.


### `make clean`

Removes the files generated by `make test`.


## Status

The `helmys` post renderer is in an ALPHA state, and being heavily tested.

At the present time, consider it a proof-of-concept that shows that YAMLScript
can be used with Helm 3.
Expects bugs, fixes and changes.

If you are interested in HelmYS please test it for us and report any bugs or
unexpected behaviors.

Remember you can use HelmYS with any amount of YAMLScript in your templates,
including no YAMLScript at all.


## License & Copyright

Copyright 2024-2025 Ingy döt Net <ingy@ingy.net>

This project is licensed under the terms of the `MIT` license.
See the [License](https://github.com/kubeys/helmys/blob/main/License) file for
more details.
