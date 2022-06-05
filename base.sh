#!/bin/bash
set -e
set -a

export BASE_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source $BASE_PATH/msg.sh
