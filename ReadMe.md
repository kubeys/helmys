helmys
======

Helm + YS - Support YAMLScript in Helm Templates


## Synopsis

```
$ git clone https://github.com/kubeys/helmys
$ make -C helmys install PREFIX=~/.local
$ helmys init <chart>
$ helm install <name> <chart> --post-renderer=helmys
```


## Description

The `helmys` (pronounced "helm wise") command provides a way to use YAMLScript
for Helm templating.
You can use as much or as little YAMLScript in your Helm templates, replacing
all the Go templating syntax or none of it.

Using YAMLScript for your templating needs is much cleaner than the standard Go
templating.
See this gist for a comparison of a full conversion:

https://gist.github.com/ingydotnet/c0afc0071133c696c5b4f17b5ee86b98


## Setting It Up

Setting up helmys is very simple.
Just install helmys and ys, then initialize your chart.

### Installing helmys and ys

In this directory, run:
```
make install PREFIX=~/.local`
```

This will install `helmys` in `$PREFIX/bin/`.
It will also install the YAMLScript binary `ys` in `$PREFIX/bin` if it is not
already there.

Note: `ys` must be version `0.1.84` or higher.


## Initializing your chart

Run:
```
helmys init <chart-dir>
```

This will install 2 files in your chart's template directory:

* `helmys.yaml`
  This template gets data for the `Release` template variable.
* `helpers.ys`
  This is a YAMLScript port of the default `_helpers.tpl` Go template file.
  It is used to define reusable variables and functions for use by the
  YAMLScript in your templates.
  This `helpers.ys` file supports everything for the templates generated by
  `helm create`.
  You are encouraged to add your own functions and variables to it.


## Using `helmys` with `helm install`

Add the `--post-renderer=helmys` option to your `helm install` commands.


## Try It Out

You can run `make test` which just runs the `test.sh` Bash script.
It creates a new Helm chart, adds the `helmys` stuff and runs `helm install`
on it.


## Status

This is very new stuff.

At the moment, it's a PoC to show that YAMLScript can be used with Helm 3.
Expects bugs, fixes and changes.

Please let us know what's wrong with it, and how it can be made better.


## License & Copyright

Copyright 2024 Ingy döt Net <ingy@ingy.net>

This project is licensed under the terms of the `MIT` license.
See the [License](https://github.com/kubeys/helmys/blob/main/License) file for
more details.
