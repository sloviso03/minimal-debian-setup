#!/bin/bash

set -e

micro -plugin install lsp || true
micro -plugin install filemanager || true
micro -plugin install fzf || true
micro -plugin install manipulator || true
