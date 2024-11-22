HelmYS
======

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
$ helm install <name> <chart> --post-renderer=helmys
```


## Description

The `helmys` (pronounced "helm wise") command provides a way to use YAMLScript
for Helm templating.
You can use as much or as little [YAMLScript](https://yamlscript.org) in your
Helm templates as you wish, replacing all the Go templating syntax or none of
it.

Using YAMLScript for your templating needs is much cleaner than the standard Go
templating.
See this gist for a comparison of a full conversion:

<!-- XXX Replace gist with nicer yamlscript.org/doc/... page -->
https://gist.github.com/ingydotnet/b00a0dd3b7547088d6a1a85747b0c20d

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
> Also `ys` must be version `0.1.84` or higher.

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

This will install the `templates/helmys.yaml` file in your chart which is all
you need to start installing charts that use YAMLScript.

It is a YAMLScript port of the default `_helpers.tpl` Go template file.
It is used to define reusable variables and functions for use by the YAMLScript
in your templates.
This `helmys.ys` file supports everything for the templates generated by
`helm create`.
You are encouraged to add your own functions and variables to it.


## Using `helm install ... --post-renderer=helmys`

Just add the `--post-renderer=helmys` option to your `helm install` commands.
```
$ helm install <name> <chart> --post-renderer=helmys
```

That's it!
It's really that simple!


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
  Used to allow `--post-renderer=helmys` to work on any chart.


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


## Wrapping the `helm` Command

If you find yourself installing charts with Helm 3 and some of them use normal
Go syntax and some use YAMLScript, one thing you can choose to do is add a
wrapper function to your shell that makes it work for either.

This way you don't need to remember which rendering engine each chart uses.

Here's an example for Bash or Zsh:

```
helm() (
  set -e
  HELM=$(type -a helm);
  HELM=/${HELM##* /}
  [[ -x $HELM ]] || {
    echo "Can't find 'helm' command" >&2
    exit 1
  }
  if [[ ${1-} =~ ^(install|upgrade|template)$ ]]; then
    export HELMYS_PASSTHRU=1
    (set -x; "$HELM" "$@" --post-renderer=helmys)
  else
    "$HELM" "$@"
  fi
)
```

This will add the `--post-renderer=helmys` for you for `helm install` commands.

Note that `helmys` expects to find the `helmys.yaml` content it the data passed
to it.
Setting the environment variable `HELMYS_PASSTHRU=1` will make ignore that
check, thus allowing any chart to install with `--post-renderer=helmys`.

Also note that this is currently experimental and subject to change.


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

Copyright 2024 Ingy döt Net <ingy@ingy.net>

This project is licensed under the terms of the `MIT` license.
See the [License](https://github.com/kubeys/helmys/blob/main/License) file for
more details.
