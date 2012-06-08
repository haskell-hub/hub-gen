#!/bin/bash

if [ x${RPM_BUILD_ROOT} != x -a -d ${RPM_BUILD_ROOT} ]; then

    echo "clearing out ${RPM_BUILD_ROOT}"
    rm -rf ${RPM_BUILD_ROOT};
    
fi
