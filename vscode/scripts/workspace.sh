#!/bin/sh

envsubst < ~/sync/shared/vs.code-workspace > ~/sync/$OS/vs.code-workspace
code ~/sync/$OS/vs.code-workspace
