#!/usr/bin/env bash

set -euo pipefail

CHART=a-chart
NAME=name-$(date +%s)
HELMYS_INPUT=$PWD/helmys-install-input.yaml
HELMYS_THRUPUT=$PWD/helmys-install-thruput.yaml
HELMYS_OUTPUT=$PWD/helmys-install-output.yaml

command -v ys >/dev/null || {
  echo "ys not installed"
  exit 1
}

rm -fr "$CHART" "$HELMYS_INPUT"
rm -fr "$CHART" "$HELMYS_THRUPUT"
rm -fr "$CHART" "$HELMYS_OUTPUT"

(
  set -x

  PATH=$PWD/bin:$PATH
  HELMYS_INPUT=$HELMYS_INPUT
  HELMYS_THRUPUT=$HELMYS_THRUPUT
  HELMYS_OUTPUT=$HELMYS_OUTPUT
  export PATH HELMYS_INPUT HELMYS_THRUPUT HELMYS_OUTPUT

  helm create "$CHART"

  cp templates/helmys.yaml "$CHART"/templates/helmys.yaml
  cp templates/helpers.ys  "$CHART"/templates/helpers.ys

  helm install "$NAME" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED!!! ***\e[0m\n\n'
