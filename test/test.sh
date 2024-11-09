#!/usr/bin/env bash

set -euo pipefail

CHART=a-chart
NAME=name-$(date +%s)
HELM_YS_OUTPUT=$PWD/helmys-install-output.yaml

command -v ys >/dev/null || {
  echo "ys not installed"
  exit 1
}

rm -fr "$CHART" "$HELM_YS_OUTPUT"

(
  set -x

  export PATH=$PWD/bin:$PATH

  helm create "$CHART"

  cp templates/helmys.yaml "$CHART"/templates/helmys.yaml
  cp templates/helpers.ys   "$CHART"/templates/helpers.ys

  export HELM_YS_OUTPUT=$HELM_YS_OUTPUT

  # helm install "$NAME" "$CHART" --post-renderer helmys
  (
    cd "$CHART"
    helm install "$NAME" . --post-renderer helmys
  )
)

echo $'\n\n\e[32m*** IT WORKED!!! ***\e[0m\n\n'
