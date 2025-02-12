#!/usr/bin/env bash

set -euo pipefail

export HELMYS_TEST=1
export PATH=$PWD/bin:$PATH

CHART=a-chart
NAME=name-$(date +%s)
DEBUG=test/debug

die() {
  printf '%s\n' "$@"
  exit 1
}

command -v ys >/dev/null ||
  die "ys not installed"

rm -fr "$CHART" "$DEBUG"
mkdir -p "$DEBUG"

(
  set -x

  helm create "$CHART"

  export HELMYS_PASSTHRU=1

  helm install "$NAME-pass" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED (w/ HELMYS_PASSTHRU=1) ***\e[0m\n\n'

(
  set -x

  HELMYS_DEBUG_INPUT=$DEBUG/GO-helmys-install-input-go.yaml
  HELMYS_DEBUG_THRUPUT=$DEBUG/GO-helmys-install-thruput-go.yaml
  HELMYS_DEBUG_OUTPUT=$DEBUG/GO-helmys-install-output-go.yaml
  export HELMYS_DEBUG_INPUT HELMYS_DEBUG_THRUPUT HELMYS_DEBUG_OUTPUT

  helmys init "$CHART"

  helm install "$NAME-go" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED (w/ stock Go templates) ***\e[0m\n\n'

(
  set -x

  HELMYS_DEBUG_INPUT=$DEBUG/YS-helmys-install-input.yaml
  HELMYS_DEBUG_THRUPUT=$DEBUG/YS-helmys-install-thruput.yaml
  HELMYS_DEBUG_OUTPUT=$DEBUG/YS-helmys-install-output.yaml
  export HELMYS_DEBUG_INPUT HELMYS_DEBUG_THRUPUT HELMYS_DEBUG_OUTPUT

  cp test/templates/*.yaml "$CHART/templates/"

  helmys install "$NAME-ys" "$CHART"
)

echo $'\n\n\e[32m*** IT WORKED (w/ all YS templates) ***\e[0m\n\n'
