#!/usr/bin/env bash

set -euo pipefail

CHART=a-chart
NAME=name-$(date +%s)
HELM_YS_OUTPUT=$PWD/helm-ys-install-output.yaml

command -v ys >/dev/null || {
  echo "ys not installed"
  exit 1
}

rm -fr "$CHART" "$HELM_YS_OUTPUT"

(
  set -x

  export PATH=$PWD/bin:$PATH

  helm create "$CHART"

  cp templates/helm-ys.yaml "$CHART"/templates/helm-ys.yaml
  cp templates/helpers.ys   "$CHART"/templates/helpers.ys

  export HELM_YS_OUTPUT=$HELM_YS_OUTPUT

  # helm install "$NAME" "$CHART" --post-renderer helm-ys
  (
    cd "$CHART"
    helm install "$NAME" . --post-renderer helm-ys
  )
)

echo $'\n\n\e[32m*** IT WORKED!!! ***\e[0m\n\n'
