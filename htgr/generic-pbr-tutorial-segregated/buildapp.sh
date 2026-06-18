#!/bin/bash

cd ~/projects/virtual_test_bed || exit 1

python doc/moosedocs.py build --config doc/config.yml || exit 1

cd ~/.local/share/moose/site/htgr/generic-pbr-tutorial-segregated || exit 1

open index.html

cd ~/projects/virtual_test_bed/doc/content/htgr/generic-pbr-tutorial-segregated || exit 1