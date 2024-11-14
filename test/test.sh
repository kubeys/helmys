#!/usr/bin/env bash

set -euo pipefail

CHART=a-chart
NAME=name-$(date +%s)
HELMYS_OUTPUT=$PWD/helmys-install-output.yaml

command -v ys >/dev/null || {
  echo "ys not installed"
  exit 1
}

rm -fr "$CHART" "$HELMYS_OUTPUT"

(
  set -x

  PATH=$PWD/bin:$PATH
  HELMYS_OUTPUT=$HELMYS_OUTPUT
  export PATH HELMYS_OUTPUT

  helm create "$CHART"

  cp templates/helmys.yaml "$CHART"/templates/helmys.yaml
  cp templates/helpers.ys  "$CHART"/templates/helpers.ys

  helm install "$NAME" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED!!! ***\e[0m\n\n'
