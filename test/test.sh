#!/usr/bin/env bash

set -euo pipefail

export HELMYS_TEST=1
export PATH=$PWD/bin:$PATH

CHART=a-chart
NAME=name-$(date +%s)
LOG=test/log

command -v ys >/dev/null || {
  echo "ys not installed"
  exit 1
}

rm -fr "$CHART" "$LOG"
mkdir -p "$LOG"

(
  set -x

  helm create "$CHART"

  export HELMYS_PASS_THROUGH=1

  helm install "$NAME-pass" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED (w/ HELMYS_PASS_THROUGH=1) ***\e[0m\n\n'

(
  set -x

  HELMYS_INPUT=$LOG/GO-helmys-install-input-go.yaml
  HELMYS_THRUPUT=$LOG/GO-helmys-install-thruput-go.yaml
  HELMYS_OUTPUT=$LOG/GO-helmys-install-output-go.yaml
  export HELMYS_INPUT HELMYS_THRUPUT HELMYS_OUTPUT

  helmys init "$CHART"

  helm install "$NAME-go" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED (w/ stock Go templates) ***\e[0m\n\n'

(
  set -x

  HELMYS_INPUT=$LOG/YS-helmys-install-input.yaml
  HELMYS_THRUPUT=$LOG/YS-helmys-install-thruput.yaml
  HELMYS_OUTPUT=$LOG/YS-helmys-install-output.yaml
  export HELMYS_INPUT HELMYS_THRUPUT HELMYS_OUTPUT

  cp test/templates/*.yaml "$CHART/templates/"

  helm install "$NAME-ys" "$CHART" --post-renderer=helmys
)

echo $'\n\n\e[32m*** IT WORKED (w/ all YAMLScript templates) ***\e[0m\n\n'
