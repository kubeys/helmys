helm-ys
=======

Support YAMLScript in Helm Templates


## Synopsis

```
$ helm install <name> <chart> --post-renderer helm-ys
```


## Description

The `helm-ys` command provides a way to use YAMLScript for Helm templating.
You can use as much or as little YAMLScript in your Helm templates, replacing
all the Go templating syntax or none of it.

Using YAMLScript for your templating needs is much cleaner than the standard Go
templating.
See this gist for a comparison of a full conversion:

https://gist.github.com/ingydotnet/2864511d24d90c0cc910bfa613c99d07


## Setting It Up

To use `helm-ys` you need:


### YAMLScript's `ys` 0.1.83 or higher installed

See:
* https://yamlscript.org/doc/install/
* https://github.com/yaml/yamlscript/releases

TLDR:
```
$ curl -s https://yamlscript.org/install | bash
```


### The `helpers.ys` file in your chart's main directory

This is a YAMLScript port of the default `_helpers.tpl` Go template file.
It is used to define resuable variables and functions for use by the YAMLScript
in your templates.

```
$ cp <here>/helpers.ys <chart>/helpers.ys
```


### The `helm-ys.yaml` file in your chart's `template/` directory.

This template gets data for the `Release` template variable.

```
$ cp <here>/helm-ys.yaml <chart>/templates/helm-ys.yaml
```


### The `helm-ys` Bash script file in your `PATH`

Just copy `<here>/helm-ys` into a directory that's in your `PATH` so `helm` can
find it.


### To use `--post-renderer`

You need to use `--post-renderer` to `helm install` with `helm-ys`.

```
$ helm install <name> <chart> --post-renderer helm-ys
```


## Try It Out

You can run `make test` which just runs the `test.sh` Bash script.
It creates a new Helm chart, adds the `helm-ys` stuff and runs `helm install`
on it.


## Notes

Just like `helm create` this repo provides a starter helper library which will
be in your chart as `helpers.ys`.

You are encourged to extend it to your personal needs.


## Status

This is very new stuff.

At the moment, it's a PoC to show that YAMLScript can be used with Helm.
Expects bugs, fixes and changes.

Please let us know what's wrong with it, and how it can be made better.


## Known Issues

At the moment you need to run `helm install` in your chart's root directory.
This will be fixed very soon.


## License & Copyright

Copyright 2024 Ingy döt Net <ingy@ingy.net>

This project is licensed under the terms of the `MIT` license.
See the [License](https://github.com/yaml/helm-ys/blob/main/License) file for
more details.
