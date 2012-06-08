#!/bin/sh

nohup bin/build.sh $(cat build-list.txt) >build.log 2>&1

