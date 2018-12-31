#!/bin/bash

if [ ! -d "${BAMBOO_AGENT_HOME}/bin" ]; then
  mkdir -p "${BAMBOO_AGENT_HOME}/bin"
fi

./runAgent.sh $@
