#!/usr/bin/env ys-0

use ys::taptest: :all

when sh('which helm').exit.?:
  die: "Need 'helm' to run tests"

sh: 'rm -fr a-chart'


test::
- cmnd: 'helm create a-chart'
  want: Creating a-chart

- cmnd: helm template a-chart
  want:: read('test/helm-template-output.txt')

- cmnd: helm template a-chart --post-renderer=helmys
  want:: read('test/helmys-template-output.txt')

- cmnd: helmys template a-chart
  want:: read('test/helmys-template-output.txt')

- cmnd: helmys init a-chart
  want: ''

- code:: "fs-e:\ 'a-chart/templates/helmys.yaml'"
- code:: "fs-e:\ 'a-chart/templates/helpers.yaml'"

- cmnd: helmys template a-chart
  want:: read('test/helmys-template-output.txt')

- cmnd: cp test/templates/*.yaml a-chart/templates/
  want: ''

- cmnd: grep -rl YS-v0 a-chart
  want: |
    a-chart/templates/helpers.yaml
    a-chart/templates/helmys.yaml

- cmnd: helmys template a-chart
  want:: read('test/helmys-template-output.txt')

- cmnd: helmys template --validate a-chart
  want:: read('test/helmys-template-output.txt')

done:
