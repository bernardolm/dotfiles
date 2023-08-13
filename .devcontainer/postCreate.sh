#!/usr/bin/env bash

echo "Hello world"

ln -sf "$PWD/.devcontainer/config" "$HOME/config" && set +x
