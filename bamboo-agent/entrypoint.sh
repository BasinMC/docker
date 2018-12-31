#!/bin/bash

if [ ! -d "${BAMBOO_AGENT_HOME}" ]; then
  mkdir -p "${BAMBOO_AGENT_HOME}/bin"
fi

./runAgent.sh
