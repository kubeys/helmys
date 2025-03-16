#!/usr/bin/env ys-0

use ys::taptest: :all

when sh('which helm').exit.?:
  die: "Need 'helm' to run tests"

sh: 'rm -fr a-chart'

helm-out =: read('test/helm-template-output.txt')
helmys-out =: read('test/helmys-template-output.txt')


test::
- cmnd: 'helm create a-chart'
  want: Creating a-chart

- cmnd: helm template a-chart
  want:: helm-out

- cmnd: helm template a-chart --post-renderer=helmys
  want:: helmys-out

- cmnd: helmys template a-chart
  want:: helmys-out

- cmnd: helmys init a-chart
  want: ''

- code:: "fs-e:\ 'a-chart/templates/helmys.yaml'"
- code:: "fs-e:\ 'a-chart/templates/helpers.yaml'"

- cmnd: helmys template a-chart
  want:: helmys-out

- cmnd: bash -c 'cp test/templates/*.yaml a-chart/templates/'
  want: ''

- cmnd: bash -c 'grep -rl YS-v0 a-chart | sort'
  want: |
    a-chart/templates/deployment.yaml
    a-chart/templates/helmys.yaml
    a-chart/templates/helpers.yaml
    a-chart/templates/serviceaccount.yaml
    a-chart/templates/service.yaml

- cmnd: helmys template a-chart
  want:: helmys-out

- cmnd: helmys template --validate a-chart
  want:: helmys-out

done:
